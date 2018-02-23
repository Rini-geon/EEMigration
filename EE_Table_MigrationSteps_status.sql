USE [DEV3_FE]
GO

/****** Object:  Table [dbo].[tbl_company_migrationsteps_status]    Script Date: 23-02-2018 10:42:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_company_migrationsteps_status](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EnterpriseID] [int] NULL,
	[StepID] [int] NULL,
	[StepStatus] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[agentCreated] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_company_migrationsteps_status] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[tbl_company_migrationsteps_status]  WITH CHECK ADD  CONSTRAINT [FK_tbl_company_migrationsteps_status_tbl_company_migrationsteps_status] FOREIGN KEY([StepID])
REFERENCES [dbo].[tbl_lookup_migration_steps] ([StepID])
GO

ALTER TABLE [dbo].[tbl_company_migrationsteps_status] CHECK CONSTRAINT [FK_tbl_company_migrationsteps_status_tbl_company_migrationsteps_status]
GO


