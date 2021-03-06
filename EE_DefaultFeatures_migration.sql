
--exec sprUpdateSIMFeatureTypeEligibilityForCompany_EECCMigration 310,'siddemo',13,'15025,15026,15036,15037,15038,13021,13022,13023,13024,13025,13026,13027,13028,13029,13030,13031,13032,13033'
GO
/****** Object:  StoredProcedure [dbo].[sprUpdateSIMFeatureTypeEligibilityForCompany]    Script Date: 19-02-2018 09:46:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Rini Jose
-- Create date: 19th Feb  2018
-- Description:	Update SIM type Eligibility for Company Migration
-- =============================================
CREATE PROCEDURE [dbo].[sprUpdateEEDefaultFaturesForCompany_Migration]
	@EntId int,
	@Agent nvarchar(50),
	@SIMTypeId int,
	@EligibleSIMFeatureTypeIds XML,
	@resultCode INT = 0 OUTPUT,
	@resultMessage VARCHAR(8000) = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @IneligibleCount varchar(20)
		EXEC InsertAuditLogSteps_Migration @EntId,0,'Update - Not Eligible','tbl_index_contracts_sim_features','Default Activation Profile Mapping','Started',0,GetDate() 
		UPDATE tbl_index_contracts_sim_features SET Status = 'Not Eligible', DateEligibleEnd = GetDate()
		FROM tbl_index_contracts_sim_features csf
		JOIN tbl_index_sim_types_sim_features stsf ON stsf.SIMFeatureTypeId = csf.SIMFeatureTypeId
		JOIN tbl_billing_contracts con ON con.ContractId = csf.ContractId
		JOIN tbl_locations l ON l.LocationId = con.LocationId
		WHERE l.EnterpriseId = @EntId AND
			csf.Status = 'Eligible' AND
			stsf.SIMTypeId = @SIMTypeId AND
			csf.SIMFeatureTypeId NOT IN
				(SELECT ParamValues.SIMFeatureTypeID.value('.','INT')
				FROM @EligibleSIMFeatureTypeIds.nodes('/SIMFeatureTypes/SIMFeatureTypeIDs/SIMFeatureTypeID')
				as ParamValues(SIMFeatureTypeID))

		SET @IneligibleCount = CAST(@@ROWCOUNT AS Varchar(20))

		INSERT INTO tbl_index_contracts_sim_features(ContractID, SIMTypeID, SIMFeatureTypeID, Status, DateEligibleStart, DateEligibleEnd, 
			FlagCheckByDefault, DateCreated, AgentCreated)
		SELECT con.ContractId, tblSIMFeatures.SIMTypeId, tblSIMFeatures.SIMFeatureTypeId, 'Eligible', GetDate(), null, 0, GetDate(), @Agent
		FROM (SELECT tsf.SIMFeatureTypeId, stsf.SIMTypeId
			FROM tbl_lookup_type_sim_features tsf
			JOIN tbl_index_sim_types_sim_features stsf ON stsf.SIMFeatureTypeId = tsf.SIMFeatureTypeId) AS tblSIMFeatures, tbl_locations l
		JOIN tbl_billing_contracts con ON con.LocationId = l.LocationId
		WHERE l.EnterpriseId = @EntId AND
			NOT EXISTS 
				(SELECT csf.IndexContractSIMFeatureTypeID
				FROM tbl_index_contracts_sim_features csf
				WHERE csf.ContractId = con.ContractId AND
					csf.SIMFeatureTypeId = tblSIMFeatures.SIMFeatureTypeId AND
					csf.Status = 'Eligible') AND
			tblSIMFeatures.SIMFeatureTypeId IN
				(SELECT ParamValues.SIMFeatureTypeID.value('.','INT')
				FROM @EligibleSIMFeatureTypeIds.nodes('/SIMFeatureTypes/SIMFeatureTypeIDs/SIMFeatureTypeID')
				as ParamValues(SIMFeatureTypeID))
	EXEC InsertAuditLogSteps_Migration @EntId,0,'INSERT - Eligible','tbl_index_contracts_sim_features','Default Activation Profile Mapping','Finished',0,GetDate() 
		SET @resultMessage = 'Successful update: ' + CAST(@@ROWCOUNT AS Varchar(20)) + ' SIM feature type(s) made eligible, ' +
			@ineligibleCount + ' SIM feature type(s) made ineligible'
		SET @resultCode = 0

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @resultCode = ERROR_NUMBER();
		SET @resultMessage = 'Error: ' + CAST(ERROR_NUMBER() AS varchar(20)) +
			', Severity: ' + CAST(ERROR_SEVERITY() AS varchar(20)) +
			', State: ' + CAST(ERROR_STATE() AS varchar(20)) +
			', Procedure: ' + CAST(ERROR_PROCEDURE() AS varchar(20)) +
			', Line: ' + CAST(ERROR_LINE() AS varchar(20)) +
			', Message: ' + CAST(ERROR_MESSAGE() AS varchar(20));
	END CATCH

	IF @@TRANCOUNT > 0 COMMIT TRANSACTION

END

---------------------------------------------------