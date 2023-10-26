CREATE PROCEDURE [dbo].[EditarEmpleado]
    @Id INT,
    @Nombre VARCHAR(255),
    @TipoDocIdentidadId INT,
    @ValorDocIdentidad VARCHAR(50),
    @FechaNacimiento DATE,
    @PuestoId INT,
    @DepartamentoId INT,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Actualizar la información del empleado
        UPDATE Empleados
        SET 
            Nombre = @Nombre,
            IdTipoDocIdentidad = @TipoDocIdentidadId,
            ValorDocIdentidad = @ValorDocIdentidad,
            FechaNacimiento = @FechaNacimiento,
            IdPuesto = @PuestoId,
            IdDepartamento = @DepartamentoId
        WHERE Id = @Id;

        -- Registrar el evento en la tabla BitacoraEventos
        DECLARE @EmpleadoId INT;
        SET @EmpleadoId = @Id;

        INSERT INTO BitacoraEventos (IdUsuario, IP, FechaHora, IdTipoEvento, Parametros)
        VALUES (@EmpleadoId, '127.0.0.1', GETDATE(), 3, 'Empleado actualizado');

        -- Establecer valores de salida
        SET @Resultado = 1;
        SET @Mensaje = 'Empleado actualizado exitosamente';

        -- Confirmar la transacción
        COMMIT;
    END TRY
    BEGIN CATCH
        -- En caso de error, deshacer la transacción
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END;

        -- Registra el error en la tabla [dbo].[DBErrors]
        INSERT INTO [dbo].[DBErrors] 
        (
            [UserName]
            ,[ErrorNumber]
            ,[ErrorState]
            ,[ErrorSeverity]
            ,[ErrorLine]
            ,[ErrorProcedure]
            ,[ErrorMessage]
            ,[ErrorDateTime]
        )
        VALUES (
            USER_NAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        -- Establecer valores de salida en caso de error
        SET @Resultado = 0;
        SET @Mensaje = 'Error al actualizar el empleado: ' + ERROR_MESSAGE();
    END CATCH;

    SET NOCOUNT OFF;
END;