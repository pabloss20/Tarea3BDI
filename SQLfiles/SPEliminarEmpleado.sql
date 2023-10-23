CREATE PROCEDURE BorrarEmpleadosMasivo
    @Username NVARCHAR(255), -- Nombre de usuario que realiza la operaci�n
    @IdsEmpleados NVARCHAR(MAX), -- Cadena con los IDs de empleados a borrar (separados por comas)
    @Resultado INT OUT,
    @Mensaje NVARCHAR(MAX) OUT
AS
BEGIN
    BEGIN TRY
        -- Verifica si el usuario tiene permisos para realizar la operaci�n (puedes implementar tu l�gica de seguridad aqu�)

        -- Realiza el borrado l�gico de los empleados cuyos IDs est�n en la lista
        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = 'UPDATE Empleados SET Activo = 0 WHERE Id IN (' + @IdsEmpleados + ');'
        EXEC sp_executesql @SQL;

        -- Registra la operaci�n en un registro de auditor�a o historial (opcional)

        SET @Resultado = 1; -- �xito
        SET @Mensaje = 'Empleados eliminados con �xito.';
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
