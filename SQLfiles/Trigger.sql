USE [ControlPlanillaDB]
GO
/****** Object:  Trigger [dbo].[AsociarDeduccionesObligatorias]    Script Date: 13/11/2023 13:41:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[AsociarDeduccionesObligatorias]
ON [dbo].[Empleados]
AFTER INSERT
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [dbo].[AsociacionEmpleadoConDeduccion] 
	(
	 [IdTipoDeduccion]
	,[ValorTipoDocumento]
	,[Monto]
	,[IdEmpleado]
	)
	SELECT 
	 TD.Id
	,I.ValorDocIdentidad
	,25000
	,I.Id
	FROM dbo.TipoDeDeduccion TD
	CROSS JOIN inserted I
	WHERE TD.Obligatorio = 'Si'

	SET NOCOUNT OFF;

END
