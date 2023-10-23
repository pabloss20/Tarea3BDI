USE [ControlPlanillaDB]
GO
/****** Object:  StoredProcedure [dbo].[BorrarEmpleadosMasivo]    Script Date: 23/10/2023 16:47:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BorrarEmpleadosMasivo]
    @Username NVARCHAR(255), -- Nombre de usuario que realiza la operación
    @IdsEmpleados NVARCHAR(MAX), -- Cadena con los IDs de empleados a borrar (separados por comas)
    @Resultado INT OUT,
    @Mensaje NVARCHAR(MAX) OUT
AS
BEGIN
    BEGIN TRY
        -- Inicia la transacción
        BEGIN TRANSACTION;

        -- Obtener el IdUsuario a partir del Username
        DECLARE @IdUsuario INT;
        SELECT @IdUsuario = EmpleadoId FROM Usuarios WHERE Username = @Username;

        -- Realiza el borrado lógico de los empleados cuyos IDs estén en la lista
        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = 'UPDATE Empleados SET Activo = 0 WHERE Id IN (' + @IdsEmpleados + ');'
        EXEC sp_executesql @SQL;

        -- Registra el evento en la tabla BitacoraEventos
        INSERT INTO BitacoraEventos (IdUsuario, IP, FechaHora, IdTipoEvento, Parametros)
        VALUES (@IdUsuario, '127.0.0.1', GETDATE(), 1, 'Borrado lógico de empleados: ' + @IdsEmpleados);

        -- Confirma la transacción
        COMMIT;

        SET @Resultado = 1; -- Éxito
        SET @Mensaje = 'Empleados eliminados con éxito.';
    END TRY
    BEGIN CATCH
        -- En caso de error, deshace la transacción
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END;

        -- Registra el error en la tabla [dbo].[DBErrors]
        INSERT INTO [dbo].[DBErrors] 
        (
            [UserName],
            [ErrorNumber],
            [ErrorState],
            [ErrorSeverity],
            [ErrorLine],
            [ErrorProcedure],
            [ErrorMessage],
            [ErrorDateTime]
        )
        VALUES (
            @Username,
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        SET @Resultado = 0;
        SET @Mensaje = 'Error al realizar el borrado lógico de empleados.';
    END CATCH
END;