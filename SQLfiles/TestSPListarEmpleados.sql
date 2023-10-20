
DECLARE @resultado bit, @message varchar(100)

EXEC dbo.SP_ListarEmpleados 90, 'Pepe', '192.168.1.1' , @resultado output, @message output

SELECT @resultado, @message

SELECT * FROM dbo.BitacoraEventos