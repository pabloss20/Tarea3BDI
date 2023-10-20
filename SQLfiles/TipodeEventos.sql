CREATE TABLE TiposdeEvento (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(255)
);

INSERT INTO TiposdeEvento (Nombre) VALUES (N'login');
INSERT INTO TiposdeEvento (Nombre) VALUES (N'logout');
INSERT INTO TiposdeEvento (Nombre) VALUES (N'Listar empleados');
INSERT INTO TiposdeEvento (Nombre) VALUES (N'Listar empleados con filtro');
INSERT INTO TiposdeEvento (Nombre) VALUES (N'Insertar empleado');
