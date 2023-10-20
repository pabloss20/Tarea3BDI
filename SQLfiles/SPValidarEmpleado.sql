USE [ControlPlanillaDB]
GO
/****** Object:  StoredProcedure [dbo].[ValidarEmpleado]    Script Date: 20/10/2023 04:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ValidarEmpleado]
    @Username VARCHAR(255),
    @Password VARCHAR(255),
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(MAX) OUTPUT,
    @Tipo INT OUTPUT,
    @TipoIdEmpleado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Iniciar la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @EmpleadoID INT;
    
        -- Inicializar valores de salida
        SET @Resultado = 0;
        SET @Mensaje = '';
        SET @Tipo = 0;
        SET @TipoIdEmpleado = 0;

        -- Validar el usuario y contraseña
        IF EXISTS (SELECT 1 FROM Usuarios WHERE Username = @Username AND Password = @Password)
        BEGIN
            -- Obtener el EmpleadoID
            SELECT @EmpleadoID = Id FROM Usuarios WHERE Username = @Username;

            -- Verificar si el empleado es administrador o empleado
            SELECT @Tipo = Tipo FROM Usuarios WHERE Id = @EmpleadoID;

            -- Establecer el resultado a 1 (éxito) y definir el mensaje
            SET @Resultado = 1;
            SET @Mensaje = 'Acceso concedido';

            -- Registrar el evento en la tabla BitacoraEventos
            INSERT INTO BitacoraEventos (IdUsuario, IP, FechaHora, IdTipoEvento, Parametros)
            VALUES (@EmpleadoID, '127.0.0.1', GETDATE(), 1, 'Usuario autenticado');
        END
        ELSE
        BEGIN
            -- En caso de fallo, establecer el resultado a 0 (fallido) y definir el mensaje
            SET @Resultado = 0;
            SET @Mensaje = 'Acceso denegado';

            -- Registrar el evento de acceso denegado en la tabla BitacoraEventos
            INSERT INTO BitacoraEventos (IdUsuario, IP, FechaHora, IdTipoEvento, Parametros)
            VALUES (NULL, '127.0.0.1', GETDATE(), 2, 'Intento de acceso fallido');
        END;

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
            @Username,
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        -- Establecer el resultado a 0 (fallido) y definir el mensaje de error
        SET @Resultado = 0;
        SET @Mensaje = 'Error al validar el acceso';
    END CATCH;

    SET NOCOUNT OFF;
END;
