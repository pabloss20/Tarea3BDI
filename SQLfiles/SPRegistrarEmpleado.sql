USE [ControlPlanillaDB]
GO
/****** Object:  StoredProcedure [dbo].[RegistrarEmpleado]    Script Date: 19/10/2023 09:49:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[RegistrarEmpleado]
(
    @Nombre VARCHAR(255)
	,@IdDocIdentidad INT
	,@ValorDocIdentidad VARCHAR(64)
	,@FechaNacimiento VARCHAR(64)
	,@IdPuesto INT
	,@IdDepartamento INT
	,@Activo INT
    ,@Username VARCHAR(255)
    ,@Password VARCHAR(255)
    ,@Tipo INT          -- 1 para administrador, 2 para empleado
    ,@Registrado BIT OUTPUT
    ,@Message VARCHAR(100) OUTPUT
	,@TipoUsuarioOutput INT OUTPUT
)
AS
BEGIN
    BEGIN TRY
        -- Declarar una variable para almacenar el Tipo de usuario
        DECLARE @TipoUsuario INT;
		-- Obtener el ID del empleado insertado
        DECLARE @EmpleadoID INT = NULL;

        -- Validar si el nombre de usuario existe
        IF (EXISTS (SELECT 1 FROM Usuarios WHERE Username = @Username))
        BEGIN
            -- Obtener el Tipo del usuario existente
            SELECT @TipoUsuario = Tipo FROM Usuarios WHERE Username = @Username;

            -- Comprobar el Tipo del usuario
            IF @TipoUsuario = 1  -- 1 para administrador
            BEGIN
                SET @Registrado = 0;
                SET @Message = 'El nombre de usuario ya existe y pertenece a un administrador. No se puede registrar un empleado con este nombre de usuario.';
            END
            ELSE
            BEGIN
                -- Insertar el empleado en la tabla Empleados
                INSERT INTO Empleados (Nombre, TipoDocIdentidadId, ValorDocIdentidad, FechaNacimiento, PuestoId, DepartamentoId, Activo)
                VALUES (@Nombre, @IdDocIdentidad, @ValorDocIdentidad, @FechaNacimiento, @IdPuesto, @IdDepartamento, 1);

                SET @EmpleadoID = SCOPE_IDENTITY();

                -- Actualizar la tabla Usuarios con el EmpleadoID
                UPDATE Usuarios SET EmpleadoID = @EmpleadoID WHERE Username = @Username;

                SET @Registrado = 1;
                SET @Message = 'Empleado registrado exitosamente.';
            END
        END
        ELSE
        BEGIN
            -- Insertar el usuario en la tabla Usuarios
            INSERT INTO Usuarios (Username, Password, Tipo, EmpleadoID)
            VALUES (@Username, @Password, @Tipo, NULL);

            -- Insertar el empleado en la tabla Empleados
            INSERT INTO Empleados (Nombre, TipoDocIdentidadId, ValorDocIdentidad, FechaNacimiento, PuestoId, DepartamentoId, Activo)
                VALUES (@Nombre, @IdDocIdentidad, @ValorDocIdentidad, @FechaNacimiento, @IdPuesto, @IdDepartamento, 1);

            SET @EmpleadoID = SCOPE_IDENTITY();

            -- Actualizar la tabla Usuarios con el EmpleadoID
            UPDATE Usuarios SET EmpleadoID = @EmpleadoID WHERE Username = @Username;

            SET @Registrado = 1;
            SET @Message = 'Empleado registrado exitosamente.';
        END

        -- Asignar el valor de @TipoUsuario a la variable de salida @TipoUsuario
        SET @TipoUsuarioOutput = @TipoUsuario;
    END TRY
    BEGIN CATCH
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

        -- Establece @Registrado en 0 y @Message con un mensaje de error
        SET @Registrado = 0;
        SET @Message = ERROR_MESSAGE();

        -- Establece @TipoUsuario en NULL en caso de error
        SET @TipoUsuarioOutput = NULL;
    END CATCH
END;