CREATE TABLE AsociacionEmpleadoConDeduccion (
    Id INT IDENTITY(1,1) PRIMARY KEY
	,IdTipoDeduccion INT
    ,ValorTipoDocumento VARCHAR (50)
	,Monto INT
);

SELECT * FROM dbo.AsociacionEmpleadoConDeduccion