ALTER TABLE BitacoraEventos
ADD FOREIGN KEY (IdTipoEvento) REFERENCES TiposdeEvento(Id);

SELECT * FROM dbo.TiposdeEvento