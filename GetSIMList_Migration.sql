USE [DEV3_FE]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSIMList_Migration]
	@enterPriseID INT  ,
	@internalStatusID INT
AS    
BEGIN    
    
	SET NOCOUNT ON;  	

		SELECT  SIMID FROM tbl_sims ts
        JOIN tbl_locations tl ON ts.LocationID=tl.LocationID 
        WHERE tl.EnterpriseID= @enterPriseID and ts.InternalStatusID=@internalStatusID and ts.SimTypeID=13
	
END  

GO