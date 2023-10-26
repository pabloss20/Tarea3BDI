SELECT * FROM dbo.Empleados

DECLARE @Resultado BIT;
DECLARE @Mensaje VARCHAR(MAX);

-- Establecer los valores de entrada
DECLARE @Id INT = 19; -- ID del empleado que deseas editar
DECLARE @Nombre VARCHAR(255) = 'Carlos Perez';
DECLARE @TipoDocIdentidadId INT = 3; -- Tipo de documento de identidad
DECLARE @ValorDocIdentidad VARCHAR(50) = '2908421-203';
DECLARE @FechaNacimiento DATE = '1990-01-01';
DECLARE @PuestoId INT = 3; -- ID del nuevo puesto
DECLARE @DepartamentoId INT = 4; -- ID del nuevo departamento

-- Ejecutar el procedimiento almacenado
EXEC [dbo].[EditarEmpleado] 
    @Id,
    @Nombre,
    @TipoDocIdentidadId,
    @ValorDocIdentidad,
    @FechaNacimiento,
    @PuestoId,
    @DepartamentoId,
    @Resultado OUTPUT,
    @Mensaje OUTPUT;

-- Verificar el resultado
IF @Resultado = 1
    PRINT 'Empleado actualizado exitosamente. Mensaje: ' + @Mensaje;
ELSE
    PRINT 'Error al actualizar el empleado. Mensaje: ' + @Mensaje;

SELECT * FROM dbo.Empleados