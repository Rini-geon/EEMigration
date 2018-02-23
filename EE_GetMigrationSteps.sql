SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rini Jose
-- Create date: 
-- Description:	Get Migration Steps
-- =============================================
CREATE PROCEDURE GetEECompanyMigrationSteps 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from tbl_lookup_migration_steps where simtypeid=13
END
GO
