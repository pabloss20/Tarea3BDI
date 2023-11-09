CREATE PROCEDURE ObtenerUltimasPlanillas
(
    @inIdUser INT
    ,@inUsername VARCHAR(16)
    ,@inPostIP VARCHAR(64)
    ,@EmpleadoId INT
    ,@CantidadPlanillas INT
    ,@outRetorno BIT OUTPUT
    ,@outMensaje VARCHAR(100) OUTPUT
)
AS
BEGIN
    DECLARE @TransactionStarted BIT = 0;

    BEGIN TRY
        SET NOCOUNT ON;

        -- Iniciar la transacción
        BEGIN TRANSACTION;
        SET @TransactionStarted = 1;

        -- Obtener las últimas planillas semanales
        SELECT TOP (@CantidadPlanillas)
            Id
            ,SemanaInicio
            ,SalarioBruto
            ,TotalDeducciones
            ,SalarioNeto
        FROM PlanillaSemanal
        WHERE IdEmpleado = @EmpleadoId
        ORDER BY SemanaInicio DESC;

        -- Registrar el evento en la tabla BitácoraEventos
        INSERT INTO BitacoraEventos (IdUsuario, IP, FechaHora, IdTipoEvento, Parametros)
        VALUES (@EmpleadoId, '127.0.0.1', GETDATE(), 3, 'Obtener últimas planillas');

        -- Confirmar la transacción
        COMMIT;
        SET @TransactionStarted = 0;

        -- Establecer los parámetros de retorno
        SET @outRetorno = 1;
        SET @outMensaje = 'Planillas obtenidas exitosamente.';
    END TRY
    BEGIN CATCH
        -- En caso de error, deshacer la transacción si se inició
        IF @TransactionStarted = 1
        BEGIN
            ROLLBACK;
        END;

        -- Registrar el error en la tabla [dbo].[DBErrors]
        INSERT INTO [dbo].[DBErrors]
        (
            [UserName],
            [ErrorNumber],
            [ErrorState],
            [ErrorSeverity],
            [ErrorLine],
            [ErrorProcedure],
            [ErrorMessage],
            [ErrorDateTime]
        )
        VALUES (
            USER_NAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        -- Establecer los parámetros de retorno en caso de error
        SET @outRetorno = 0;
        SET @outMensaje = 'Error al obtener planillas: ' + ERROR_MESSAGE();
    END CATCH;
END
