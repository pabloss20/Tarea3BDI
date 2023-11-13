-- Añadir una nueva columna Id como clave primaria

ALTER TABLE JornadasEmpleados
ADD Id INT IDENTITY(1,1) PRIMARY KEY;

ALTER TABLE MesPlanilla 
ADD Id INT IDENTITY(1,1) PRIMARY KEY;

ALTER TABLE SemanaPlanilla
ADD Id INT IDENTITY(1,1) PRIMARY KEY;

ALTER TABLE DeduccionesXEmpleadoxMes
ADD Id INT IDENTITY(1,1) PRIMARY KEY;
