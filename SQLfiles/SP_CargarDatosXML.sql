USE ControlPlanillaDB
GO

ALTER PROCEDURE [dbo].[SP_CargarDatosXML]
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
		
		BEGIN TRANSACTION tcargarDatosPrueba

			--- SE INSERTAN LOS DATOS EN LA TABLA TipoDocumentoIdentidad
			INSERT INTO [dbo].[TipoDocumentoIdentidad]
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
			INSERT INTO [dbo].[TipoJornada]
							([Id]
							, [Nombre]
							, [HoraInicio]
							, [HoraFin])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposdeJornadas/TipodeJornada' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				, HoraInicio TIME
				, HoraFin TIME
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA Puestos
			INSERT INTO [dbo].[Puestos]
					   ([Id]
					   , [Nombre]
					   , [SalarioXHora])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/Puestos/Puesto' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
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
			INSERT INTO [dbo].[TipoMovimientoPlanilla]
					   ([Id]
					   , [Nombre])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposDeMovimiento/TipoDeMovimiento' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA TipoDeduccion
			INSERT INTO [dbo].[TipoDeduccion]
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
				, Obligatorio BIT
				, Porcentual BIT
				, Valor DECIMAL(10, 2)
				)

			--- SE INSERTAN LOS DATOS EN LA TABLA Usuarios
			INSERT INTO [dbo].[Usuarios]
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

			--- SE INSERTAN LOS DATOS EN LA TABLA TiposdeEvento
			INSERT INTO [dbo].[TiposdeEvento]
					   ([Id]
					   , [Nombre])
			SELECT *
			FROM OPENXML (@hdoc, '/Catalogos/TiposdeEvento/TipoEvento' , 1)
			WITH(
				Id INT
				, Nombre VARCHAR(255)
				)

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
				YA QUE NO SE ENCUENTRA PARA CARGAR DATOS DE PRUEBA*/
				, 'Parámetros: 1.' + @inIdUser + ', 2.' + @inUsername + ', 3.' +
					@inPostIP + '4.' + @inRutaXML + '.'
			)

		COMMIT TRANSACTION tcargarDatosPrueba

		EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/

		SET @outRetorno = 1
		Set @outMessage = 'Agregados los datos de prueba exitosamente.'

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0
		BEGIN
			ROLLBACK TRANSACTION tcargarDatosPrueba;
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


