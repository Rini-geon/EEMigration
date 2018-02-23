SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rini Jose
-- Create date: 
-- Description:	Get Migration Steps
-- =============================================
ALTER PROCEDURE GetEECompanyMigrationStepProcess 
(
@EnterpriseID int,
@simtypeID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from tbl_company_migrationsteps_status inner join tbl_lookup_migration_steps
	 on tbl_lookup_migration_steps.stepID=tbl_company_migrationsteps_status.stepID where @EnterpriseID=EnterpriseID AND simtypeID=@simtypeID

END
GO
