
DECLARE @resultado BIT, @message VARCHAR(100)

EXEC dbo.SP_CargarDatosXML 25, 'Pancho', '195.168.67.5', 'C:\Users\Usuario\Downloads\Catalogos2.xml', @resultado OUTPUT, @message OUTPUT

SELECT @resultado, @message


SELECT * FROM dbo.BitacoraEventos

SELECT * FROM dbo.DBErrors



SELECT * FROM (SELECT CAST(C AS XML)
				FROM OPENROWSET(BULk 'C:\Users\Usuario\Downloads\Catalogos2.xml', SINGLE_BLOB) AS T(C)) AS S(C)

DECLARE @xmlData xml

SET @xmlData = (SELECT * FROM OPENROWSET(BULk 'C:\Users\Usuario\Downloads\Catalogos2.xml', SINGLE_BLOB) AS datos);
