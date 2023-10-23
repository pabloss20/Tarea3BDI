
SELECT * FROM dbo.Empleados

DECLARE @Resultado INT;
DECLARE @Mensaje NVARCHAR(MAX);
DECLARE @Username NVARCHAR(255) = 'usuario_prueba';
DECLARE @IdsEmpleados NVARCHAR(MAX) = '25,26,27'; 

-- Ejecuta el procedimiento almacenado
EXEC BorrarEmpleadosMasivo @Username, @IdsEmpleados, @Resultado OUT, @Mensaje OUT;

-- Verifica el resultado y el mensaje
IF @Resultado = 1
BEGIN
    PRINT 'Operación exitosa: ' + @Mensaje;
END
ELSE
BEGIN
    PRINT 'Error: ' + @Mensaje;
END

SELECT * FROM dbo.Empleados