--USE ControlPlanillaDB
--GO

--USE DB_AsistenciaEmpleados
--GO

ALTER PROCEDURE [dbo].[SP_CargarCatalogosXMLConRuta]
    -- Parametro de entrada
	@inIdUser INT
	, @inUsername VARCHAR(16)
	, @inPostIP VARCHAR(64)
    , @inRutaXML NVARCHAR(500)
	, @outRetorno BIT OUTPUT
	, @outMessage VARCHAR(100) OUTPUT
AS
BEGIN

	BEGIN TRY
	
		DECLARE @Datos xml/*Declaramos la variable Datos como un tipo XML*/

		DECLARE @outDatos xml -- parametro de salida del sql dinamico

		 -- Para cargar el archivo con una variable, CHAR(39) son comillas simples
		DECLARE @Comando NVARCHAR(500)= 'SELECT @Datos = D FROM OPENROWSET (BULK '  + CHAR(39) + @inRutaXML + CHAR(39) + ', SINGLE_BLOB) AS Datos(D)' -- comando que va a ejecutar el sql dinamico

		DECLARE @Parametros NVARCHAR(500)

		SET @Parametros = N'@Datos xml OUTPUT' --parametros del sql dinamico

		EXECUTE sp_executesql @Comando, @Parametros, @Datos = @outDatos OUTPUT -- ejecutamos el comando que hicimos dinamicamente

		SET @Datos = @outDatos -- le damos el parametro de salida del sql dinamico a la variable para el resto del procedure
    
		DECLARE @hdoc int /*Creamos hdoc que va a ser un identificador*/
    
		EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/
		
		BEGIN TRANSACTION tcargarCatalogos

			--- SE INSERTAN LOS DATOS EN LA TABLA TipoDocumentoIdentidad
			INSERT INTO [dbo].[TiposdeDocumentodeIdentidad]
					   ([Id]
						, [Nombre])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposdeDocumentodeIdentidad/TipoDocuIdentidad' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
			PATH del nodo y el 1 que sirve para retornar solo atributos*/
			WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
				Id INT
				, Nombre VARCHAR(255)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA TipoJornada
			INSERT INTO [dbo].[TiposDeJornadas]
							([Id]
							, [Nombre]
							, [HoraInicio]
							, [HoraFin])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposDeJornadas/TipoDeJornada' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				, HoraInicio TIME
				, HoraFin TIME
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA Puestos
			INSERT INTO [dbo].[Puestos]
					   ([Nombre]
					   , [SalarioXHora])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/Puestos/Puesto' , 1)
			WITH(
				Nombre VARCHAR(255)
				, SalarioXHora DECIMAL(10, 2)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA Departamentos
			INSERT INTO [dbo].[Departamentos]
					   ([Id]
					   , [Nombre])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/Departamentos/Departamento' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA Feriados
			INSERT INTO [dbo].[Feriados]
					   ([Id]
					   , [Nombre]
					   , [Fecha])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/Feriados/Feriado' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				, Fecha DATE
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA TipoMovimientoPlanilla
			INSERT INTO [dbo].[TiposDeMovimiento]
					   ([Id]
					   , [Nombre])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposDeMovimiento/TipoDeMovimiento' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA TipoDeduccion
			INSERT INTO [dbo].[TiposDeDeduccion]
					   ([Id]
					   , [Nombre]
					   , [Obligatorio]
					   , [Porcentual]
					   , [Valor])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposDeDeduccion/TipoDeDeduccion' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				, Obligatorio NVARCHAR(2)
				, Porcentual NVARCHAR(2)
				, Valor DECIMAL(10, 4)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA Usuarios
			INSERT INTO [dbo].[UsuariosAdministradores]
					   ([Username]
					   , [Password]
					   , [Tipo])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/UsuariosAdministradores/Usuario' , 1)
			WITH(
				Username VARCHAR(255)
				, Pwd VARCHAR(255)
				, tipo INT
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA TiposDeEvento
			INSERT INTO [dbo].[TiposDeEvento]
					   ([Id]
					   , [Nombre])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposdeEvento/TipoEvento' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				)

			-- Para guardarlo en los parametros de la bitacora
			DECLARE @json NVARCHAR(MAX);
			SET @json = '{"IdUsuario": "' + CONVERT(NVARCHAR, @inIdUser) + '", "Username": "' + @inUsername + 
			'", "PostIP": "' + @inPostIP + '", "Path": "' + @inRutaXML + '", "Resultado": ' + CAST(@outRetorno AS NVARCHAR(1)) + '}';

			-- Se insertan los valores en la tabla BitacoraEventos
			INSERT INTO dbo.BitacoraEventos
			(
				IdUsuario
				, IP
				, FechaHora
				, IdTipoEvento
				, Parametros
			)
			VALUES 
			(
				@inIdUser
				, @inPostIP
				, GETDATE()
				, 16 /* HAY QUE REVISAR SI SE AGREGA A UN ADENDUM DE LA ESPECIF. DEL PROYECTO,
				YA QUE NO SE ENCUENTRA PARA CARGAR CATALOGOS*/
				, @json
			)

		COMMIT TRANSACTION tcargarCatalogos

		EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/

		SET @outRetorno = 1
		Set @outMessage = 'Agregados los datos de prueba exitosamente.'

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0
		BEGIN
			ROLLBACK TRANSACTION tcargarCatalogos;
		END;

		-- Registra el error en la tabla dbo.DBErrors
        INSERT INTO dbo.DBErrors
        (
            UserName
          , ErrorNumber
          , ErrorState
          , ErrorSeverity
          , ErrorLine
          , ErrorProcedure
          , ErrorMessage
          , ErrorDateTime
        )
        VALUES
        (
            @inUsername
          , ERROR_NUMBER()
          , ERROR_STATE()
          , ERROR_SEVERITY()
          , ERROR_LINE()
          , ERROR_PROCEDURE()
          , ERROR_MESSAGE()
          , GETDATE()
        )

		EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/

		SET @outRetorno = 0
		Set @outMessage = 'Hubo un error al agregar los datos de prueba'

	END CATCH
	
	SET NOCOUNT OFF;

END


