ALTER TABLE BitacoraEventos
ADD FOREIGN KEY (IdTipoEvento) REFERENCES TiposdeEvento(Id);

CREATE TABLE TiposdeEvento (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(255)
);

INSERT INTO TiposdeEvento (Id, Nombre) VALUES
(1, 'login'),
(2, 'logout'),
(3, 'Listar empleados'),
(4, 'Listar empleados con filtro'),
(5, 'Insertar empleado');
