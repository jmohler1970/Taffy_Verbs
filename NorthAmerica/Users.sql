-- Build DB

CREATE DATABASE [UserManager]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = 'UserManager', FILENAME = '/var/opt/mssql/data/UserManager.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = 'UserManager_log', FILENAME = '/var/opt/mssql/data/UserManager_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [UserManager] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [UserManager] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [UserManager] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [UserManager] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [UserManager] SET ARITHABORT OFF 
GO
ALTER DATABASE [UserManager] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [UserManager] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [UserManager] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [UserManager] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [UserManager] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [UserManager] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [UserManager] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [UserManager] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [UserManager] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [UserManager] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [UserManager] SET  DISABLE_BROKER 
GO
ALTER DATABASE [UserManager] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [UserManager] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [UserManager] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [UserManager] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [UserManager] SET  READ_WRITE 
GO
ALTER DATABASE [UserManager] SET RECOVERY FULL 
GO
ALTER DATABASE [UserManager] SET  MULTI_USER 
GO
ALTER DATABASE [UserManager] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [UserManager] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [UserManager] SET DELAYED_DURABILITY = DISABLED 
GO

USE [UserManager]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [UserManager]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = 'PRIMARY') ALTER DATABASE [UserManager] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

-------------------------------------------------------------------------------------------
-- Add Login
USE [master]
GO
CREATE LOGIN [UserManager_user] WITH PASSWORD='UserManager_user', DEFAULT_DATABASE=[UserManager], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [UserManager]
GO
CREATE USER [UserManager_user] FOR LOGIN [UserManager_user]
GO
USE [UserManager]
GO
ALTER ROLE [db_datareader] ADD MEMBER [UserManager_user]
GO
USE [UserManager]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UserManager_user]
GO
USE [UserManager]
GO
ALTER ROLE [db_owner] ADD MEMBER [UserManager_user]
GO


-------------------------------------------------------------------------------------------
-- Create StatesProvinces table

USE [UserManager]

CREATE TABLE dbo.StatesProvinces(
	[ID] [char](2) NOT NULL,
	[Country] [varchar](15) NOT NULL,
	[CountrySort]  AS (case when [Country]='USA' then (1) when [Country]='Canada' then (2) else (99) end),
	[LongName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_StatesProvinces] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE dbo.StatesProvinces ADD  CONSTRAINT [DF_StatesProvinces_Country]  DEFAULT ('USA') FOR [Country]
GO


-------------------------------------------------------------------------------------------
-- That is compressed

USE [UserManager]

ALTER TABLE dbo.StatesProvinces REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)

GO

-------------------------------------------------------------------------------------------
-- Load data

USE [UserManager]

INSERT dbo.StatesProvinces (ID, Country, LongName) VALUES
 
('AB', 'Canada', 'Alberta'),
('AK', 'USA', 'Alaska'),
('AL', 'USA', 'Alabama'),
('AR', 'USA', 'Arkansas'),
('AS', 'USA', 'American Samoa'),
('AZ', 'USA', 'Arizona'),
('BA', 'The Bahamas', 'All Islands'),
('BC', 'Canada', 'British Columbia'),
('CA', 'USA', 'California'),
('CO', 'USA', 'Colorado'),
('CT', 'USA', 'Connecticut'),
('DC', 'USA', 'District of Columbia'),
('DE', 'USA', 'Delaware'),
('FL', 'USA', 'Florida'),
('GA', 'USA', 'Georgia'),
('GU', 'USA', 'Guam'),
('HI', 'USA', 'Hawai''i'),
('IA', 'USA', 'Iowa'),
('ID', 'USA', 'Idaho'),
('IL', 'USA', 'Illinois'),
('IN', 'USA', 'Indiana'),
('KS', 'USA', 'Kansas'),
('KY', 'USA', 'Kentuky'),
('LA', 'USA', 'Louisiana'),
('MA', 'USA', 'Massachusetts'),
('MB', 'Canada', 'Manitoba'),
('MD', 'USA', 'Maryland'),
('ME', 'USA', 'Maine'),
('MI', 'USA', 'Michigan'),
('MN', 'USA', 'Minnesota'),
('MO', 'USA', 'Missouri'),
('MP', 'USA', 'Northern Mariana Islands'),
('MS', 'USA', 'Mississippi'),
('MT', 'USA', 'Montana'),
('NB', 'Canada', 'New Brunswick'),
('NC', 'USA', 'North Carolina'),
('ND', 'USA', 'North Dakona'),
('NE', 'USA', 'Nebraska'),
('NH', 'USA', 'New Hampshire'),
('NJ', 'USA', 'New Jersey'),
('NL', 'Canada', 'Newfoundland and Labrador'),
('NM', 'USA', 'New Mexico'),
('NS', 'Canada', 'Nova Scotia'),
('NT', 'Canada', 'Northwest Territories'),
('NU', 'Canada', 'Nunavut'),
('NV', 'USA', 'Nevada'),
('NY', 'USA', 'New York'),
('OH', 'USA', 'Ohio'),
('OK', 'USA', 'Oklahoma'),
('ON', 'Canada', 'Ontario'),
('OR', 'USA', 'Oregon'),
('PA', 'USA', 'Pennsylvania'),
('PE', 'Canada', 'Prince Edward Island'),
('PR', 'USA', 'Puerto Rico'),
('QC', 'Canada', 'Quebec'),
('RI', 'USA', 'Rhode Island'),
('SC', 'USA', 'South Carolina'),
('SD', 'USA', 'South Dakota'),
('SK', 'Canada', 'Saskatchewan'),
('TN', 'USA', 'Tennessee'),
('TX', 'USA', 'Texas'),
('UT', 'USA', 'Utah'),
('VA', 'USA', 'Virginia'),
('VI', 'USA', 'U.S. Virgin Islands'),
('VT', 'USA', 'Vermont'),
('WA', 'USA', 'Washington'),
('WI', 'USA', 'Wisconsin'),
('WV', 'USA', 'West Virginia'),
('WY', 'USA', 'Wyoming'),
('YT', 'Canada', 'Yukon')

GO

-- Create User Table



USE [UserManager]
GO

/****** Object:  Table [dbo].[Users]    Script Date: 10/20/18 11:17:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Email] [varchar](80) NOT NULL,
	[StateProvinceID] [char](2) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Users] ADD 
CONSTRAINT [DF_Users_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO


-------------------------------------------------------------------------------------------
-- That is compressed
USE [UserManager]

ALTER TABLE dbo.[Users] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)

-----------
-- Make a Foreign Key

USE [UserManager]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  
CONSTRAINT [FK_Users_StatesProvinces] FOREIGN KEY([StateProvinceID])
REFERENCES [dbo].[StatesProvinces] ([ID])
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_StatesProvinces]
GO

