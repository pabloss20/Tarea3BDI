USE [ControlPlanillaDB]
GO
/****** Object:  StoredProcedure [dbo].[ObtenerDatosEmpleado]    Script Date: 01/11/2023 17:06:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ObtenerDatosEmpleado]
(
    @inIdUser INT,
    @inUsername VARCHAR(16),
    @inPostIP VARCHAR(64),
    @outRetorno BIT OUTPUT,
    @outMessage VARCHAR(100) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        SELECT
            E.Nombre AS NombreEmpleado,
            E.ValorDocIdentidad AS DocumentoIdentidad,
            E.FechaNacimiento,
			T.Nombre as TipoDocIdentidad,
            P.Nombre AS NombrePuesto,
            D.Nombre AS NombreDepartamento
        FROM dbo.Empleados AS E
		INNER JOIN dbo.TipoDocumentoIdentidad AS T ON E.IdTipoDocIdentidad = T.Id
        INNER JOIN dbo.Puestos AS P ON E.IdPuesto = P.Id
        INNER JOIN dbo.Departamentos AS D ON E.IdDepartamento = D.Id
        WHERE E.Id = @inIdUser

        SET @outRetorno = 1
        SET @outMessage = 'Datos del empleado obtenidos exitosamente.'

        -- Se insertan los valores en la tabla BitacoraEventos
        INSERT INTO dbo.BitacoraEventos
        (
            IdUsuario,
            IP,
            FechaHora,
            IdTipoEvento,
            Parametros
        )
        VALUES 
        (
            @inIdUser,
            @inPostIP,
            GETDATE(),
            3,
            'Parámetros: 1.' + CONVERT(VARCHAR, @inIdUser) + ', 2.' + @inUsername + ', 3.' + @inPostIP + '.'
        )

    END TRY
    BEGIN CATCH

        INSERT INTO dbo.DBErrors
        (
            UserName,
            ErrorNumber,
            ErrorState,
            ErrorSeverity,
            ErrorLine,
            ErrorProcedure,
            ErrorMessage,
            ErrorDateTime
        )
        VALUES 
        (
            @inUsername,
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        )
        SET @outRetorno = 0            
        SET @outMessage = ERROR_MESSAGE()
    END CATCH
END
