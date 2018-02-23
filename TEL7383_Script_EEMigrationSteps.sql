/*
	Script Name : Migration Steps 
	Author		: Rini Jose
	Purpose		: Insert Migration steps for EE
	Modification Date: 2017-11-27
*/

Begin

	Declare @KEE_Scriptmigrationsteps VARCHAR(255)
	set @KEE_Scriptmigrationsteps='TEL7383_Script_EEMigrationSteps'
	
	--First determine if the script has been run before
	IF (SELECT COUNT(*) FROM ExecutedDataScripts WHERE Name = @KEE_Scriptmigrationsteps) = 0 
	Begin
		--Run the script
		PRINT 'Start '+@KEE_Scriptmigrationsteps+', DateStart='+CONVERT (VARCHAR (20), GetDate(), 120);

		/******ScriptStart******/
						
		INSERT INTO tbl_lookup_migration_steps values('Lock users in the company',1,13)
		INSERT INTO tbl_lookup_migration_steps values('Migrate Default Activation Profile',2,13)
		INSERT INTO tbl_lookup_migration_steps values('Migrate EAPs',3,13)
		INSERT INTO tbl_lookup_migration_steps values('Migrate Test SIMs',4,13)
		INSERT INTO tbl_lookup_migration_steps values('Migrate Active SIMs',5,13)
		INSERT INTO tbl_lookup_migration_steps values('Migrate Deactivated SIMs',6,13)
		INSERT INTO tbl_lookup_migration_steps values('Unlock users in the company',7,13)

		/******ScriptEnd******/

		--Insert into table of executed scripts to ensure this script can not be run again
		INSERT INTO ExecutedDataScripts VALUES(@KEE_Scriptmigrationsteps, GETDATE()) 

		PRINT 'End '+@KEE_Scriptmigrationsteps+', DateFinish='+CONVERT (VARCHAR (20), GetDate(), 120);
	End
End
