
DECLARE @resultado BIT, @message VARCHAR(100)

EXEC dbo.SP_CargarDatosXML 25, 'Pancho', '195.168.67.5', 'C:\Users\Usuario\Downloads\Catalogos2.XML', @resultado OUTPUT, @message OUTPUT

SELECT @resultado, @message

SELECT * FROM dbo.BitacoraEventos

SELECT * FROM dbo.DBErrors
