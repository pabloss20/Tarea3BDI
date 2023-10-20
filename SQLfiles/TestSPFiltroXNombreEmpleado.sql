
DECLARE @resultado bit, @message varchar(100)

EXEC dbo.SP_FiltroXNombreEmpleado 60, 'Sutano', '192.168.67.5', 'ERT', @resultado output, @message output

SELECT @resultado, @message


SELECT * FROM dbo.BitacoraEventos
