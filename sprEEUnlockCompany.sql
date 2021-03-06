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
CREATE PROCEDURE [dbo].[sprEEUnlockCompany]
	@companyID int,

	@resultID int OUTPUT,
	@resultCode int OUTPUT,
	@resultMessage nvarchar(max) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

BEGIN TRY
		
		BEGIN TRANSACTION
	
	 EXEC InsertAuditLogSteps_Migration @companyID,0,'Insert-AccountStatus','tbl_company_account_changes','Company UnLock','Started',0,GetDate() 	

		INSERT INTO tbl_company_account_changes
		([EnterpriseID], [ChangeType], [ChangeToValue], [ChangeFromValue], [ChangeDate], [ChangeAgent], [ChangeNote])
		VALUES (@companyID, 'AccountStatus', (select TOP 1 changefromvalue from tbl_company_account_changes where enterpriseid=@companyID order by ID desc)
		, ( SELECT TOP 1 c.EnterpriseAccountStatus	FROM tbl_company c	WHERE c.EnterpriseID = @companyID)
		, GETDATE(), 'siddemo', '')
		EXEC InsertAuditLogSteps_Migration @companyID,0,'Insert-AccountStatus','tbl_company_account_changes','Company UnLock','Finished',0,GetDate() 	
		EXEC InsertAuditLogSteps_Migration @companyID,0,'Update-Active','tbl_company','Company UnLock','Started',0,GetDate() 	
		UPDATE tbl_company set EnterpriseAccountStatus='Active'	WHERE EnterpriseID = @companyID
		EXEC InsertAuditLogSteps_Migration @companyID,0,'Update-Active','tbl_company','Company UnLock','Finished',0,GetDate() 

		SET @resultID = SCOPE_IDENTITY()

		SET @resultCode = 0

		SET @resultMessage = 'Company Account Change ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) + ' was inserted'
		
		
	END TRY

	BEGIN CATCH
		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		
		SET @resultID = 0
		SET @resultCode = 1
        SET @resultMessage = 'Error inserting company account change infomation:' + char(13) + char(10)
					+ CAST(ERROR_NUMBER() AS VARCHAR) + '. '  + char(13) + char(10)
					+ ERROR_MESSAGE() + '. ' + char(13) + char(10)
					+ CAST(ERROR_LINE() AS VARCHAR) + '. ' + char(13) + char(10)
					+ ERROR_PROCEDURE() + '. ' + char(13) + char(10)
					+ ERROR_STATE() + '. ' + char(13) + char(10)
	
	END CATCH

	IF @@TRANCOUNT > 0 COMMIT TRANSACTION

END

---------------------------------------------------
