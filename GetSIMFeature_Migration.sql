--CREATE PROCEDURE [dbo].[GetSIMList_Migration]
CREATE PROCEDURE [dbo].[GetSIMFeature_Migration]
	@enterPriseID INT  ,
	@internalStatusID INT,
	@resultCode INT OUTPUT,	
	@resultMessage nvarchar(200) OUTPUT
AS    
BEGIN    
    
	SET NOCOUNT ON;  	
	DECLARE @OldFeatures VARCHAR(MAX), @sim_Number VARCHAR(MAX), @MSISDN VARCHAR(MAX),@simID INT,@SimType VARCHAR(20)
    If @internalStatusID=1 then @SimType='ACTIVE'
	If @internalStatusID=6 then @SimType='TEST'
	BEGIN TRY
DECLARE c_simids CURSOR  
 FOR  
 SELECT  SIMID FROM tbl_sims ts
        JOIN tbl_locations tl ON ts.LocationID=tl.LocationID 
        WHERE tl.EnterpriseID= @enterPriseID and ts.InternalStatusID=@internalStatusID and ts.SIMTypeID=13
OPEN c_simids  
FETCH NEXT FROM c_simids INTO  @simID 
WHILE @@FETCH_STATUS = 0  
BEGIN  
EXEC InsertAuditLogSteps_Migration @enterPriseID,@simID,'Update-Insert','tbl_sim_features',@SimType+' Sims Feature mapping','Started',0,GetDate() 
SELECT @sim_Number=SIMNumber,@MSISDN=MSISDN from tbl_sims where simid=@simID

	SELECT @OldFeatures=STUFF((SELECT ';'+CONVERT(VARCHAR,SIMFeatureTypeID) 
		FROM tbl_sim_features T1 WHERE T1.SIMID=T2.SIMID AND T1.SIMFeatureStatus='Active' ORDER BY T1.SIMFeatureTypeID
		FOR XML PATH('')),1,1,'') FROM tbl_sim_features T2 WHERE T2.SIMID=@simID

	UPDATE tbl_sim_features set SIMFeatureStatus='Deactivated', DateSIMFeatureEnd=GETDATE() Where simid=@simID and SIMFeatureStatus='Active' 
	EXEC InsertAuditLogSteps_Migration @enterPriseID,@simID,'Update-Deactivated','tbl_sim_features',@SimType+' Sims Feature mapping','InProgress',0,GetDate()

	INSERT INTO tbl_sim_features( SIMID,SIMNumber,SIMFeatureTypeID,SIMFeatureStatus,DateSIMFeatureStart,DateCreated,MSISDN) 
	SELECT @simID,@sim_Number,[Name],'Active',getdate(),getdate(),@MSISDN FROM SplitString((SELECT NewFeatures FROM FeatureMappingEE WHERE OldFeatures=@OldFeatures))
	EXEC InsertAuditLogSteps_Migration @enterPriseID,@simID,'Insert-Activated','tbl_sim_features',@SimType+' Sims Feature mapping','Finished',0,GetDate()
FETCH NEXT FROM c_simids INTO  @simID 
END  
CLOSE c_simids  
DEALLOCATE c_simids
SET @resultCode = 0
	SET @resultMessage = @SimType+' Sims Feature mapping completed successfully ! '
END TRY
BEGIN CATCH
			
            
            SET @resultCode = 1
            SET @resultMessage = @SimType+' Sims Feature mapping  Failed ' + char(13) + char(10)
                        + ERROR_NUMBER() + '. '  + char(13) + char(10)
                        + ERROR_MESSAGE() + '. ' + char(13) + char(10)
                        + ERROR_LINE() + '. ' + char(13) + char(10)
                        + ERROR_PROCEDURE() + '. ' + char(13) + char(10)
                        + ERROR_STATE() + '. ' + char(13) + char(10)	


	END CATCH

END  

GO