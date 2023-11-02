DECLARE @Retorno BIT
DECLARE @Message VARCHAR(100)

DECLARE @IdUser INT = 19  
DECLARE @Username VARCHAR(16) = 'castropedrito20'  
DECLARE @PostIP VARCHAR(64) = '127.0.0.1'  

EXEC ObtenerDatosEmpleado
    @inIdUser = @IdUser,
    @inUsername = @Username,
    @inPostIP = @PostIP,
    @outRetorno = @Retorno OUTPUT,
    @outMessage = @Message OUTPUT

-- Verifica el resultado
IF @Retorno = 1
BEGIN
    PRINT 'Éxito: ' + @Message
END
ELSE
BEGIN
    PRINT 'Error: ' + @Message
END
