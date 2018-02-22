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
CREATE PROCEDURE [dbo].[sprInsertCompanyAccountChangeItem_EELockCompany]
	@companyID int,

	@resultID int OUTPUT,
	@resultCode int OUTPUT,
	@resultMessage nvarchar(max) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

BEGIN TRY
		
		BEGIN TRANSACTION
	
	

		INSERT INTO tbl_company_account_changes
		([EnterpriseID], [ChangeType], [ChangeToValue], [ChangeFromValue], [ChangeDate], [ChangeAgent], [ChangeNote])
		VALUES (@companyID, 'AccountStatus', 'Deactive', ( SELECT TOP 1 c.EnterpriseAccountStatus	FROM tbl_company c	WHERE c.EnterpriseID = @companyID)
		, GETDATE(), 'siddemo', '')

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
