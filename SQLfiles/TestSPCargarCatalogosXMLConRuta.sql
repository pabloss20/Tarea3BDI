
DECLARE @resultado BIT, @message VARCHAR(100)

EXEC dbo.SP_CargarCatalogosXMLConRuta 25, 'GABO', '195.168.67.5', 'C:\Users\Usuario\Downloads\Catalogos2.xml', @resultado OUTPUT, @message OUTPUT

SELECT @resultado, @message


SELECT * FROM dbo.BitacoraEventos
SELECT * FROM dbo.DBErrors

SELECT * FROM dbo.TiposdeDocumentodeIdentidad
SELECT * FROM dbo.TiposDeJornadas
SELECT * FROM dbo.Puestos
SELECT * FROM dbo.Departamentos
SELECT * FROM dbo.Feriados
SELECT * FROM dbo.TiposDeMovimiento
SELECT * FROM dbo.TiposDeDeduccion
SELECT * FROM dbo.UsuariosAdministradores
SELECT * FROM dbo.TiposDeEvento

DELETE FROM dbo.TiposdeDocumentodeIdentidad
DELETE FROM dbo.TiposDeJornadas
DELETE FROM dbo.Puestos
DELETE FROM dbo.Departamentos
DELETE FROM dbo.Feriados
DELETE FROM dbo.TiposDeMovimiento
DELETE FROM dbo.TiposDeDeduccion
DELETE FROM dbo.UsuariosAdministradores
DELETE FROM dbo.TiposDeEvento


/*
SELECT * FROM (SELECT CAST(C AS XML)
				FROM OPENROWSET(BULk 'C:\Users\Usuario\Downloads\Catalogos2.xml', SINGLE_BLOB) AS T(C)) AS S(C)

DECLARE @xmlData xml

SET @xmlData = (SELECT * FROM OPENROWSET(BULk 'C:\Users\Usuario\Downloads\Catalogos2.xml', SINGLE_BLOB) AS datos);

SELECT * FROM @xmlData;
*/