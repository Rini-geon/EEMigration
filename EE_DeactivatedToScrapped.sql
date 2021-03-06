USE [DEV3_FE]
GO
--exec sprUpdateEE_DeactivatedToScrapped 310,13,0,''
/****** Object:  StoredProcedure [dbo].[sprUpdateEE_DeactivatedToScrapped]    Script Date: 20-02-2018 10:56:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sprUpdateEE_DeactivatedToScrapped]
( 
	@EnterpriseID INT,
	@simtypeid INT, 
	@resultCode INT OUTPUT,	
	@resultMessage nvarchar(200) OUTPUT
)
 AS  
 
 BEGIN  
    SET NOCOUNT ON

	
	BEGIN TRY
	
	BEGIN TRANSACTION
	EXEC InsertAuditLogSteps_Migration @EnterpriseID,0,'Update','tbl_sims',' Deactivated sims moved to Scrapped','Started',0,GetDate() 
	UPDATE tbl_sims SET Simstatus='Scrapped' , internalstatusid=4 where simtypeid=@simtypeid 
	and LocationID in (select LocationID from tbl_locations where EnterpriseID=@EnterpriseID)  and (Simstatus='Deactivated' or internalstatusid=5)
	
	SET @resultCode = 0
	SET @resultMessage = 'Deactivated sims has been modified successfully ! '

	COMMIT TRANSACTION
	EXEC InsertAuditLogSteps_Migration @EnterpriseID,0,'Update','tbl_sims',' Deactivated sims moved to Scrapped','Finished',0,GetDate() 
	END TRY	
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK
            
            SET @resultCode = 1
            SET @resultMessage = 'EAP could not be created ' + char(13) + char(10)
                        + ERROR_NUMBER() + '. '  + char(13) + char(10)
                        + ERROR_MESSAGE() + '. ' + char(13) + char(10)
                        + ERROR_LINE() + '. ' + char(13) + char(10)
                        + ERROR_PROCEDURE() + '. ' + char(13) + char(10)
                        + ERROR_STATE() + '. ' + char(13) + char(10)	


	END CATCH
 END