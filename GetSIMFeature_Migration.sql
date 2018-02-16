USE [DEV3_FE]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSIMFeature_Migration]
	@simID INT
AS    
BEGIN    
    
	SET NOCOUNT ON;  
	DECLARE @OldFeatures VARCHAR(MAX), @sim_Number varchar, @MSISDN varchar

	PRINT '-------- Feature_Migration --------';  

	SELECT @sim_Number=SIMNumber,@MSISDN=MSISDN from tbl_sims where simid=@simID

	SELECT @OldFeatures=STUFF((SELECT ';'+CONVERT(VARCHAR,SIMFeatureTypeID) 
		FROM tbl_sim_features T1 WHERE T1.SIMID=T2.SIMID AND T1.SIMFeatureStatus='Active' ORDER BY T1.SIMFeatureTypeID
		FOR XML PATH('')),1,1,'') FROM tbl_sim_features T2 WHERE T2.SIMID=@simID

	UPDATE tbl_sim_features set SIMFeatureStatus='Deactivated', DateSIMFeatureEnd=GETDATE() Where simid=@simID and SIMFeatureStatus='Active' 

	INSERT INTO tbl_sim_features( SIMID,SIMNumber,SIMFeatureTypeID,SIMFeatureStatus,DateSIMFeatureStart,DateCreated,MSISDN) 
	SELECT @simID,@sim_Number,[Name],'Active',getdate(),getdate(),@MSISDN FROM SplitString((SELECT NewFeatures FROM FeatureMappingEE WHERE OldFeatures=@OldFeatures))

   
    PRINT ' Feature_Migration'  
  
   
END  

GO