DECLARE @Registrado BIT;
DECLARE @Message VARCHAR(100);
DECLARE @TipoUsuarioOutput INT;

-- Llamar al procedimiento almacenado
EXEC RegistrarEmpleado
    @Nombre = 'Ana Martinez',
    @IdDocIdentidad = 1,
    @ValorDocIdentidad = '128714201',
    @FechaNacimiento = '1996-09-26',
    @IdPuesto = 1,
    @IdDepartamento = 1,
    @Activo = 1,
    @Username = 'anita122',
    @Password = 'dn2duh29',
    @Tipo = 2,  -- 2 para empleado
    @Registrado = @Registrado OUTPUT,
    @Message = @Message OUTPUT,
    @TipoUsuarioOutput = @TipoUsuarioOutput OUTPUT;

-- Verificar los resultados
PRINT 'Registrado: ' + CAST(@Registrado AS VARCHAR(1));
PRINT 'Mensaje: ' + @Message;
PRINT 'Tipo de Usuario: ' + CAST(@TipoUsuarioOutput AS VARCHAR(1));
