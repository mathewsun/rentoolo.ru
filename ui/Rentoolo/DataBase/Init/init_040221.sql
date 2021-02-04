USE [Rentoolo]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalance]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalanceByName]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
	[Pwd] [nvarchar](max) NULL,
	[PublicId] [int] NOT NULL,
	[Communication] [nvarchar](max) NULL,
	[ReffAdd] [float] NOT NULL,
	[LastGeoposition] [nvarchar](51) NULL,
	[Language] [nvarchar](10) NULL,
	[Sex] [int] NULL,
	[Interests] [nvarchar](max) NULL,
	[WorkPlace] [nvarchar](max) NULL,
	[AboutUser] [nvarchar](max) NULL,
	[BirthDay] [datetime] NULL,
	[UniqueUserName] [nvarchar](50) NULL,
	[SelectedCity] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Memberships]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetAllUsers]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  Table [dbo].[Referrals]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Referrals] UNIQUE NONCLUSTERED 
(
	[ReferralUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsSecondLevel]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsThirdLevel]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  Table [dbo].[Wallets]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wallets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[Value] [float] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Wallets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currencies]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currencies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Acronim] [nvarchar](50) NOT NULL,
	[DateAdd] [datetime] NOT NULL,
	[IsValid] [bit] NOT NULL,
 CONSTRAINT [PK_Cryptocurrencies2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserWallets]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetTablesRows]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  Table [dbo].[Adverts]    Script Date: 04.02.2021 19:05:47 ******/
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
	[YouTubeUrl] [nvarchar](max) NULL,
	[IsApproved] [bit] NOT NULL,
	[WhenAdminApproved] [datetime] NULL,
	[Subcategory] [int] NULL,
	[Color] [nvarchar](50) NULL,
	[Vin] [nvarchar](50) NULL,
	[Brand] [nvarchar](max) NULL,
 CONSTRAINT [PK_Adverts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articles]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuctionRequests]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuctionRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Price] [money] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AuctionId] [int] NOT NULL,
 CONSTRAINT [PK_AuctionRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Auctions]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auctions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[StartPrice] [money] NOT NULL,
	[Created] [datetime] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ImgUrls] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DataEnd] [datetime] NULL,
 CONSTRAINT [PK_Auctions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Business]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CashIns]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CashOuts]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashOuts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Value] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
	[Sposob] [nvarchar](max) NOT NULL,
	[WhenAdminEvent] [datetime] NULL,
	[State] [int] NOT NULL,
	[Number] [nvarchar](max) NULL,
	[Comment] [nvarchar](max) NULL,
	[Type] [int] NOT NULL,
	[PaymentNumber] [nvarchar](50) NULL,
	[Result] [int] NOT NULL,
 CONSTRAINT [PK_CashOuts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Name(Ru)] [nvarchar](50) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ParentCategoryId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatActiveUsers]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatActiveUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ChatId] [bigint] NOT NULL,
 CONSTRAINT [PK_ChatActiveUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatInviteTokens]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatInviteTokens](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ChatId] [bigint] NOT NULL,
	[Token] [uniqueidentifier] NOT NULL,
	[Status] [smallint] NOT NULL,
 CONSTRAINT [PK_ChatInviteTokens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[ChatId] [bigint] NOT NULL,
 CONSTRAINT [PK_ChatMessages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Chats]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chats](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[ChatName] [nvarchar](50) NULL,
	[ChatType] [smallint] NOT NULL,
	[AnotherOwnerId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Chats] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatUsers]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatUsers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ChatId] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ChatUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[AdvertId] [int] NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Likes] [int] NOT NULL,
	[DisLikes] [int] NOT NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Complaints]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Complaints](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[ComplaintType] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
	[ObjectType] [int] NOT NULL,
	[UserSender] [uniqueidentifier] NOT NULL,
	[UserRecipier] [uniqueidentifier] NOT NULL,
	[Data] [datetime] NOT NULL,
	[Status] [tinyint] NULL,
 CONSTRAINT [PK_Complaints] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CraftsMan]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CraftsMan](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [int] NOT NULL,
	[Craft] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Price] [float] NOT NULL,
	[Address] [nvarchar](150) NULL,
	[Phone] [nvarchar](50) NULL,
	[Position] [geography] NULL,
	[ImgUrls] [nvarchar](max) NULL,
	[YouTubeUrl] [nvarchar](max) NULL,
	[Subcategory] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
 CONSTRAINT [PK_CraftsMan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CraftsManOrder]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CraftsManOrder](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [int] NOT NULL,
	[NameTask] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Price] [float] NOT NULL,
	[Address] [nvarchar](150) NULL,
	[Phone] [nvarchar](50) NULL,
	[Position] [geography] NULL,
	[ImgUrls] [nvarchar](max) NULL,
	[YouTubeUrl] [nvarchar](max) NULL,
	[Subcategory] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
 CONSTRAINT [PK_CraftsManOrder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DailyStatistics]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeletedAdverts]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeletedAdverts](
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
	[YouTubeUrl] [nvarchar](max) NULL,
	[IsApproved] [bit] NOT NULL,
	[WhenAdminApproved] [datetime] NULL,
	[Subcategory] [int] NULL,
 CONSTRAINT [PK_Deleted_Adverts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DialogActiveUsers]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DialogActiveUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[DialogId] [int] NOT NULL,
 CONSTRAINT [PK_DialogActiveUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DialogMessages]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DialogMessages](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DialogInfoId] [bigint] NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[FromUserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_DialogMessages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DialogsInfo]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DialogsInfo](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[User1Id] [uniqueidentifier] NOT NULL,
	[User2Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DialogsInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DisLikes]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DisLikes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CommentId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DisLikes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DpdCities]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DpdCities](
	[cityId] [bigint] NOT NULL,
	[cityIdSpecified] [bit] NOT NULL,
	[countryCode] [nvarchar](50) NOT NULL,
	[countryName] [nvarchar](50) NOT NULL,
	[regionCode] [int] NOT NULL,
	[regionCodeSpecified] [bit] NOT NULL,
	[regionName] [nvarchar](100) NOT NULL,
	[cityCode] [nvarchar](50) NOT NULL,
	[cityName] [nvarchar](100) NOT NULL,
	[abbreviation] [nvarchar](50) NOT NULL,
	[indexMin] [nvarchar](50) NULL,
	[indexMax] [nvarchar](50) NULL,
	[Population] [bigint] NULL,
	[Settled] [nchar](20) NULL,
	[lat] [float] NULL,
	[lng] [float] NULL,
 CONSTRAINT [PK_DpdCities_48] PRIMARY KEY CLUSTERED 
(
	[cityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exceptions]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExchangeItemRequests]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExchangeItemRequests](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ExchangeItemId] [bigint] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[WantedExchangeItemId] [bigint] NOT NULL,
 CONSTRAINT [PK_ExchangeItemRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExchangeProducts]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExchangeProducts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[WantedObject] [nvarchar](50) NULL,
	[Header] [nvarchar](50) NULL,
	[SelectedRequestId] [bigint] NULL,
 CONSTRAINT [PK_ExchangeProducts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Favorites]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favorites](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_Favorites] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FavoritesByCookies]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FavoritesByCookies](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserCookiesId] [nvarchar](36) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_FavoritesByCookies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemDislikes]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemDislikes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectType] [int] NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_ItemDislikes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemLikes]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemLikes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectType] [int] NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_ItemLikes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Items]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Likes]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Likes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CommentId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Likes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoginStat]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginStat](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[UserId] [uniqueidentifier] NULL,
	[Ip] [varchar](48) NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LoginStat] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoginStatistics]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewAezakmi]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewAezakmi](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Authorld] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewAezakmi] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[News]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[News_towardsbackwards]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News_towardsbackwards](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_News_towardsbackwards] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsAlexPigalyov]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsAlexPigalyov](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_News_AlexPIgalyov] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsAntares]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsAntares](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[text] [nvarchar](max) NOT NULL,
	[date] [datetime] NOT NULL,
	[authorId] [uniqueidentifier] NOT NULL,
	[createDate] [datetime] NOT NULL,
	[active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsAntares] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsAzizjan]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsAzizjan](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsAzizjan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsBatrebleSs]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsBatrebleSs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsBatrebleSs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsEducation]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsEducation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsEducation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsEducationBlacklake]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsEducationBlacklake](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsEducationBlacklake] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsEoll73]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsEoll73](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsEoll73] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsGGdotNET]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsGGdotNET](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsGGdotNET] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Newsillfyar]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Newsillfyar](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Newsillfyar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsIlya]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsIlya](
	[Id] [int] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsMrshkVV]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsMrshkVV](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsMrshkVV] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsRaspel]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsRaspel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsRaspel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsShCodder]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsShCodder](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsVark]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsVark](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_NewsVark] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsVlad]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsVlad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsVlad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Operations]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phones]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [nvarchar](50) NOT NULL,
	[Pwd] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Blocked] [bit] NOT NULL,
	[LastActive] [datetime] NOT NULL,
	[Balance] [float] NOT NULL,
	[WhenHistoryChecked] [datetime] NOT NULL,
	[BalanceUpdatePerMonth] [float] NOT NULL,
	[BalanceUpdatePerMonthUpdateDate] [datetime] NOT NULL,
	[IdentificateStatus] [int] NOT NULL,
	[Commision] [bit] NOT NULL,
 CONSTRAINT [PK_Phones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rates]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rates](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Rates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recipes]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recipes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Discription] [nvarchar](max) NOT NULL,
	[Created] [datetime] NOT NULL,
	[ImgUrl] [nvarchar](250) NULL,
	[CountLikes] [int] NOT NULL,
	[TimeMinutesToCook] [int] NOT NULL,
	[UserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Recipes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rent]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rent](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[DateStart] [date] NOT NULL,
	[DateEnd] [date] NULL,
	[Created] [datetime] NOT NULL,
	[UserOwnerId] [uniqueidentifier] NOT NULL,
	[RentType] [int] NOT NULL,
	[DayRentPrice] [int] NOT NULL,
	[HourRentPrice] [int] NULL,
	[MinuteRentPrice] [int] NULL,
	[ImgUrls] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Rent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RentedTime]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentedTime](
	[RentId] [uniqueidentifier] NOT NULL,
	[TimeStart] [datetime] NOT NULL,
	[TimeEnd] [datetime] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 04.02.2021 19:05:47 ******/
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
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenderRequest]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenderRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[ProviderId] [uniqueidentifier] NOT NULL,
	[ProviderName] [nvarchar](50) NOT NULL,
	[Cost] [int] NOT NULL,
	[CustomerId] [uniqueidentifier] NOT NULL,
	[DateStart] [datetime] NULL,
	[DateCompleted] [datetime] NULL,
	[DateDelivered] [datetime] NULL,
	[DateWin] [datetime] NULL,
	[TenderId] [int] NOT NULL,
 CONSTRAINT [PK_TenderRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tenders]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tenders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [ntext] NULL,
	[UserOwnerId] [uniqueidentifier] NOT NULL,
	[Cost] [float] NOT NULL,
	[ImgUrls] [nvarchar](max) NULL,
	[Status] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_Tenders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TokensBuying]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TokensBuying](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Count] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CostOneToken] [float] NOT NULL,
	[FullCost] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TokensBuying] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TokensCost]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TokensCost](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [float] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_TokenCost] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TokensSelling]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TokensSelling](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Count] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CostOneToken] [float] NOT NULL,
	[FullCost] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TokensSelling] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSettings]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_UserSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersOpenAuthAccounts]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersOpenAuthData]    Script Date: 04.02.2021 19:05:47 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersSearches]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersSearches](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Search] [nvarchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[OnlyInName] [bit] NULL,
	[StartPrice] [numeric](18, 0) NULL,
	[EndPrice] [numeric](18, 0) NULL,
	[City] [nvarchar](50) NULL,
	[SortBy] [nvarchar](50) NULL,
	[Date] [datetime] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UsersSearches] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserViews]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserViews](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectId] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_UserViews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ViewedObjects]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ViewedObjects](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[ObjectType] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_ViewedObjects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Watched]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Watched](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_Watched] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WatchedByCookies]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WatchedByCookies](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserCookiesId] [nvarchar](36) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_WatchedByCookies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_Price]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_MessageType]  DEFAULT ((1)) FOR [MessageType]
GO
ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_IsApproved]  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[Articles] ADD  CONSTRAINT [DF_Articles_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[Auctions] ADD  CONSTRAINT [DF_Auctions_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Business] ADD  CONSTRAINT [DF_Business_NoCost]  DEFAULT ((0)) FOR [NoCost]
GO
ALTER TABLE [dbo].[CashIns] ADD  CONSTRAINT [DF_CashIns_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[CashIns] ADD  CONSTRAINT [DF_CashIns_AcceptedAccount]  DEFAULT ((0)) FOR [AcceptedAccount]
GO
ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_Status]  DEFAULT ((1)) FOR [State]
GO
ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_Type]  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_Result]  DEFAULT ((1)) FOR [Result]
GO
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [DF_Categories_OrderId]  DEFAULT ((1)) FOR [OrderId]
GO
ALTER TABLE [dbo].[ChatInviteTokens] ADD  CONSTRAINT [DF_ChatInviteTokens_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_Likes]  DEFAULT ((0)) FOR [Likes]
GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_DisLikes]  DEFAULT ((0)) FOR [DisLikes]
GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_Type]  DEFAULT ((1)) FOR [Type]
GO
ALTER TABLE [dbo].[Currencies] ADD  CONSTRAINT [DF_Cryptocurrencies2_DateAdd]  DEFAULT (getdate()) FOR [DateAdd]
GO
ALTER TABLE [dbo].[Currencies] ADD  CONSTRAINT [DF_Cryptocurrencies2_IsValid]  DEFAULT ((1)) FOR [IsValid]
GO
ALTER TABLE [dbo].[DailyStatistics] ADD  CONSTRAINT [DF_DailyStatistics_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[DialogMessages] ADD  CONSTRAINT [DF_DialogMessages_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[DpdCities] ADD  CONSTRAINT [DF_DpdCities_indexMin_48]  DEFAULT (NULL) FOR [indexMin]
GO
ALTER TABLE [dbo].[DpdCities] ADD  CONSTRAINT [DF_DpdCities_indexMax_48]  DEFAULT (NULL) FOR [indexMax]
GO
ALTER TABLE [dbo].[Exceptions] ADD  CONSTRAINT [DF_Exceptions_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[Favorites] ADD  CONSTRAINT [DF_Favorites_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[FavoritesByCookies] ADD  CONSTRAINT [DF_FavoritesByCookies_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Items] ADD  CONSTRAINT [DF_Items_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[Items] ADD  CONSTRAINT [DF_Items_CommunicationType]  DEFAULT ((1)) FOR [CommunicationType]
GO
ALTER TABLE [dbo].[Likes] ADD  CONSTRAINT [DF_Likes_CommentId]  DEFAULT ((0)) FOR [CommentId]
GO
ALTER TABLE [dbo].[LoginStat] ADD  CONSTRAINT [DF_LoginStat_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[LoginStatistics] ADD  CONSTRAINT [DF_LoginStatistics_WhenLastDate]  DEFAULT (getdate()) FOR [WhenLastDate]
GO
ALTER TABLE [dbo].[LoginStatistics] ADD  CONSTRAINT [DF_LoginStatistics_Client]  DEFAULT ((0)) FOR [Client]
GO
ALTER TABLE [dbo].[LoginStatistics] ADD  DEFAULT ('') FOR [Version]
GO
ALTER TABLE [dbo].[NewAezakmi] ADD  CONSTRAINT [DF_NewAezakmi_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewAezakmi] ADD  CONSTRAINT [DF_NewAezakmi_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewAezakmi] ADD  CONSTRAINT [DF_NewAezakmi_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_New_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_New_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[News_towardsbackwards] ADD  CONSTRAINT [DF_News_towardsbackwards_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[News_towardsbackwards] ADD  CONSTRAINT [DF_News_towardsbackwards_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[News_towardsbackwards] ADD  CONSTRAINT [DF_News_towardsbackwards_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsAlexPigalyov] ADD  CONSTRAINT [DF_News_AlexPIgalyov_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsAlexPigalyov] ADD  CONSTRAINT [DF_News_AlexPIgalyov_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsAntares] ADD  CONSTRAINT [DF_NewsAntares_date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[NewsAntares] ADD  CONSTRAINT [DF_NewsAntares_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[NewsAntares] ADD  CONSTRAINT [DF_NewsAntares_active]  DEFAULT ((1)) FOR [active]
GO
ALTER TABLE [dbo].[NewsAzizjan] ADD  CONSTRAINT [DF_NewsAzizjan_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsAzizjan] ADD  CONSTRAINT [DF_NewsAzizjan_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsAzizjan] ADD  CONSTRAINT [DF_NewsAzizjan_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsBatrebleSs] ADD  CONSTRAINT [DF_NewsBatrebleSs_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsBatrebleSs] ADD  CONSTRAINT [DF_NewsBatrebleSs_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsBatrebleSs] ADD  CONSTRAINT [DF_NewsBatrebleSs_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsEducation] ADD  CONSTRAINT [DF_NewsEducation_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsEducation] ADD  CONSTRAINT [DF_NewsEducation_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsEducation] ADD  CONSTRAINT [DF_NewsEducation_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsEducationBlacklake] ADD  CONSTRAINT [DF_NewsEducationBlacklake_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsEducationBlacklake] ADD  CONSTRAINT [DF_NewsEducationBlacklake_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsEducationBlacklake] ADD  CONSTRAINT [DF_NewsEducationBlacklake_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsEoll73] ADD  CONSTRAINT [DF_NewsEoll73_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsEoll73] ADD  CONSTRAINT [DF_NewsEoll73_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsEoll73] ADD  CONSTRAINT [DF_NewsEoll73_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsGGdotNET] ADD  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsGGdotNET] ADD  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Newsillfyar] ADD  CONSTRAINT [DF_Newsillfyar_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Newsillfyar] ADD  CONSTRAINT [DF_Newsillfyar_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Newsillfyar] ADD  CONSTRAINT [DF_Newsillfyar_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsIlya] ADD  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsIlya] ADD  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsMrshkVV] ADD  CONSTRAINT [DF_NewsMrshkVV_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsMrshkVV] ADD  CONSTRAINT [DF_NewsMrshkVV_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsRaspel] ADD  CONSTRAINT [DF_NewsRaspel_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsRaspel] ADD  CONSTRAINT [DF_NewsRaspel_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsRaspel] ADD  CONSTRAINT [DF_NewsRaspel_Activ]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsShCodder] ADD  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsShCodder] ADD  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsShCodder] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[NewsVark] ADD  CONSTRAINT [DF_NewVark_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsVark] ADD  CONSTRAINT [DF_NewVark_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsVlad] ADD  CONSTRAINT [DF_NewsVlad_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsVlad] ADD  CONSTRAINT [DF_NewsVlad_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsVlad] ADD  CONSTRAINT [DF_NewsVlad_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Operations] ADD  CONSTRAINT [DF_Operations_Value]  DEFAULT ((0)) FOR [Value]
GO
ALTER TABLE [dbo].[Operations] ADD  CONSTRAINT [DF_Operations_Type]  DEFAULT ((1)) FOR [Type]
GO
ALTER TABLE [dbo].[Operations] ADD  CONSTRAINT [DF_Operations_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_Blocked]  DEFAULT ((0)) FOR [Blocked]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_LastActive]  DEFAULT (getdate()) FOR [LastActive]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_Balance]  DEFAULT ((0)) FOR [Balance]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_WhenHistoryChecked]  DEFAULT (getdate()) FOR [WhenHistoryChecked]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_BalanceUpdatePerMonth]  DEFAULT ((0)) FOR [BalanceUpdatePerMonth]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_BalanceUpdatePerMonthUpdateDate]  DEFAULT (getdate()) FOR [BalanceUpdatePerMonthUpdateDate]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_IdentificateStatus]  DEFAULT ((1)) FOR [IdentificateStatus]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_Commision]  DEFAULT ((0)) FOR [Commision]
GO
ALTER TABLE [dbo].[Rates] ADD  CONSTRAINT [DF_Rates_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF_Recipes_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF_Recipes_CountLikes]  DEFAULT ((0)) FOR [CountLikes]
GO
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF_Recipes_TimeMinutesToCook]  DEFAULT ((0)) FOR [TimeMinutesToCook]
GO
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF_Recipes_UserId]  DEFAULT ((1)) FOR [UserId]
GO
ALTER TABLE [dbo].[Referrals] ADD  CONSTRAINT [DF_Refferals_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[Settings] ADD  CONSTRAINT [DF_Settings_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[TenderRequest] ADD  CONSTRAINT [DF_TenderRequest_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[TenderRequest] ADD  CONSTRAINT [DF_TenderRequest_DateStart]  DEFAULT (getdate()) FOR [DateStart]
GO
ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_CurrencyId]  DEFAULT ((1)) FOR [CurrencyId]
GO
ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_CategoryId]  DEFAULT ((0)) FOR [CategoryId]
GO
ALTER TABLE [dbo].[TokensBuying] ADD  CONSTRAINT [DF_TokensBuying_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[TokensCost] ADD  CONSTRAINT [DF_TokenCost_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[TokensSelling] ADD  CONSTRAINT [DF_TokensSelling_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_PublicId]  DEFAULT ((0)) FOR [PublicId]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_ReffAdd]  DEFAULT ((0)) FOR [ReffAdd]
GO
ALTER TABLE [dbo].[UserSettings] ADD  CONSTRAINT [DF_UserSettings_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Wallets] ADD  CONSTRAINT [DF_Wallets_Value]  DEFAULT ((0)) FOR [Value]
GO
ALTER TABLE [dbo].[Wallets] ADD  CONSTRAINT [DF_Wallets_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Watched] ADD  CONSTRAINT [DF_Watched_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[WatchedByCookies] ADD  CONSTRAINT [DF_WatchedByCookies_Created]  DEFAULT (getdate()) FOR [Created]
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
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_NewsVark_Users] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_NewsVark_Users]
GO
ALTER TABLE [dbo].[NewsVark]  WITH CHECK ADD  CONSTRAINT [FK_NewsVark_Users1] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[NewsVark] CHECK CONSTRAINT [FK_NewsVark_Users1]
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
ALTER TABLE [dbo].[UserSettings]  WITH CHECK ADD  CONSTRAINT [FK_UserSettings_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserSettings] CHECK CONSTRAINT [FK_UserSettings_Users]
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
ALTER TABLE [dbo].[Watched]  WITH CHECK ADD  CONSTRAINT [FK_Watched_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Watched] CHECK CONSTRAINT [FK_Watched_Users]
GO
/****** Object:  StoredProcedure [dbo].[spAddAdvert]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spAddAdvert]
@Category int, 
@Name nvarchar(50),
@Description nvarchar(4000),
@CreatedUserId uniqueidentifier,
@Price float,
@Address nvarchar(150),
@Phone nvarchar(50),
@MessageType int,
@Position geography,
@ImgUrls nvarchar(max),
@YouTubeUrl nvarchar(max)
AS
BEGIN
    INSERT INTO Adverts ([Category]
					   ,[Name]
					   ,[Description]
					   ,[CreatedUserId]
					   ,[Price]
					   ,[Address]
					   ,[Phone]
					   ,[MessageType]
					   ,[Position]
					   ,[ImgUrls]
					   ,[YouTubeUrl]
					   )
    VALUES (@Category, 
	@Name,
	@Description,
	@CreatedUserId,
	@Price,
	@Address,
	@Phone,
	@MessageType,
	@Position,
	@ImgUrls,
	@YouTubeUrl)
END

GO
/****** Object:  StoredProcedure [dbo].[spAddFavorites]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  StoredProcedure [dbo].[spAddFavoritesByCookies]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  StoredProcedure [dbo].[spAddWatched]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spAddWatched]
@UserId uniqueidentifier, @advertId bigint
AS
BEGIN
    INSERT INTO Watched (UserId, AdvertId)
    VALUES (@UserId, @advertId)
END

GO
/****** Object:  StoredProcedure [dbo].[spAddWatchedByCookies]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spAddWatchedByCookies]
@uid nvarchar(36), @advertId bigint
AS
BEGIN
    INSERT INTO WatchedByCookies (UserCookiesId, AdvertId)
    VALUES (@uid, @advertId)
END

GO
/****** Object:  StoredProcedure [dbo].[spDPDCitiesTop10]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDPDCitiesTop10]
@text nvarchar(50)
AS
BEGIN
SELECT TOP (10) [cityId]
,[cityIdSpecified]
,[countryCode]
,[countryName]
,[regionCode]
,[regionCodeSpecified]
,[regionName]
,[cityCode]
,[cityName]
,[abbreviation]
,[indexMin]
,[indexMax]
,[Population]
,[Settled]
,[lat]
,[lng]
FROM [DpdCities]
Where 
[cityName] like '%'+@text+'%'
Order by Population desc
END
GO
/****** Object:  StoredProcedure [dbo].[spGetChats]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetChats]
(@userId uniqueidentifier)
AS
BEGIN


SELECT chats.Id
	, (CASE WHEN chats.ChatType = 1 THEN ( 
	
	SELECT users.UserName FROM [dbo].ChatUsers AS chatUsers 
	LEFT JOIN [dbo].Users AS users 
	ON (users.UserId = chatUsers.UserId) 
	WHERE chatUsers.UserId != @userId AND chatUsers.ChatId = chats.Id
	
	) ELSE chats.ChatName END ) AS ChatName


FROM [dbo].[Chats] AS chats
LEFT JOIN [dbo].ChatUsers AS chatUsers ON (chatUsers.ChatId = chats.Id) WHERE chatUsers.UserId = @userId

END


GO
/****** Object:  StoredProcedure [dbo].[spGetChatsForUser]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetChatsForUser]
(@userId uniqueidentifier)
AS
BEGIN


SELECT chats.Id
	, (CASE WHEN chats.ChatType = 1 THEN ( 
	
	SELECT users.UserName FROM [dbo].ChatUsers AS chatUsers 
	LEFT JOIN [dbo].Users AS users 
	ON (users.UserId = chatUsers.UserId) 
	WHERE chatUsers.UserId != @userId AND chatUsers.ChatId = chats.Id
	
	) ELSE chats.ChatName END ) AS ChatName


FROM [dbo].[Chats] AS chats
LEFT JOIN [dbo].ChatUsers AS chatUsers ON (chatUsers.ChatId = chats.Id) WHERE chatUsers.UserId = @userId

END


GO
/****** Object:  StoredProcedure [dbo].[spGetComments]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetComments]
@objectId bigint, @userId uniqueidentifier
AS
BEGIN
	SELECT [Id]
      ,[UserId]
      ,[AdvertId]
      ,[Comment]
      ,[Date]
      ,[Likes]
      ,[DisLikes]
      ,[Type]
  FROM [Comments]
	where [UserId] = @userId
	ORDER BY [Date] ASC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetCommentsForUser]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetCommentsForUser]
(@userId uniqueidentifier, @advertId int)
AS
BEGIN


	SELECT cmnts.[Id]
      ,[cmnts].[UserId]
      ,cmnts.[AdvertId]
      ,cmnts.[Comment]
      ,cmnts.[Date]
	  ,[usrs].[UserName]
	  ,(SELECT COUNT(*) FROM [dbo].[Likes] AS lks WHERE lks.CommentId = cmnts.Id) AS LikesCount
	  ,(SELECT COUNT(*) FROM [dbo].[DisLikes] AS dlks WHERE dlks.CommentId = cmnts.Id) AS DisLikesCount

	  ,CONVERT(BIT, (CASE when  EXISTS (SELECT * FROM [dbo].[DisLikes] 
	  WHERE CommentId = Id AND UserId = @userId) then 1 ELSE 0 END) ) AS HaveDisLiked

	  ,CONVERT(BIT, (CASE when  EXISTS (SELECT * FROM [dbo].[Likes] 
	  WHERE CommentId = Id AND UserId = @userId) then 1 ELSE 0 END) ) AS HaveLiked

      ,cmnts.[Type]
  FROM [Comments] AS cmnts
  JOIN [Users] AS usrs 
  ON(cmnts.UserId = usrs.UserId)
	WHERE [AdvertId] = @advertId
	ORDER BY [Date] ASC
END

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetCommentsForUser] TO PUBLIC
    AS [dbo];

GO
/****** Object:  StoredProcedure [dbo].[spGetComplaintsByRecipier]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetComplaintsByRecipier]
(@userId uniqueidentifier)
AS
BEGIN


SELECT cpts.[Id]
      ,[Message]
      ,[ComplaintType]
      ,[ObjectId]
      ,[ObjectType]
      ,[UserSender]
      ,[UserRecipier]
      ,[Data]
	  ,usrs.UserName AS UserRecipierName
	  , (SELECT FIRST_VALUE(UserName) OVER(ORDER BY Id) FROM [dbo].[Users] WHERE UserId = UserSender) AS UserSenderName
  FROM [dbo].[Complaints] as cpts 
  LEFT JOIN [dbo].[Users] as usrs ON( cpts.UserRecipier = usrs.UserId) WHERE cpts.UserRecipier = @userId 

END


GO
/****** Object:  StoredProcedure [dbo].[spGetComplaintsBySender]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetComplaintsBySender]
(@userId uniqueidentifier)
AS
BEGIN


SELECT cpts.[Id]
      ,[Message]
      ,[ComplaintType]
      ,[ObjectId]
      ,[ObjectType]
      ,[UserSender]
      ,[UserRecipier]
      ,[Data]
	  ,usrs.UserName AS UserSenderName
	  , (SELECT FIRST_VALUE(UserName) OVER(ORDER BY Id) FROM [dbo].[Users] WHERE UserId = UserRecipier) AS UserRecipierName
  FROM [dbo].[Complaints] as cpts 
  LEFT JOIN [dbo].[Users] as usrs ON( cpts.UserSender = usrs.UserId) WHERE cpts.UserSender = @userId 

END


GO
/****** Object:  StoredProcedure [dbo].[spGetExchangeItemRequests]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetExchangeItemRequests]
(@exchangeItemId bigint)
AS
BEGIN


SELECT exr.id
	, adv.Name
	, adv.Color
	, adv.Id as advertId


	FROM dbo.ExchangeItemRequests as exr 
	LEFT JOIN dbo.Adverts as adv ON ( exr.ExchangeItemId = adv.Id)
	WHERE exr.WantedExchangeItemId = @exchangeItemId
	

END


GO
/****** Object:  StoredProcedure [dbo].[spGetExchangeProducts]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetExchangeProducts]
(@query nvarchar(30))
AS
BEGIN

	SELECT 
		expr.[Id]
      ,[AdvertId]
      ,[Comment]
      ,[WantedObject]
      ,[Header]
	  ,[Category]
      ,[Name]
      ,[Created]
      ,[Price]
      ,[Address]
      ,[IsApproved]
      ,[Subcategory]
      ,[Color]
      ,[Vin]
      ,[Brand]


	FROM dbo.ExchangeProducts as expr
	LEFT JOIN dbo.Adverts as adv
	ON expr.AdvertId = adv.Id 
	WHERE (adv.Name LIKE @query) OR (adv.Description LIKE @query) 
	OR (expr.Header LIKE @query) OR (expr.Comment LIKE @query) OR (expr.WantedObject LIKE @query)

END


GO
/****** Object:  StoredProcedure [dbo].[spGetFavorites]    Script Date: 04.02.2021 19:05:47 ******/
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
	  ,a.[ImgUrls]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[Favorites] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[UserId] = @userId
	ORDER BY CreatedFavorites DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetFavoritesByCookies]    Script Date: 04.02.2021 19:05:47 ******/
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
	  ,a.[ImgUrls]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[FavoritesByCookies] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[UserCookiesId] = @uid
	ORDER BY CreatedFavorites DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetLast200TokensOperations]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetLast200TokensOperations]
AS
BEGIN
	SELECT TOP 200 a.* FROM
    (
    SELECT TOP (1000) 
    [Count]
          ,[UserId]
          ,[CostOneToken]
          ,[FullCost]
          ,[WhenDate]
		  ,1 as [OperationEvent]
      FROM [TokensBuying]
      Union
      SELECT TOP (1000) 
      [Count]
          ,[UserId]
          ,[CostOneToken]
          ,[FullCost]
          ,[WhenDate]
		  ,0 as [OperationEvent]
      FROM [TokensSelling]
      Order by [WhenDate]
      ) AS a
    ORDER BY [WhenDate] desc
END

GO
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastDayActive]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastHourActive]    Script Date: 04.02.2021 19:05:47 ******/
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
/****** Object:  StoredProcedure [dbo].[spGetTokenCostToday]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetTokenCostToday]
AS
BEGIN
	SELECT [Id]
      ,[Value]
      ,[Date]
  FROM [Rentoolo].[dbo].[TokensCost]
  WHERE CONVERT(date, [Date]) = CONVERT(date, getdate())
END

GO
/****** Object:  StoredProcedure [dbo].[spGetUserAdverts]    Script Date: 04.02.2021 19:05:47 ******/
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
	  ,a.[ImgUrls]
	FROM [Adverts] a
	WHERE a.[CreatedUserId] = @UserId
	ORDER BY a.[Created] DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetWatched]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetWatched]
@userId uniqueidentifier
AS
BEGIN
	SELECT w.[Id]
      ,w.[AdvertId]
      ,w.[Created] CreatedFavorites
	  ,a.[Category]
	  ,a.[Name]
      ,a.[Description]
      ,a.[Created] CreatedAdverts
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
	  ,a.[ImgUrls]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[Watched] w
	LEFT JOIN [Adverts] a
	on w.[AdvertId] = a.[Id]
	where w.[UserId] = @userId
	ORDER BY CreatedFavorites DESC
END

GO
/****** Object:  StoredProcedure [dbo].[spGetWatchedByCookies]    Script Date: 04.02.2021 19:05:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetWatchedByCookies]
@uid nvarchar(50)
AS
BEGIN
	SELECT w.[Id]
      ,w.[AdvertId]
      ,w.[Created] CreatedFavorites
	  ,a.[Category]
	  ,a.[Name]
      ,a.[Description]
      ,a.[Created] CreatedAdverts
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
	  ,a.[ImgUrls]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[WatchedByCookies] w
	LEFT JOIN [Adverts] a
	on w.[AdvertId] = a.[Id]
	where w.[UserCookiesId] = @uid
	ORDER BY CreatedFavorites DESC
END

GO
