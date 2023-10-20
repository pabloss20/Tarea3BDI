DECLARE @Resultado BIT;
DECLARE @Mensaje VARCHAR(MAX);
DECLARE @Tipo INT;
DECLARE @TipoIdEmpleado INT;

EXEC ValidarEmpleado
    @Username = 'perezjuan12',
    @Password = 'abcd1234',
    @Resultado = @Resultado OUTPUT,
    @Mensaje = @Mensaje OUTPUT,
    @Tipo = @Tipo OUTPUT,
    @TipoIdEmpleado = @TipoIdEmpleado OUTPUT;

-- Verificar los resultados
PRINT 'Resultado: ' + CAST(@Resultado AS VARCHAR(1));
PRINT 'Mensaje: ' + @Mensaje;
PRINT 'Tipo de Usuario: ' + CAST(@Tipo AS VARCHAR(1));
PRINT 'ID de Empleado: ' + CAST(@TipoIdEmpleado AS VARCHAR(10));

EXEC ValidarEmpleado
    @Username = 'beto234',
    @Password = 'qiudh2d29',
    @Resultado = @Resultado OUTPUT,
    @Mensaje = @Mensaje OUTPUT,
    @Tipo = @Tipo OUTPUT,
    @TipoIdEmpleado = @TipoIdEmpleado OUTPUT;

-- Verificar los resultados
PRINT 'Resultado: ' + CAST(@Resultado AS VARCHAR(1));
PRINT 'Mensaje: ' + @Mensaje;
PRINT 'Tipo de Usuario: ' + CAST(@Tipo AS VARCHAR(1));
PRINT 'ID de Empleado: ' + CAST(@TipoIdEmpleado AS VARCHAR(10));
