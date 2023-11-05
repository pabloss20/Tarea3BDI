
USE DB_AsistenciaEmpleados
GO
-- un job invoca el SP que acredita vacaciones x cumple mes.

-- Hacemos que el proceso para TODOS los empleados sea transaccional pero no todo el proceso lo es
-- version iterativa

CREATE PROCEDURE [dbo].[SP_CargarDatosXMLIterativo]
	@inIdUser INT
	, @inUsername VARCHAR(16)
	, @inPostIP VARCHAR(64)
    , @inRutaXML NVARCHAR(500)
	, @outRetorno BIT OUTPUT
	, @outMessage VARCHAR(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	/*
		DECLARE @lo INT = 1				-- variable para iterar
			, @hi INT					-- variable para limitar la iteracion
			, @idEmpleado INT
			, @SaldoActual FLOAT
			, @TextoEmail TEXT
			, @idComprobante
			, @IDTIPOMOVIMIENTO INT = 3   -- ALAMBRADO, Para denotar que son constantes, declara
			, @MONTOCREDITO INT =1 
			, @EVENTACREDITATODOS INT = 7
			;
	
		DECLARE @EmpleadosCumplen TABLE(
			Sec INT IDENTITY(1,)
			, IdEmpleado INT
			, SaldoActual FLOAT
			, textoemail TEXT
			);
		*/
		-- control de que el proceso no se este corriendo 2 veces

		-- Saca la infor del archivo XML
		DECLARE @xmlData XML;
				SET @xmlData = (
				SELECT *
				FROM OPENROWSET(BULK 'C:\Users\yeico\Desktop\BDTarea2\XML\Datos.xml', SINGLE_BLOB) 
				AS xmlData
				);
	/*
		INSERT @empleadosCumplen (
			IdEmpleado
			, SaldoActual
			, textoemail
		)
		SELECT e.id
			e.SaldoVacaciones
			, 'Felicidades, ha cumplico nuevo mes de trabajo, 1 dia mas vacaciones, nuevo saldo'+convert(varchar, dbo.FNSumaSaldo(e.SaldoVacaciones, 1))
		FROM dbo.Empleado E
		WHERE dbo.FNCumplemes(E.FechaContratacion, @inFechaOperacion)=1;
	
		SELECT @hi = max(E.sec) FROM @empleadosCumplen E;
	*/
		SET @hi = 

		BEGIN TRANSACTION tinsertarDatos

			WHILE (@lo<=@hi)
			BEGIN
			
				SELECT @idempleado=E.IdEmpleado
					, @SaldoActual=E.SaldoActual
					, @TextoEmail=E.TextoEmail
				FROM @empleadosCumplen E
				WHERE E.Sec=@lo;			
				
				INSERT dbo.Comprobante (
					idEmpleado
					, TextEmail
				)
				values (
					@idempleado
					, @TextoEmail
				)
				
				SET @idComprobante=SCOPE_IDENTITY();		-- para vincular el FK
				
				INSERT dBO.Moviminento  (idempleado, idComprobante, idtipomovimiento, fecha, monto)
				values (@idempleado, @idComprobante, @IDTIPOMOVIMIENTO, @inFechaOperacion, @MONTOCREDITO);
				
				UPDATE dbo.Empleado (ROWLOCK)
				SET SaldoVacaciones=@SaldoActual+@MONTOCREDITO
				where iD=@idempleado	

				SET @lo=@lo+1;
			
			END;
		
			INSERT dbo.Eventlog (IdEventType, EventDate, Description)
			VALUES (@EVENTACREDITATODOS, @inFechaOperacion, 'Finalizo exitosamente');

		COMMIT TRANSACTION tinsertarDatos;

		SELECT @outResult as outResult; 
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0 BEGIN
			ROLLBACK tacreditaTodos;				-- para asegurar el "nada"
		END;
	
		INSERT dbErrors ()
		Select ....
	
	
		SET @OutResult = 50005;   -- error en BD
		SELECT @outResult as outResult
	END CATCH

	SET NOCOUNT OFF;

END;