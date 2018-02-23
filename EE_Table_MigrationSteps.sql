USE [DEV3_FE]
GO

/****** Object:  Table [dbo].[tbl_lookup_migration_steps]    Script Date: 23-02-2018 10:35:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_lookup_migration_steps](
	[StepID] [int] IDENTITY(1,1) NOT NULL,
	[StepDescription] [varchar](max) NULL,
	[StepOrder] [int] NULL,
	[SimtypeID] [int] NULL,
 CONSTRAINT [PK_tbl_lookup_migration_steps] PRIMARY KEY CLUSTERED 
(
	[StepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[tbl_lookup_migration_steps] ADD  CONSTRAINT [DF_tbl_lookup_migration_steps_StepOrder]  DEFAULT ((0)) FOR [StepOrder]
GO


