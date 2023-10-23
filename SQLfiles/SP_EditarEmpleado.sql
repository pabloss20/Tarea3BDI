﻿USE [ControlPlanillaDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EditarEmpleado]
(
	@inIdUser INT
	, @inUsername VARCHAR(16)
	, @inPostIP VARCHAR(64)
	, @inNombre VARCHAR(255)
	, @inAnteriorNombre VARCHAR(255)
	, @inTipoDocIdent VARCHAR(255)
	, @inAnteriorTipoDocIdent VARCHAR(255)
	, @inValorDocIdent VARCHAR(50)
	, @inAnteriorValorDocIdent VARCHAR(50)
	, @inFechaNac DATE
	, @inAnteriorFechaNac DATE
	, @inPuesto VARCHAR(255)
	, @inAnteriorPuesto VARCHAR(255)
	, @inDepart VARCHAR(255)
	, @inAteriorDepart VARCHAR(255)
	, @outRetorno BIT OUTPUT
	, @outMessage VARCHAR(100) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
		
		BEGIN TRANSACTION tActualizarEmp

            -- Actualiza el empleado
			UPDATE dbo.Empleados
			SET Nombre = @inNombre
			, IdTipoDocIdentidad = (SELECT Id FROM dbo.TipoDocumentoIdentidad
									WHERE Nombre = @inTipoDocIdent)
			, ValorDocIdentidad = @inValorDocIdent
			, FechaNacimiento = @inFechaNac
			, IdPuesto = (SELECT Id FROM dbo.Puestos
									WHERE Nombre = @inPuesto)
			, IdDepartamento = (SELECT Id FROM dbo.Departamentos
									WHERE Nombre = @inDepart)
			WHERE ValorDocIdentidad = @inValorDocIdent

			-- Insertar en la tabla BitáoraEventos
			INSERT INTO dbo.BitacoraEventos(
					IdUsuario
					, IP
					, FechaHora
					, IdTipoEvento
					, Parametros
					)
			VALUES (
					@inIdUser
					, @inPostIP
					, GETDATE()
					, 11 --Según los datos de prueba
					, 'Parámetros: 1.' + @inIdUser + ', 2.' + @inUsername + ', 3.' +
					@inPostIP + '4.' +'' + '.'
					-- La descripción de lo que sucedió en el evento en vez de los parámetros
					-- Se cambia hasta que el profe diga
					--, @outMessage
					);
		
		COMMIT TRANSACTION tActualizarEmp

		SET @outRetorno = 1
        SET @outMessage = 'Empleado actualizado exitosamente.'

    END TRY
    BEGIN CATCH

		IF @@TRANCOUNT>0
		BEGIN
			ROLLBACK TRANSACTION tActualizarEmp;
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
        SET @outRetorno = 0           
        SET @outMessage = ERROR_MESSAGE()
    END CATCH

END