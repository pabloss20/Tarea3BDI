USE ControlPlanillaDB
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ListarEmpleados]
(
	@inIdUser INT
	, @inUsername VARCHAR(16)
	, @inPostIP varchar(64)
	, @outRetorno BIT OUTPUT
	, @outMessage VARCHAR(100) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		SELECT  E.Nombre, P.Nombre
		FROM dbo.Empleados AS E
		INNER JOIN dbo.Puestos AS P
		ON E.IdPuesto = P.Id
		ORDER BY E.Nombre ASC

		SET @outRetorno = 1
		Set @outMessage = 'Mostrados todos los usuarios exitosamente.'

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
			, 3 -- Según el archivo XML de datos de prueba
			, 'Parámetros: 1.' + @inIdUser + ', 2.' + @inUsername + ', 3.' +
				@inPostIP + '.'
		)

	END TRY
	BEGIN CATCH

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
		SET @outRetorno = 0			
		SET @outMessage = ERROR_MESSAGE()
	END CATCH
END