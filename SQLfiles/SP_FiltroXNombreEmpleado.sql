USE ControlPlanillaDB
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_FiltroXNombreEmpleado]
(
	@inIdUser INT
	, @inUsername VARCHAR(16)
	, @inPostIP varchar(64)
	, @inStringCajaDeTexto VARCHAR(128)
	, @outRetorno BIT OUTPUT
	, @outMessage VARCHAR(100) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON; -- Evitar la salida de filas afectadas

		IF(@inStringCajaDeTexto = '')
		BEGIN
			/*
			La prioridad es: primero la operación JOIN, y luego lo que resta de operaciones sobre las tablas
			Como estamos "combinando" las tablas usando la operación JOIN, podemos en un mismo SELECT acceder
			a atributos de ambas tablas.
			*/
			SELECT  E.Nombre, P.Nombre
			FROM dbo.Empleados AS E
			INNER JOIN dbo.Puestos AS P
			ON E.IdPuesto = P.Id
			ORDER BY E.Nombre ASC

		END
		ELSE
		BEGIN
			/*
			Hicimos lo mismo de combinar atributos de ambas tablas en un mismo SELECT
			*/
			SELECT  E.Nombre, P.Nombre
			FROM dbo.Empleados AS E
			INNER JOIN dbo.Puestos AS P
			ON E.IdPuesto = P.Id
			WHERE LOWER(E.Nombre)
			LIKE LOWER('%' + @inStringCajaDeTexto + '%')
		END

		SET @outRetorno = 1
		Set @outMessage = 'Consulta por nombre con filtro exitosa'

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
			, 4
			, 'Parámetros: 1.' + @inIdUser + ', 2.' + @inUsername + ', 3.' +
				@inPostIP + '4.' + @inStringCajaDeTexto + '.'
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