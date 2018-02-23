
GO
/****** Object:  StoredProcedure [dbo].[sprInsertCompanyMigrationStepStatus]    Script Date: 23-02-2018 12:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sprUpdateCompanyMigrationStepStatus]
(
@enterpriseID AS int = null,
@StepID AS int = null,
@StepStatus AS varchar(50) = null
)
AS


UPDATE  tbl_company_migrationsteps_status SET StepStatus=@StepStatus,EndDate=getdate() where EnterpriseID=@enterpriseID AND StepID=@StepID

SELECT ID from tbl_company_migrationsteps_status where EnterpriseID=@enterpriseID AND StepID=@StepID

