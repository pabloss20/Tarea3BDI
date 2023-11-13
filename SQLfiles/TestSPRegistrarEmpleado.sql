
SELECT * FROM dbo.AsociacionEmpleadoConDeduccion

DECLARE @Registrado BIT;
DECLARE @Message VARCHAR(100);

-- Llamar al procedimiento almacenado
EXEC RegistrarEmpleado
    @Nombre = 'Felipe Cruz',
    @IdDocIdentidad = 1,
    @ValorDocIdentidad = '1209834723',
    @FechaNacimiento = '1998-09-21',
    @IdPuesto = 3,
    @IdDepartamento = 2,
    @Activo = 1,
    @Username = 'felicr',
    @Password = 'n3984dkf',
    @Tipo = 2,  -- 2 para empleado
    @Registrado = @Registrado OUTPUT,
    @Message = @Message OUTPUT

SELECT * FROM dbo.AsociacionEmpleadoConDeduccion
