SELECT * 
FROM dbo.Empleados 
WHERE Activo = 1

SELECT U.*
FROM dbo.Usuarios U
INNER JOIN dbo.Empleados E ON U.EmpleadoId = E.Id
WHERE E.activo = 1;
