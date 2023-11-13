CREATE TABLE TipoDeDeduccion 
(
    Id INT PRIMARY KEY
    ,Nombre NVARCHAR(255)
    ,Obligatorio NVARCHAR(5)
    ,Porcentual NVARCHAR(5)
    ,Valor DECIMAL(18, 4)
);

INSERT INTO TipoDeDeduccion (Id, Nombre, Obligatorio, Porcentual, Valor)
VALUES 
(1, 'Obligatorio de Ley', 'Si', 'Si', 0.095)
,(2, 'Ahorro Asociacion Solidarista', 'No', 'Si', 0.05)
,(3, 'Ahorro Vacacional', 'No', 'No', 0)
,(4, 'Pension Alimenticia', 'No', 'No', 0);
