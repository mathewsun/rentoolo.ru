GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalance]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetUserBalance] (@UserId uniqueidentifier)
RETURNS float
WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @Result float;
     SET @Result =
	(SELECT Balance
	FROM [dbo].[Users] 
	WHERE UserId = @UserId);
     RETURN(@Result);
END;



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalanceByName]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetUserBalanceByName] (@UserName nvarchar(50))
RETURNS float
WITH EXECUTE AS CALLER
AS
BEGIN
     RETURN 0
	-- (SELECT Balance
	--FROM [dbo].[Users] 
	--WHERE UserName = @UserName)
END;



GO
/****** Object:  Table [dbo].[Adverts]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adverts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedUserId] [uniqueidentifier] NOT NULL,
	[Price] [float] NOT NULL,
	[Address] [nvarchar](150) NULL,
	[Phone] [nvarchar](50) NULL,
	[MessageType] [int] NOT NULL,
	[Position] [geography] NULL,
	[ImgUrls] [nvarchar](max) NULL,
 CONSTRAINT [PK_Adverts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Applications]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[ApplicationName] [nvarchar](235) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Articles]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Head] [nvarchar](max) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[WhenDate] [datetime] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Business]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Business](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Header] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Cost] [float] NULL,
	[NoCost] [bit] NOT NULL,
	[PaybackPeriod] [float] NULL,
	[MonthlyIncome] [float] NULL,
 CONSTRAINT [PK_Business] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CashIns]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashIns](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Value] [float] NOT NULL,
	[Sposob] [nvarchar](max) NOT NULL,
	[WhenDate] [datetime] NOT NULL,
	[AcceptedAccount] [nvarchar](50) NOT NULL,
	[SendAccount] [nvarchar](50) NULL,
 CONSTRAINT [PK_CashIns] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Categories]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Name(Ru)] [nvarchar](50) NOT NULL,
	[OrderId] [int] NOT NULL CONSTRAINT [DF_Categories_OrderId]  DEFAULT ((1))
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Currencies]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currencies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Acronim] [nvarchar](50) NOT NULL,
	[DateAdd] [datetime] NOT NULL CONSTRAINT [DF_Cryptocurrencies2_DateAdd]  DEFAULT (getdate()),
	[IsValid] [bit] NOT NULL CONSTRAINT [DF_Cryptocurrencies2_IsValid]  DEFAULT ((1)),
 CONSTRAINT [PK_Cryptocurrencies2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DailyStatistics]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyStatistics](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[UserAdded] [int] NOT NULL,
	[DepositeAdded] [float] NOT NULL,
 CONSTRAINT [PK_DailyStatistics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Exceptions]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exceptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[WhenDate] [datetime] NOT NULL CONSTRAINT [DF_Exceptions_WhenDate]  DEFAULT (getdate()),
	[UserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Exceptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Favorites]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favorites](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_Favorites_Created]  DEFAULT (getdate()),
 CONSTRAINT [PK_Favorites] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FavoritesByCookies]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FavoritesByCookies](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserCookiesId] [nvarchar](36) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_FavoritesByCookies_Created]  DEFAULT (getdate()),
 CONSTRAINT [PK_FavoritesByCookies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Items]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Items](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Cost] [float] NOT NULL,
	[Address] [nvarchar](150) NULL,
	[CoordinateX] [decimal](9, 6) NULL,
	[CoordinateY] [decimal](9, 6) NULL,
	[Coordinate] [geography] NULL,
	[Phone] [nvarchar](20) NULL,
	[CommunicationType] [int] NOT NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoginStatistics]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginStatistics](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[Ip] [nvarchar](max) NULL,
	[WhenLastDate] [datetime] NOT NULL CONSTRAINT [DF_LoginStatistics_WhenLastDate]  DEFAULT (getdate()),
	[Count] [bigint] NOT NULL,
	[Client] [int] NOT NULL CONSTRAINT [DF_LoginStatistics_Client]  DEFAULT ((0)),
	[Version] [nvarchar](10) NOT NULL DEFAULT (''),
 CONSTRAINT [PK_LoginStatistics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Memberships]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Memberships](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowsStart] [datetime] NOT NULL,
	[Comment] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[News]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL CONSTRAINT [DF_New_Date]  DEFAULT (getdate()),
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_New_CreateDate]  DEFAULT (getdate()),
	[Active] [bit] NULL,
 CONSTRAINT [PK_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Operations]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Value] [float] NOT NULL CONSTRAINT [DF_Operations_Value]  DEFAULT ((0)),
	[Type] [int] NOT NULL CONSTRAINT [DF_Operations_Type]  DEFAULT ((1)),
	[Comment] [nvarchar](max) NOT NULL,
	[WhenDate] [datetime] NOT NULL CONSTRAINT [DF_Operations_WhenDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Payments]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserIdSender] [uniqueidentifier] NOT NULL,
	[UserIdRecepient] [uniqueidentifier] NOT NULL,
	[Value] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
	[Comment] [nvarchar](max) NULL,
 CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Referrals]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Referrals](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReferrerUserId] [uniqueidentifier] NOT NULL,
	[ReferralUserId] [uniqueidentifier] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Refferals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Settings]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Settings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Order] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[UpdateDate] [datetime] NOT NULL CONSTRAINT [DF_Settings_UpdateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
	[Pwd] [nvarchar](max) NULL,
	[PublicId] [int] NOT NULL CONSTRAINT [DF_Users_PublicId]  DEFAULT ((0)),
	[Communication] [nvarchar](max) NULL,
	[ReffAdd] [float] NOT NULL CONSTRAINT [DF_Users_ReffAdd]  DEFAULT ((0)),
	[Icq] [nvarchar](50) NULL,
	[VkontakteId] [nvarchar](100) NULL,
	[Skype] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersInRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UsersOpenAuthAccounts]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersOpenAuthAccounts](
	[ApplicationName] [nvarchar](128) NOT NULL,
	[ProviderName] [nvarchar](128) NOT NULL,
	[ProviderUserId] [nvarchar](128) NOT NULL,
	[ProviderUserName] [nvarchar](max) NOT NULL,
	[MembershipUserName] [nvarchar](128) NOT NULL,
	[LastUsedUtc] [datetime] NULL,
 CONSTRAINT [PK_dbo.UsersOpenAuthAccounts] PRIMARY KEY CLUSTERED 
(
	[ApplicationName] ASC,
	[ProviderName] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UsersOpenAuthData]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersOpenAuthData](
	[ApplicationName] [nvarchar](128) NOT NULL,
	[MembershipUserName] [nvarchar](128) NOT NULL,
	[HasLocalPassword] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.UsersOpenAuthData] PRIMARY KEY CLUSTERED 
(
	[ApplicationName] ASC,
	[MembershipUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Wallets]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wallets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[Value] [float] NOT NULL CONSTRAINT [DF_Wallets_Value]  DEFAULT ((0)),
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Wallets_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Wallets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetAllUsers]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetAllUsers] ()
RETURNS table
AS
RETURN 
(
	SELECT 	u.[UserId]
		,u.[UserName]
		,u.[LastActivityDate]
		,u.[Pwd]
		,u.[PublicId]
		,u.[Communication]
		,m.[CreateDate]
		,m.[Email]
	FROM [Users] u
	LEFT JOIN [Memberships] m
	ON u.[UserId] = m.[UserId]
);

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetTablesRows]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetTablesRows] ()
RETURNS table
AS
RETURN 
(
	SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
	FROM 
		  sys.objects AS sOBJ
		  INNER JOIN sys.partitions AS sPTN
				ON sOBJ.object_id = sPTN.object_id
	WHERE
		  sOBJ.type = 'U'
		  AND sOBJ.is_ms_shipped = 0x0
		  AND index_id < 2 -- 0:Heap, 1:Clustered
	GROUP BY 
		  sOBJ.schema_id
		  , sOBJ.name
	--ORDER BY [RowCount] desc
);



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsSecondLevel]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetUserReferralsSecondLevel] (@userId uniqueidentifier)
RETURNS table
AS
RETURN 
(
SELECT r.*, u.PublicId, u.UserName, rup1lvl.ReferrerUserId as refererUp1Lvl
FROM Referrals r
left join Referrals rup1lvl
on rup1lvl.ReferralUserId = r.ReferrerUserId
left join Users u
on u.UserId = r.ReferralUserId
where rup1lvl.ReferrerUserId = @userId
);



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsThirdLevel]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetUserReferralsThirdLevel] (@userId uniqueidentifier)
RETURNS table
AS
RETURN 
(
SELECT r.*, u.PublicId, u.UserName, rup2lvl.ReferrerUserId as refererUp2Lvl
FROM Referrals r
left join Referrals rup1lvl
on rup1lvl.ReferralUserId = r.ReferrerUserId
left join Referrals rup2lvl
on rup2lvl.ReferralUserId = rup1lvl.ReferrerUserId
left join Users u
on u.UserId = r.ReferralUserId
where rup2lvl.ReferrerUserId = @userId
);



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserWallets]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetUserWallets] (@userId uniqueidentifier)
RETURNS table
AS
RETURN 
(
	SELECT 	w.[Id]
		,w.[CurrencyId]
		,w.[Value]
		,c.[Name]
		,c.[Acronim]
	FROM [Wallets] w
	LEFT JOIN [Currencies] c
	ON w.[CurrencyId] = c.[Id]
	WHERE w.[UserId] = @userId
);


GO
INSERT [dbo].[Applications] ([ApplicationName], [ApplicationId], [Description]) VALUES (N'/', N'234ee901-21d6-4952-b871-b815b148fe46', NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (10, N'Transport', N'Транспорт', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (101, N'Auto', N'Автомобили', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (102, N'Moto', N'Мотоциклы и мототехника', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (103, N'Truck', N'Грузовики и спецтехника', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (104, N'WaterTransport', N'Водный транспорт', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (105, N'SpareParts', N'Запчасти и аксессуары', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (20, N'Realty', N'Недвижимость', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (201, N'Apartment', N'Квартиры', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (202, N'Room', N'Комнаты', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (203, N'House', N'Дома, дачи, коттеджи', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (204, N'Land', N'Земельные участки', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (205, N'Garage', N'Гаражи и машиноместа', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (206, N'CommercialRealEstate', N'Коммерческая недвижимость', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (207, N'RealEstateAbroad', N'Недвижимость за рубежом', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (30, N'Job', N'Работа', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (301, N'Vacancy', N'Вакансии', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (302, N'Resume', N'Резюме', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (40, N'Services', N'Услуги', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (401, N'ItInternetTelecom', N'IT, интернет, телеком', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (4011, N'WebsiteDevelopmentMarketing', N'Cоздание и продвижение сайтов', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (40111, N'WebsiteDevelopment', N'Создание сайтов', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (40112, N'WebsiteMarketing', N'Продвижение сайтов', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (4012, N'SoftwareInstallationSetup', N'Установка и настройка ПО', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (4013, N'SettingupInternetNetworks', N'Настройка интернета и сетей', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (4014, N'ItMaster', N'It мастер на все случаи', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (50, N'PersonalGoods', N'Личные вещи', 1)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId]) VALUES (501, N'ClothesShoesAccessories', N'Одежда, обувь, аксессуары', 1)
GO
SET IDENTITY_INSERT [dbo].[Currencies] ON 

GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (1, N'Russian Ruble', N'RURT', CAST(N'2018-11-18 19:07:12.273' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (2, N'United States Dollar', N'USDT', CAST(N'2018-12-11 15:01:55.457' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (3, N'Bitcoin', N'BTC', CAST(N'2018-12-11 15:02:12.333' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (4, N'Ethereum', N'ETH', CAST(N'2018-12-11 15:02:30.663' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (5, N'Ripple', N'XRP', CAST(N'2018-12-11 15:38:30.220' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (6, N'EOS', N'EOS', CAST(N'2018-12-11 15:38:48.550' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (7, N'Decentraland', N'MANA', CAST(N'2018-12-11 15:51:16.407' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[Currencies] OFF
GO
SET IDENTITY_INSERT [dbo].[Exceptions] ON 

GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (1, N'Строка не найдена или изменена.', CAST(N'2019-07-12 00:51:12.257' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Exceptions] OFF
GO
SET IDENTITY_INSERT [dbo].[Favorites] ON 

GO
INSERT [dbo].[Favorites] ([Id], [UserId], [AdvertId], [Created]) VALUES (1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 222, CAST(N'2019-07-28 03:58:42.477' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Favorites] OFF
GO
SET IDENTITY_INSERT [dbo].[FavoritesByCookies] ON 

GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (2, N'f75498fb-fa7a-4914-9ed5-3afa77ffa96f', 222, CAST(N'2019-07-28 03:46:12.333' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (3, N'a0091786-0021-4579-9b32-18da2d501caa', 222, CAST(N'2019-08-05 22:18:30.893' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[FavoritesByCookies] OFF
GO
SET IDENTITY_INSERT [dbo].[LoginStatistics] ON 

GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14543, N'mmmm', N'192.168.1.1', CAST(N'2019-06-01 19:46:28.847' AS DateTime), 20, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14544, N'mmm', N'::1', CAST(N'2019-08-24 13:33:55.373' AS DateTime), 222, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14545, N'mmmm', N'66.102.9.8', CAST(N'2019-05-22 01:24:03.583' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14546, N'mmmm', N'66.102.9.14', CAST(N'2019-05-22 01:24:09.590' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14547, N'mmmm', N'66.102.9.11', CAST(N'2019-05-22 10:00:17.850' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14548, N'dddddd', N'::1', CAST(N'2019-05-30 02:31:23.493' AS DateTime), 4, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14549, N'hhh', N'::1', CAST(N'2019-06-01 19:02:52.567' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14550, N'mmmm', N'66.102.9.40', CAST(N'2019-06-02 20:38:37.920' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14551, N'mmm', N'66.102.9.40', CAST(N'2019-06-19 09:02:06.467' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14552, N'mmm', N'83.220.238.240', CAST(N'2019-06-08 21:54:43.663' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14553, N'mmm', N'66.102.9.42', CAST(N'2019-06-08 21:54:43.163' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14554, N'mmm', N'192.168.1.1', CAST(N'2019-08-24 15:49:17.143' AS DateTime), 93, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14555, N'mmm', N'194.186.38.113', CAST(N'2019-06-17 13:54:38.760' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14556, N'mmm', N'66.102.9.38', CAST(N'2019-07-28 21:20:14.640' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14557, N'qwer', N'::1', CAST(N'2019-07-09 22:52:50.713' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14558, N'Hhhgg', N'66.102.9.42', CAST(N'2019-07-09 23:09:44.720' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14559, N'Hhhgg', N'91.193.177.1', CAST(N'2019-07-09 23:09:56.560' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14560, N'mmmyyy', N'66.102.9.38', CAST(N'2019-07-26 17:15:04.183' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14561, N'mmm', N'83.220.236.162', CAST(N'2019-08-08 17:58:21.520' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14562, N'mmm', N'217.77.104.20', CAST(N'2019-08-09 10:10:30.060' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14563, N'kkk', N'::1', CAST(N'2019-08-24 02:28:25.820' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14564, N'kkkr', N'::1', CAST(N'2019-08-24 02:32:31.657' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14565, N'nnn', N'192.168.1.1', CAST(N'2019-08-24 15:49:22.510' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14566, N'kkke', N'192.168.1.1', CAST(N'2019-08-24 15:50:19.637' AS DateTime), 0, 0, N'')
GO
SET IDENTITY_INSERT [dbo].[LoginStatistics] OFF
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'b98b7ebc-4d5e-405b-88d8-087421c50b8e', N'huULzXiHggt6nMmmS99xqOVAoLmEK1lsivziW5Bup20=', 1, N'YsKSD6kPT8dwNwajpg4OqA==', N'qwqw34@dterty.rt', NULL, NULL, 1, 0, CAST(N'2019-06-01 16:02:48.347' AS DateTime), CAST(N'2019-06-01 16:02:48.347' AS DateTime), CAST(N'2019-06-01 16:02:48.347' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f42ba606-48bf-45ef-9ea4-1ee8c44add71', N'JmPjTm1xOZbqnOiWcga4Ji5fpoimxFV7kH+7s4eYyFY=', 1, N'Uo7CfMhy1LZEbK1B1Tpvsg==', N'wertgwret@wrty.rt', NULL, NULL, 1, 0, CAST(N'2019-08-23 23:32:27.017' AS DateTime), CAST(N'2019-08-23 23:32:27.017' AS DateTime), CAST(N'2019-08-23 23:32:27.017' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'90553147-77ee-4561-b0f7-1f239afac377', N'T21vh9EpEqeNCsJ1F+DVTxfdZz/p5X3h/200cZYQO/s=', 1, N'dctEroda38LDQz00FTbxxQ==', N'Fghgg@ffh.ru', NULL, NULL, 1, 0, CAST(N'2019-07-09 20:09:44.003' AS DateTime), CAST(N'2019-07-09 20:09:44.003' AS DateTime), CAST(N'2019-07-09 20:09:44.003' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'b1e3c30f-91b1-48c1-a2e4-5c8cc7b75dc7', N'0FgbF9kMT73o0b2yClopwWlwg9M6yF8Kbt/lOx3DGZ0=', 1, N'Vr6pbjUR1QeUs0I+kKO8KQ==', N'nnn@ert.rt', NULL, NULL, 1, 0, CAST(N'2019-08-24 12:44:51.830' AS DateTime), CAST(N'2019-08-24 12:44:51.830' AS DateTime), CAST(N'2019-08-24 12:44:51.830' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'c11636fe-d0d9-4a60-8647-6f00f6154c29', N'NvE/uVcJMQXJaOyr1WiuqGfEdGejN55Gi4SmViF07KU=', 1, N'+5C1dcMmt4qLlUFLOfu5Tw==', N'dfgdfg@sdfgsdf.gh', NULL, NULL, 1, 0, CAST(N'2019-05-29 23:27:42.610' AS DateTime), CAST(N'2019-05-29 23:27:42.610' AS DateTime), CAST(N'2019-05-29 23:27:42.610' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'K4kMwLhvh7mPX8+4Y19lfm1oUkPjscLnZ4Zj7Q3m7/Y=', 1, N'ho7gCpgxYuPDASuBXt7XOw==', N'mmm@mmm22.ru', NULL, NULL, 1, 0, CAST(N'2018-04-08 23:25:09.273' AS DateTime), CAST(N'2019-08-24 11:25:10.083' AS DateTime), CAST(N'2018-06-23 19:45:50.323' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'1e256f7a-97fc-453a-9f0b-957c99c75b06', N'yFQ3gCYcF0hILmDvUve6mTj9nQkPKXPmSTileXxyfsg=', 1, N'a50gu+1zU4xb1A0g1sNNxw==', N'fasteat@outlook.com', NULL, NULL, 1, 0, CAST(N'2018-12-17 17:29:27.347' AS DateTime), CAST(N'2018-12-17 17:29:27.347' AS DateTime), CAST(N'2018-12-17 17:29:27.347' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'9350b6bd-62dc-4e69-86fc-abd4fdfed066', N'asfQu4VL/6/5n72TVlJOi2Odll6S7syOk0rgLIFx5Fg=', 1, N'jtEsGs4BjCa+uW8w7rir/g==', N'wwdw@iuy.ri', NULL, NULL, 1, 0, CAST(N'2019-08-24 12:50:19.137' AS DateTime), CAST(N'2019-08-24 12:50:19.137' AS DateTime), CAST(N'2019-08-24 12:50:19.137' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'd9112c68-192f-40f5-b678-ad25e61d092e', N'JkueKEeFH7GdoW0Sx8wIpUejAQF4srT2THe8b79VE9s=', 1, N'px8Ps38hRy9/Bfs1rBkHmQ==', N'uiryu@wert.ty', NULL, NULL, 1, 0, CAST(N'2019-08-23 23:28:21.770' AS DateTime), CAST(N'2019-08-23 23:28:21.770' AS DateTime), CAST(N'2019-08-23 23:28:21.770' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'4f8e9d04-5c62-405a-8011-b207702f3b54', N'T1LqNOr4ZD8NzQrwsBOpxTLPGhQU6oUJw2yxegCX6TU=', 1, N'ytusKP4Ku8mfmJz/T6o1Zg==', N'qwer@wqert.er', NULL, NULL, 1, 0, CAST(N'2019-07-09 19:52:43.120' AS DateTime), CAST(N'2019-07-09 19:52:43.120' AS DateTime), CAST(N'2019-07-09 19:52:43.120' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'a52f6fd5-0b77-4345-b7e1-ce1ede063d64', N'9V4qDtuRfoSvARvG7KdhPIgolPJQ6yM/ecyhs8UvbT4=', 1, N'OGwN66VNlbzglrtI0nx6mA==', N'fghdfg@sdfg.er', NULL, NULL, 1, 0, CAST(N'2019-05-19 21:31:49.467' AS DateTime), CAST(N'2019-06-02 02:11:44.417' AS DateTime), CAST(N'2019-05-19 21:31:49.467' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f4b751df-6328-4553-8f4c-db280ef332d3', N'bYnO/asUBqWVAA7/dHz2nXtpiVZvIYZFPa+7Uf1QyFY=', 1, N'QvIR2dvkGtNlyi4dWUXc9A==', N'qwwwssdddqq@qqq.qw', NULL, NULL, 1, 0, CAST(N'2018-12-17 14:43:49.040' AS DateTime), CAST(N'2018-12-17 14:43:49.040' AS DateTime), CAST(N'2018-12-17 14:43:49.040' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'20a94868-76d0-456d-8268-e7c1318f03d3', N'CtoEgdB36ixKYO5lBR7rdOh8htgWelow8rwQElS/z90=', 1, N'ChNt8aptlfhHn2jCkayfqg==', N'qwer@wqрttпert.er', NULL, NULL, 1, 0, CAST(N'2019-07-26 14:15:03.497' AS DateTime), CAST(N'2019-07-26 14:15:03.497' AS DateTime), CAST(N'2019-07-26 14:15:03.497' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[News] ON 

GO
INSERT [dbo].[News] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Запуст проекта! Открытая регистрация пользователей.', CAST(N'2019-05-01 08:30:00.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2019-01-01 08:30:00.000' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[News] OFF
GO
SET IDENTITY_INSERT [dbo].[Operations] ON 

GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3, N'a52f6fd5-0b77-4345-b7e1-ce1ede063d64', 0, 14, N'Учетная запись создана.', CAST(N'2019-05-20 00:31:49.747' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (4, N'c11636fe-d0d9-4a60-8647-6f00f6154c29', 0, 14, N'Учетная запись создана.', CAST(N'2019-05-30 02:27:42.690' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (5, N'b98b7ebc-4d5e-405b-88d8-087421c50b8e', 0, 14, N'Учетная запись создана.', CAST(N'2019-06-01 19:02:48.493' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (6, N'4f8e9d04-5c62-405a-8011-b207702f3b54', 0, 14, N'Учетная запись создана.', CAST(N'2019-07-09 22:52:43.370' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (7, N'90553147-77ee-4561-b0f7-1f239afac377', 0, 14, N'Учетная запись создана.', CAST(N'2019-07-09 23:09:44.237' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (8, N'20a94868-76d0-456d-8268-e7c1318f03d3', 0, 14, N'Учетная запись создана.', CAST(N'2019-07-26 17:15:03.763' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (9, N'd9112c68-192f-40f5-b678-ad25e61d092e', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24 02:28:22.043' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (10, N'f42ba606-48bf-45ef-9ea4-1ee8c44add71', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24 02:32:27.477' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (11, N'b1e3c30f-91b1-48c1-a2e4-5c8cc7b75dc7', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24 15:44:52.577' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (12, N'9350b6bd-62dc-4e69-86fc-abd4fdfed066', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24 15:50:19.357' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Operations] OFF
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b6f8834-7b96-43e1-9dec-16115fd48554', N'KeyManager', NULL)
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'211ee111-19d6-4951-b87c-b215b542fe11', N'Administrator', NULL)
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'234ee951-11d6-2151-b87c-b815b542fe41', N'CashOutManager', NULL)
GO
SET IDENTITY_INSERT [dbo].[Settings] ON 

GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (2, 1, N'HoursDifference', N'0', N'Разница во времени с сервером', CAST(N'2018-06-22 14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (3, 2, N'ReferralPercent', N'10', N'Реферальные проценты 1го уровня', CAST(N'2018-06-22 14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (7, 3, N'ReferralPercent2', N'5', N'Реферальный процент 2го уровня', CAST(N'2018-06-22 14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (9, 4, N'ReferralPercent3', N'5', N'Реферальный процент 3го уровня', CAST(N'2018-06-22 14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (11, 20, N'UsersCount', N'5', N'Количество пользователей в системе, отображаемое на главной странице', CAST(N'2018-11-17 23:51:02.053' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (12, 21, N'UsersCountRegisteredToday', N'2', N'Количество пользователей зарегистрированных за 24 часа', CAST(N'2018-11-17 23:51:02.057' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (13, 22, N'UsersCountOnline', N'2', N'Количество пользователей онлайн', CAST(N'2018-11-17 23:51:02.057' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Settings] OFF
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'b98b7ebc-4d5e-405b-88d8-087421c50b8e', N'hhh', 0, CAST(N'2019-06-01 16:02:48.657' AS DateTime), N'', 704037, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f42ba606-48bf-45ef-9ea4-1ee8c44add71', N'kkkr', 0, CAST(N'2019-08-23 23:32:27.873' AS DateTime), N'', 906826, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'90553147-77ee-4561-b0f7-1f239afac377', N'Hhhgg', 0, CAST(N'2019-07-09 20:09:44.703' AS DateTime), N'', 441934, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'b1e3c30f-91b1-48c1-a2e4-5c8cc7b75dc7', N'nnn', 0, CAST(N'2019-08-24 12:49:22.433' AS DateTime), N'', 911744, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'c11636fe-d0d9-4a60-8647-6f00f6154c29', N'dddddd', 0, CAST(N'2019-05-29 23:30:27.900' AS DateTime), N'', 826476, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'mmm', 0, CAST(N'2019-08-24 11:25:10.083' AS DateTime), N'', 452288, N'8-999-321-55-55', 0, N'5345435435888', N'123222', N'Sqqypeett')
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'1e256f7a-97fc-453a-9f0b-957c99c75b06', N'Sm1le', 0, CAST(N'2018-12-17 17:29:28.063' AS DateTime), N'', 962296, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'9350b6bd-62dc-4e69-86fc-abd4fdfed066', N'kkke', 0, CAST(N'2019-08-24 12:50:19.637' AS DateTime), NULL, 715388, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'd9112c68-192f-40f5-b678-ad25e61d092e', N'kkk', 0, CAST(N'2019-08-23 23:28:22.187' AS DateTime), N'', 719017, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'4f8e9d04-5c62-405a-8011-b207702f3b54', N'qwer', 0, CAST(N'2019-07-09 19:52:43.577' AS DateTime), N'', 688961, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'a52f6fd5-0b77-4345-b7e1-ce1ede063d64', N'mmmm', 0, CAST(N'2019-06-02 02:11:44.807' AS DateTime), N'', 968299, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f4b751df-6328-4553-8f4c-db280ef332d3', N'qwerqwer', 0, CAST(N'2018-12-17 14:43:57.383' AS DateTime), N'', 200842, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'20a94868-76d0-456d-8268-e7c1318f03d3', N'mmmyyy', 0, CAST(N'2019-07-26 14:15:04.167' AS DateTime), N'', 132536, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'8b6f8834-7b96-43e1-9dec-16115fd48554')
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'211ee111-19d6-4951-b87c-b215b542fe11')
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'234ee951-11d6-2151-b87c-b815b542fe41')
GO
SET IDENTITY_INSERT [dbo].[Wallets] ON 

GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1, 872, CAST(N'2018-12-13 18:25:08.420' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (2, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2, 515, CAST(N'2018-12-18 11:42:46.400' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (3, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 3, 212, CAST(N'2018-12-18 11:43:00.200' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (4, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4, 10024, CAST(N'2018-12-18 11:43:22.290' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (5, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5, 22, CAST(N'2018-12-18 11:43:37.243' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (6, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 6, 700, CAST(N'2018-12-18 11:43:52.710' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (7, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 7, 28, CAST(N'2018-12-18 11:44:13.077' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Wallets] OFF
GO
/****** Object:  Index [IX_Referrals]    Script Date: 24.08.2019 15:51:48 ******/
ALTER TABLE [dbo].[Referrals] ADD  CONSTRAINT [IX_Referrals] UNIQUE NONCLUSTERED 
(
	[ReferralUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_Price]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_MessageType]  DEFAULT ((1)) FOR [MessageType]
GO
ALTER TABLE [dbo].[Articles] ADD  CONSTRAINT [DF_Articles_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[Business] ADD  CONSTRAINT [DF_Business_NoCost]  DEFAULT ((0)) FOR [NoCost]
GO
ALTER TABLE [dbo].[CashIns] ADD  CONSTRAINT [DF_CashIns_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[CashIns] ADD  CONSTRAINT [DF_CashIns_AcceptedAccount]  DEFAULT ((0)) FOR [AcceptedAccount]
GO
ALTER TABLE [dbo].[DailyStatistics] ADD  CONSTRAINT [DF_DailyStatistics_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Items] ADD  CONSTRAINT [DF_Items_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[Items] ADD  CONSTRAINT [DF_Items_CommunicationType]  DEFAULT ((1)) FOR [CommunicationType]
GO
ALTER TABLE [dbo].[Referrals] ADD  CONSTRAINT [DF_Refferals_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[CashIns]  WITH CHECK ADD  CONSTRAINT [FK_CashIns_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[CashIns] CHECK CONSTRAINT [FK_CashIns_Users]
GO
ALTER TABLE [dbo].[Memberships]  WITH CHECK ADD  CONSTRAINT [MembershipApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Memberships] CHECK CONSTRAINT [MembershipApplication]
GO
ALTER TABLE [dbo].[Memberships]  WITH CHECK ADD  CONSTRAINT [MembershipUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Memberships] CHECK CONSTRAINT [MembershipUser]
GO
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_News_Users] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_News_Users]
GO
ALTER TABLE [dbo].[Referrals]  WITH CHECK ADD  CONSTRAINT [FK_Referrals_Users] FOREIGN KEY([ReferralUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Referrals] CHECK CONSTRAINT [FK_Referrals_Users]
GO
ALTER TABLE [dbo].[Referrals]  WITH CHECK ADD  CONSTRAINT [FK_Referrals_Users1] FOREIGN KEY([ReferrerUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Referrals] CHECK CONSTRAINT [FK_Referrals_Users1]
GO
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [RoleApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [RoleApplication]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [UserApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [UserApplication]
GO
ALTER TABLE [dbo].[UsersInRoles]  WITH CHECK ADD  CONSTRAINT [UsersInRoleRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[UsersInRoles] CHECK CONSTRAINT [UsersInRoleRole]
GO
ALTER TABLE [dbo].[UsersInRoles]  WITH CHECK ADD  CONSTRAINT [UsersInRoleUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UsersInRoles] CHECK CONSTRAINT [UsersInRoleUser]
GO
ALTER TABLE [dbo].[UsersOpenAuthAccounts]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UsersOpenAuthAccounts_dbo.UsersOpenAuthData_ApplicationName_MembershipUserName] FOREIGN KEY([ApplicationName], [MembershipUserName])
REFERENCES [dbo].[UsersOpenAuthData] ([ApplicationName], [MembershipUserName])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsersOpenAuthAccounts] CHECK CONSTRAINT [FK_dbo.UsersOpenAuthAccounts_dbo.UsersOpenAuthData_ApplicationName_MembershipUserName]
GO
ALTER TABLE [dbo].[Wallets]  WITH CHECK ADD  CONSTRAINT [FK_Wallets_Cryptocurrencies] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currencies] ([Id])
GO
ALTER TABLE [dbo].[Wallets] CHECK CONSTRAINT [FK_Wallets_Cryptocurrencies]
GO
ALTER TABLE [dbo].[Wallets]  WITH CHECK ADD  CONSTRAINT [FK_Wallets_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Wallets] CHECK CONSTRAINT [FK_Wallets_Users]
GO
/****** Object:  StoredProcedure [dbo].[spAddFavorites]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spAddFavorites]
@UserId uniqueidentifier, @advertId bigint
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM Favorites 
                   WHERE UserId = @UserId
                   AND AdvertId = @advertId)
   BEGIN
       INSERT INTO Favorites (UserId, AdvertId)
       VALUES (@UserId, @advertId)
   END
END

GO
/****** Object:  StoredProcedure [dbo].[spAddFavoritesByCookies]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spAddFavoritesByCookies]
@uid nvarchar(36), @advertId bigint
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM FavoritesByCookies 
                   WHERE UserCookiesId = @uid
                   AND AdvertId = @advertId)
   BEGIN
       INSERT INTO FavoritesByCookies (UserCookiesId, AdvertId)
       VALUES (@uid, @advertId)
   END
END

GO
/****** Object:  StoredProcedure [dbo].[spGetFavorites]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetFavorites]
@userId uniqueidentifier
AS
BEGIN
	SELECT f.[Id]
      ,f.[AdvertId]
      ,f.[Created] CreatedFavorites
	  ,a.[Category]
	  ,a.[Name]
      ,a.[Description]
      ,a.[Created] CreatedAdverts
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[Favorites] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[UserId] = @userId
	ORDER BY CreatedFavorites DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetFavoritesByCookies]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetFavoritesByCookies]
@uid nvarchar(50)
AS
BEGIN
	SELECT f.[Id]
      ,f.[AdvertId]
      ,f.[Created] CreatedFavorites
	  ,a.[Category]
	  ,a.[Name]
      ,a.[Description]
      ,a.[Created] CreatedAdverts
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[FavoritesByCookies] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[UserCookiesId] = @uid
	ORDER BY CreatedFavorites DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastDayActive]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetLoginStatisticLastDayActive]
AS
BEGIN
	DECLARE @Result int;
    SET @Result =
	(SELECT Count(distinct [UserName])
	FROM [LoginStatistics]
	where [WhenLastDate] > DATEADD(DAY, -1, GETDATE()) 
	 );
     RETURN(@Result);
END



GO
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastHourActive]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetLoginStatisticLastHourActive]
AS
BEGIN
	DECLARE @Result int;
    SET @Result =
	(SELECT Count(distinct [UserName])
	FROM [LoginStatistics]
	where [WhenLastDate] > DATEADD(HOUR, -1, GETDATE()) 
	 );
     RETURN(@Result);
END



GO
/****** Object:  StoredProcedure [dbo].[spGetUserAdverts]    Script Date: 24.08.2019 15:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetUserAdverts]
@UserId uniqueidentifier
AS
BEGIN
	SELECT a.[Id]
      ,a.[Category]
      ,a.[Name]
      ,a.[Description]
      ,a.[Created]
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
      ,a.[Position]
	FROM [Adverts] a
	WHERE a.[CreatedUserId] = @UserId
	ORDER BY a.[Created] DESC
END

GO
