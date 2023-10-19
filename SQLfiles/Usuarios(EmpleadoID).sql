
-- Se agrega una columna EmpleadoId en la tabla Usuarios para relacionar el empleado con el login/signup
ALTER TABLE Usuarios
ADD EmpleadoId INT;

ALTER TABLE Usuarios
ADD CONSTRAINT FK_Usuarios_Empleados
FOREIGN KEY (EmpleadoId) 
REFERENCES Empleados(Id);
