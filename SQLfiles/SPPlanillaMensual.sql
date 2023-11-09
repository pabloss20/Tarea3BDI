USE [ControlPlanillaDB]
GO
/****** Object:  StoredProcedure [dbo].[ObtenerPlanillaMensual]    Script Date: 08/11/2023 19:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ObtenerPlanillaMensual]
(
    @inIdUser INT
    ,@inUsername VARCHAR(16)
    ,@inPostIP VARCHAR(64)
    ,@EmpleadoId INT
    ,@MesInicio DATE
    ,@outSalarioBrutoMensual DECIMAL(10, 2) OUTPUT
    ,@outTotalDeduccionesMensuales DECIMAL(10, 2) OUTPUT
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

        -- Calcular el salario bruto mensual
        SELECT @outSalarioBrutoMensual = SUM(SalarioBruto)
        FROM PlanillaSemanal
        WHERE IdEmpleado = @EmpleadoId
          AND SemanaInicio >= DATEADD(MONTH, DATEDIFF(MONTH, 0, @MesInicio), 0)  -- Primer día del mes
          AND SemanaInicio < DATEADD(MONTH, DATEDIFF(MONTH, 0, @MesInicio) + 1, 0);  -- Primer día del siguiente mes

        -- Calcular el total de deducciones mensuales
        SELECT @outTotalDeduccionesMensuales = SUM(MontoDeduccion)
        FROM DeduccionesMensuales
        WHERE IdEmpleado= @EmpleadoId
          AND MesInicio = @MesInicio;

		-- Registrar el evento en la tabla BitácoraEventos
        INSERT INTO BitacoraEventos (IdUsuario, IP, FechaHora, IdTipoEvento, Parametros)
        VALUES (@EmpleadoId, '127.0.0.1', GETDATE(), 3, 'Obtener últimas planillas');

        -- Confirmar la transacción
        COMMIT;
        SET @TransactionStarted = 0;

		SET @outRetorno = 1;
		set @outMensaje = 'Planillas obtenidas exitosamente.';
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

        -- Establecer los parámetros de salida en caso de error
        SET @outSalarioBrutoMensual = 0;
        SET @outTotalDeduccionesMensuales = 0;
		SET @outRetorno = 1;
		set @outMensaje = 'Planillas no obtenidas exitosamente.';
    END CATCH;
END
