
SELECT * FROM dbo.Usuarios
SELECT * FROM dbo.Empleados

INSERT INTO Empleados (Nombre, TipoDocIdentidadId, ValorDocIdentidad, FechaNacimiento, PuestoId, DepartamentoId, Activo)
VALUES ('Juan Pérez', 1, '123456789', '1990-03-17', 1, 1, 1);

INSERT INTO Usuarios (Username, Password, Tipo, EmpleadoId)
VALUES ('perezjuan12', 'abcd1234', 2, 9);

INSERT INTO Empleados (Nombre, TipoDocIdentidadId, ValorDocIdentidad, FechaNacimiento, PuestoId, DepartamentoId, Activo)
VALUES ('Pedro castro', 1, '123467854', '1999-04-13', 1, 1, 1);

INSERT INTO Usuarios (Username, Password, Tipo, EmpleadoId)
VALUES ('castropedrito20', 'hjcb229s', 1, 10);

SELECT * FROM dbo.Empleados
SELECT * FROM dbo.Usuarios
