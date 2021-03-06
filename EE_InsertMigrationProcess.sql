
GO
/****** Object:  StoredProcedure [dbo].[sprInsertCompanyMigrationStepStatus]    Script Date: 23-02-2018 12:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sprInsertCompanyMigrationStepStatus]
(
@enterpriseID AS int = null,
@StepID AS int = null,
@StepStatus AS varchar(50) = null,
@Description AS varchar(MAX) = null,
@StartDate AS datetime = null,
@EndDate AS datetime = null,
@agentCreated AS nvarchar(50) = nul
)
AS

DECLARE @StatusId int
INSERT INTO tbl_company_migrationsteps_status
(
  EnterpriseID,
  StepID,
  StepStatus,
  Description,
  StartDate,
  EndDate,
  AgentCreated
)
VALUES
(
  @enterpriseID,
  @StepID,
  @StepStatus,
  @Description,
  @StartDate,
  @EndDate,
  @agentCreated
)

SELECT @StatusId = SCOPE_IDENTITY()


SELECT @StatusId

