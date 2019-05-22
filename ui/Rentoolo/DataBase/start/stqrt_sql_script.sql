USE [rentoolo]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalance]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalanceByName]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Applications]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Articles]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Business]    Script Date: 17.04.2019 5:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Business](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [dbo].[CashIns]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Currencies]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[DailyStatistics]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Exceptions]    Script Date: 17.04.2019 5:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exceptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[WhenDate] [datetime] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Exceptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoginStatistics]    Script Date: 17.04.2019 5:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginStatistics](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[Ip] [nvarchar](max) NULL,
	[WhenLastDate] [datetime] NOT NULL,
	[Count] [bigint] NOT NULL,
	[Client] [int] NOT NULL,
	[Version] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_LoginStatistics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Memberships]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[News]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Operations]    Script Date: 17.04.2019 5:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Value] [float] NOT NULL,
	[Type] [int] NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Payments]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Referrals]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Settings]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[UsersOpenAuthAccounts]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[UsersOpenAuthData]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  Table [dbo].[Wallets]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetAllUsers]    Script Date: 17.04.2019 5:19:28 ******/
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
		,u.[Icq]
		,u.[VkontakteId]
		,u.[Skype]
		,m.[CreateDate]
		,m.[Email]
	FROM [Users] u
	LEFT JOIN [Memberships] m
	ON u.[UserId] = m.[UserId]
);



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetTablesRows]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsSecondLevel]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsThirdLevel]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserWallets]    Script Date: 17.04.2019 5:19:28 ******/
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
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'K4kMwLhvh7mPX8+4Y19lfm1oUkPjscLnZ4Zj7Q3m7/Y=', 1, N'ho7gCpgxYuPDASuBXt7XOw==', N'mmm@mmm22.ru', NULL, NULL, 1, 0, CAST(N'2018-04-08 23:25:09.273' AS DateTime), CAST(N'2019-01-13 20:54:39.037' AS DateTime), CAST(N'2018-06-23 19:45:50.323' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'1e256f7a-97fc-453a-9f0b-957c99c75b06', N'yFQ3gCYcF0hILmDvUve6mTj9nQkPKXPmSTileXxyfsg=', 1, N'a50gu+1zU4xb1A0g1sNNxw==', N'fasteat@outlook.com', NULL, NULL, 1, 0, CAST(N'2018-12-17 17:29:27.347' AS DateTime), CAST(N'2018-12-17 17:29:27.347' AS DateTime), CAST(N'2018-12-17 17:29:27.347' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f4b751df-6328-4553-8f4c-db280ef332d3', N'bYnO/asUBqWVAA7/dHz2nXtpiVZvIYZFPa+7Uf1QyFY=', 1, N'QvIR2dvkGtNlyi4dWUXc9A==', N'qwwwssdddqq@qqq.qw', NULL, NULL, 1, 0, CAST(N'2018-12-17 14:43:49.040' AS DateTime), CAST(N'2018-12-17 14:43:49.040' AS DateTime), CAST(N'2018-12-17 14:43:49.040' AS DateTime), CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01 00:00:00.000' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[News] ON 

GO
INSERT [dbo].[News] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Запуст проекта! Открытая регистрация пользователей.', CAST(N'2019-04-04 08:30:00.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2018-12-12 08:30:00.000' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[News] OFF
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
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'mmm', 0, CAST(N'2019-01-15 00:23:14.800' AS DateTime), N'qwerty2222', 452288, N'8-999-321-55-55', 0, N'5345435435888', N'123222', N'Sqqypeett')
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'1e256f7a-97fc-453a-9f0b-957c99c75b06', N'Sm1le', 0, CAST(N'2018-12-17 17:29:28.063' AS DateTime), N'qwe123', 962296, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [Icq], [VkontakteId], [Skype]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f4b751df-6328-4553-8f4c-db280ef332d3', N'qwerqwer', 0, CAST(N'2018-12-17 14:43:57.383' AS DateTime), N'qwerty1', 200842, NULL, 0, NULL, NULL, NULL)
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
/****** Object:  Index [IX_Referrals]    Script Date: 17.04.2019 5:19:28 ******/
ALTER TABLE [dbo].[Referrals] ADD  CONSTRAINT [IX_Referrals] UNIQUE NONCLUSTERED 
(
	[ReferralUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
ALTER TABLE [dbo].[Exceptions] ADD  CONSTRAINT [DF_Exceptions_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[LoginStatistics] ADD  CONSTRAINT [DF_LoginStatistics_WhenLastDate]  DEFAULT (getdate()) FOR [WhenLastDate]
GO
ALTER TABLE [dbo].[LoginStatistics] ADD  CONSTRAINT [DF_LoginStatistics_Client]  DEFAULT ((0)) FOR [Client]
GO
ALTER TABLE [dbo].[LoginStatistics] ADD  DEFAULT ('') FOR [Version]
GO
ALTER TABLE [dbo].[Operations] ADD  CONSTRAINT [DF_Operations_Value]  DEFAULT ((0)) FOR [Value]
GO
ALTER TABLE [dbo].[Operations] ADD  CONSTRAINT [DF_Operations_Type]  DEFAULT ((1)) FOR [Type]
GO
ALTER TABLE [dbo].[Operations] ADD  CONSTRAINT [DF_Operations_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
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
/****** Object:  StoredProcedure [dbo].[spAddWalletForUser]    Script Date: 17.04.2019 5:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spAddWalletForUser]
@userId uniqueidentifier, @currencyId int, @value float
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM Wallets 
                   WHERE UserId = @userId
                   AND CurrencyId = @currencyId)
   BEGIN
		INSERT INTO Wallets (UserId, CurrencyId, [Value])
		VALUES (@userId, @currencyId, @value)
   END
END


GO
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastDayActive]    Script Date: 17.04.2019 5:19:28 ******/
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
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastHourActive]    Script Date: 17.04.2019 5:19:28 ******/
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
