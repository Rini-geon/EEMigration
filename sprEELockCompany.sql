USE [DEV3_FE]
GO
/****** Object:  StoredProcedure [dbo].[sprInsertCompanyAccountChangeItem]    Script Date: 22-02-2018 10:40:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:	RIni Jose
-- Create date:
-- Description:	Inserts company account change information for EE 
-- =============================================
CREATE PROCEDURE [dbo].[sprEELockCompany]
	@companyID int
AS
BEGIN

	SET NOCOUNT ON;

BEGIN TRY
		
		BEGIN TRANSACTION
	
	 EXEC InsertAuditLogSteps_Migration @companyID,0,'Insert-AccountStatus','tbl_company_account_changes','Company Lock','Started',0,GetDate() 	

		INSERT INTO tbl_company_account_changes
		([EnterpriseID], [ChangeType], [ChangeToValue], [ChangeFromValue], [ChangeDate], [ChangeAgent], [ChangeNote])
		VALUES (@companyID, 'AccountStatus', 'Deactive', ( SELECT TOP 1 c.EnterpriseAccountStatus	FROM tbl_company c	WHERE c.EnterpriseID = @companyID)
		, GETDATE(), 'siddemo', '')
		EXEC InsertAuditLogSteps_Migration @companyID,0,'Insert-AccountStatus','tbl_company_account_changes','Company Lock','Finished',0,GetDate() 	
		EXEC InsertAuditLogSteps_Migration @companyID,0,'Update-Deactive','tbl_company','Company Lock','Started',0,GetDate() 	

		UPDATE tbl_company set EnterpriseAccountStatus='Deactive'	WHERE EnterpriseID = @companyID
		EXEC InsertAuditLogSteps_Migration @companyID,0,'Update-Deactive','tbl_company','Company Lock','Finished',0,GetDate() 	
		SELECT 1;
		
		
	END TRY

	BEGIN CATCH
		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		
	
	END CATCH

	IF @@TRANCOUNT > 0 COMMIT TRANSACTION

END

---------------------------------------------------
