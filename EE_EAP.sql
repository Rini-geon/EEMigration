USE [DEV3_FE]
GO
--exec sprUpdateEE_EAP 2388,13,0,''
/****** Object:  StoredProcedure [dbo].[sprUpdateEAP]    Script Date: 20-02-2018 10:56:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sprUpdateEE_EAP]
( 
	@EnterpriseID INT,
	@simtypeid INT,    
    --@simExtendedFeatureList varchar(250),
	@resultCode INT OUTPUT,	
	@resultMessage nvarchar(200) OUTPUT
)
 AS  
 
 BEGIN  
    SET NOCOUNT ON

	
	BEGIN TRY
	
	BEGIN TRANSACTION
		
	DECLARE @i INT = 0;
	DECLARE @total INT = 0;
	DECLARE @EapId INT = 0;
	DECLARE @OldsimFeatureList varchar(250),@simFeatureList varchar(250);

		

		SELECT @total = COUNT(EnterpriseID) from tbl_eap where simtypeid=@simtypeid and EnterpriseID=@EnterpriseID

	WHILE @i < @total
	BEGIN
	EXEC InsertAuditLogSteps_Migration @EnterpriseID,0,'Delete- EAP '+@i ,'tbl_eap_sim_feature_type','Company EAP Mapping','Started',0,GetDate() 	
 		SELECT @EapId = EAPID from tbl_eap where simtypeid=@simtypeid and EnterpriseID=@EnterpriseID
		ORDER BY EAPID
		OFFSET @i ROWS   
		FETCH NEXT 1 ROWS ONLY  

		SET @OldsimFeatureList =(SELECT distinct  
    stuff((
        select ';' + CONVERT(VARCHAR,tbl_eap_sim_feature_type.SIMFeatureTypeID) 
        from tbl_eap inner join
		tbl_eap_sim_feature_type on tbl_eap_sim_feature_type.EAPID = tbl_eap.EAPID inner join
		tbl_lookup_type_sim_features on tbl_lookup_type_sim_features.simfeaturetypeid = tbl_eap_sim_feature_type.simfeaturetypeid
		 where simtypeid=@simtypeid and EnterpriseID=@EnterpriseID and tbl_eap.eapid=@EapId
        order by tbl_eap_sim_feature_type.simfeaturetypeid
        for xml path('')
    ),1,1,'') as featureslist
		from tbl_eap_sim_feature_type
		group by tbl_eap_sim_feature_type.simfeaturetypeid)

		SET @simFeatureList =(SELECT NewFeatures FROM FeatureMappingEE WHERE OldFeatures=@OldsimFeatureList)

	
		DELETE FROM tbl_eap_sim_feature_type WHERE EAPID=@EapId
		EXEC InsertAuditLogSteps_Migration @EnterpriseID,0,'Delete- EAP '+@i,'tbl_eap_sim_feature_type','Company EAP Mapping','Finshed',0,GetDate() 
		
		EXEC InsertAuditLogSteps_Migration @EnterpriseID,0,'Insert-New EAP '+@i,'tbl_eap_sim_feature_type','Company EAP Mapping','Started',0,GetDate() 		

		INSERT INTO tbl_eap_sim_feature_type(EAPID,SIMFeatureTypeID,DateCreated,Parameters)
	    (SELECT @EapId,NAME,getDate(),'' from SplitString(@simFeatureList))

	 --   DECLARE @TableExtendedSIMFeatures TABLE( FeatureID INT)

		--INSERT INTO @TableExtendedSIMFeatures(FeatureID)
		--(SELECT val from [dbo].[SplitCsvToNvarchar](@simExtendedFeatureList))

  --      DELETE FROM tbl_eap_extended_sim_feature_type WHERE EAPID=@EapId

		--INSERT INTO tbl_eap_extended_sim_feature_type(EAPID,ExtendedFeatureTypeID,DateCreated)
	 --   (SELECT @EapId,FeatureID,getDate() from @TableExtendedSIMFeatures)
	 EXEC InsertAuditLogSteps_Migration @EnterpriseID,0,'Insert- New EAP '+@i,'tbl_eap_sim_feature_type','Company EAP Mapping','Finished',0,GetDate() 	
		SET @i = @i + 1;

		SET @resultCode = 0
		SET @resultMessage = 'EAP has been modified successfully ! '

	END

	COMMIT TRANSACTION
	
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