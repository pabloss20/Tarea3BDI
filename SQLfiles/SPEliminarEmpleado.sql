CREATE PROCEDURE BorrarEmpleadosMasivo
    @Username NVARCHAR(255), -- Nombre de usuario que realiza la operación
    @IdsEmpleados NVARCHAR(MAX), -- Cadena con los IDs de empleados a borrar (separados por comas)
    @Resultado INT OUT,
    @Mensaje NVARCHAR(MAX) OUT
AS
BEGIN
    BEGIN TRY
        -- Verifica si el usuario tiene permisos para realizar la operación (puedes implementar tu lógica de seguridad aquí)

        -- Realiza el borrado lógico de los empleados cuyos IDs estén en la lista
        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = 'UPDATE Empleados SET Activo = 0 WHERE Id IN (' + @IdsEmpleados + ');'
        EXEC sp_executesql @SQL;

        -- Registra la operación en un registro de auditoría o historial (opcional)

        SET @Resultado = 1; -- Éxito
        SET @Mensaje = 'Empleados eliminados con éxito.';
    END TRY
    BEGIN CATCH
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

        -- Establece @Resultado en 0 y @Mensaje con un mensaje de error
        SET @Resultado = 0;
        SET @Mensaje = ERROR_MESSAGE();
    END CATCH
END;
