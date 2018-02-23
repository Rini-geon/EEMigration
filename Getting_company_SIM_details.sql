-- Getting company and SIM details

SELECT tc.EnterpriseID,tc.Company,
		SUM(CASE WHEN ts.InternalStatusID=1 THEN 1 ELSE 0 END) Active,
		SUM(CASE WHEN ts.InternalStatusID=2 THEN 1 ELSE 0 END) Stock  ,
		SUM(CASE WHEN ts.InternalStatusID=3 THEN 1 ELSE 0 END) [On-Order]	,
		SUM(CASE WHEN ts.InternalStatusID=4 THEN 1 ELSE 0 END) Scrapped  ,
		SUM(CASE WHEN ts.InternalStatusID=5 THEN 1 ELSE 0 END) Deactivated,
		SUM(CASE WHEN ts.InternalStatusID=6 THEN 1 ELSE 0 END) Test	, 
		SUM(CASE WHEN ts.InternalStatusID=7 THEN 1 ELSE 0 END) Ready  ,
		SUM(CASE WHEN ts.InternalStatusID=8 THEN 1 ELSE 0 END) [Pending Scrap],
		SUM(CASE WHEN ts.InternalStatusID=9 THEN 1 ELSE 0 END) [Suspended], 
		SUM(CASE WHEN ts.InternalStatusID=10 THEN 1 ELSE 0 END) [Suspended With Charge],
		SUM(CASE WHEN ts.InternalStatusID=11 THEN 1 ELSE 0 END) [Barred]
	FROM tbl_sims ts 
		JOIN tbl_locations tl ON ts.LocationID=tl.LocationID 
		JOIN tbl_company tc ON tc.EnterpriseID=tl.EnterpriseID
		JOIN tbl_CCMigration_CompanyInformation tcc ON tcc.EnterpriseID=tc.EnterpriseID
	WHERE tcc.SIMTypeID=13 AND tcc.IsMigrated=0 and ts.SIMTypeID=13
	GROUP BY tc.EnterpriseID,tc.Company