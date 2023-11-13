
SELECT * FROM dbo.AsociacionEmpleadoConDeduccion

DECLARE @Registrado BIT;
DECLARE @Message VARCHAR(100);

-- Llamar al procedimiento almacenado
EXEC RegistrarEmpleado
    @Nombre = 'Marta Quiros',
    @IdDocIdentidad = 1,
    @ValorDocIdentidad = '1352392',
    @FechaNacimiento = '1999-12-21',
    @IdPuesto = 2,
    @IdDepartamento = 1,
    @Activo = 1,
    @Username = 'marqui23',
    @Password = 'weih9ihgc',
    @Tipo = 2,  -- 2 para empleado
    @Registrado = @Registrado OUTPUT,
    @Message = @Message OUTPUT

SELECT * FROM dbo.AsociacionEmpleadoConDeduccion
