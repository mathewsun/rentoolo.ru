USE [Rentoolo]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalance]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserBalanceByName]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Memberships]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetAllUsers]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Referrals]    Script Date: 2/27/2021 8:43:55 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsSecondLevel]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserReferralsThirdLevel]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Wallets]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Currencies]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetUserWallets]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetTablesRows]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Adverts]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Applications]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Articles]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[AuctionRequests]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Auctions]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Business]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[CashIns]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[CashOuts]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Categories]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ChatActiveUsers]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Chats]    Script Date: 2/27/2021 8:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chats](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[ChatName] [nvarchar](50) NULL,
	[ChatType] [smallint] NOT NULL,
 CONSTRAINT [PK_Chats] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatUsers]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Comments]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Complaints]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[CraftsMan]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[CraftsManOrder]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[DailyStatistics]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[DeletedAdverts]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[DialogActiveUsers]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[DialogMessages]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[DialogsInfo]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[DisLikes]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Exceptions]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ExchangeItemRequests]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ExchangeProducts]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Favorites]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[FavoritesByCookies]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ItemDislikes]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ItemLikes]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Items]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Likes]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[LoginStat]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[LoginStatistics]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewAezakmi]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[News]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[News_towardsbackwards]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsAlexPigalyov]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsAntares]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsAzizjan]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsBatrebleSs]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsEducation]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsEoll73]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsGGdotNET]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsGodnebeles]    Script Date: 2/27/2021 8:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsGodnebeles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_NewsGodnebeles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Newsillfyar]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsIlya]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsMrshkVV]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsRaspel]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsShCodder]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsVark]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[NewsVlad]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Operations]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Payments]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Phones]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Rates]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Recipes]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Rent]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[RentedTime]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Settings]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[TenderRequest]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Tenders]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[TokensBuying]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[TokensCost]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[TokensSelling]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[UserSettings]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[UsersOpenAuthAccounts]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[UsersOpenAuthData]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[UsersSearches]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[UserViews]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[ViewedObjects]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[Watched]    Script Date: 2/27/2021 8:43:55 AM ******/
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
/****** Object:  Table [dbo].[WatchedByCookies]    Script Date: 2/27/2021 8:43:55 AM ******/
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
SET IDENTITY_INSERT [dbo].[Adverts] ON 
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (27, 50, N'Холодильник Bosh', N'Новенький! Не пользовались.', CAST(N'2019-10-03T00:37:17.040' AS DateTime), N'f95dea8f-3fae-4c54-be1d-572e5dfe9116', 9900, N'Новый Арбат 78', N'+79864552545', 0, NULL, N'["/img/a/j7rMiCXWekmVM6TaCXnspg.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (28, 50, N'телевизор Samsung 55''', N'в хорошем состоянии', CAST(N'2019-10-11T20:33:25.107' AS DateTime), N'314bd290-5fc5-4a93-8131-db644b83aaed', 29000, N'Москва, Арбат 10', N'+7942557872', 0, NULL, N'["/img/a/zvUwKw2GuESIKa8MalcwHw.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (29, 50, N'горные лыжи Atomic Smoke Titanium', N'Откатал 3 сезона. В хорошем состоянии.
В комплекте крепления, палки, чехол.', CAST(N'2019-10-11T20:50:50.260' AS DateTime), N'314bd290-5fc5-4a93-8131-db644b83aaed', 8450, N'Москва, Динамо', N'+7942557878', 0, NULL, N'["/img/a/sMFAAAITL06GeAXpGNqumA.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (30, 50, N'Кофеварка ', N'Тестовое объявление с большим количеством картинок', CAST(N'2019-10-11T20:54:25.323' AS DateTime), N'314bd290-5fc5-4a93-8131-db644b83aaed', 3200, N'Москва, Кузьминки 20', N'+7942257872', 0, NULL, N'["/img/a/SIHdBzJ2xkeewPafXldijw.jpg","/img/a/br10SfqbBUSvK8jFPm1r3Q.jpg","/img/a/GcLH1ion40GwK8eK88m0Q.jpg","/img/a/mxsrgrPttUqWOQp0wBbQ.jpg","/img/a/wCkZwxQHxUa4W0CpWexR2g.jpg","/img/a/8bkqHlYySEmqCRWPeubGQ.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (31, 1010, N'хендай солярис', N'Практически новый', CAST(N'2019-10-26T13:54:46.850' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 300000, N'Новогиреево', N'+79864522542', 0, NULL, N'["/img/a/oWD62LoCh0Ki7lDEi64c8w.jpg","/img/a/qbt8Vq3gKU2tEnWH1l6LuA.jpg","/img/a/DU0vHVSLf0OOY5bwFefEMA.jpg","/img/a/UOsvIyfOc0ahpcP2o6VMEg.jpg","/img/a/VClzoRSFUOz9BjWDV7BDA.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (32, 1101, N'Магазин разливного пива', N'Оборотка 600.000 рублей.
Чистая прибыль 200.000 рублей.', CAST(N'2019-10-26T14:29:49.840' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1200000, N'Воронеж', N'+79864889931', 0, NULL, N'["/img/a/FnmKKH4Ak2oMXMcgnLKHw.jpg","/img/a/nFulAD509kO262lg8wHqkQ.jpg","/img/a/N22eeOEoEaZCPPkw39Zkw.jpg","/img/a/DhaLb5TLUSEvgfAxgH77Q.jpg","/img/a/1Yg7WTepOUe4guNHxqZgSw.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10027, 50, N'7777', N'77777', CAST(N'2020-05-01T00:33:16.583' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 7777, N'Кочновский пр-д, 5 строение 7, Москва, Россия, 125319', N'+79864889122', 0, NULL, N'["/img/a/noPhoto.png"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10028, 50, N'7777', N'777', CAST(N'2020-05-01T00:33:30.630' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 7777, N'Кочновский пр-д, 5 строение 7, Москва, Россия, 125319', N'+79864522542', 0, NULL, N'["/img/a/noPhoto.png"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10029, 50, N'2222 тест', N'3332', CAST(N'2020-05-01T00:43:06.323' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4444, N'Кочновский пр-д, 5 строение 7, Москва, Россия, 125319', N'+79864522542', 0, NULL, N'["/img/a/noPhoto.png"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10031, 1010, N'Ваз 2106', N'Любимая шестерочкв', CAST(N'2020-05-07T16:52:38.577' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 40000, N'ул. Старый Гай, 12, Москва, Россия, 111402', N'+79686399088', 0, NULL, N'["/img/a/V6bJ415pk00SmjqznXbZA.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10032, 50, N'Тест 4', N'Тестттт 4444', CAST(N'2020-05-30T17:45:32.733' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, N'ул. Вучетича, 28 корпус 3, Москва, Россия, 127206', N'+79864554545', 0, NULL, N'["/img/a/wcB4wOYDX0aj7Ef3GU4SQ.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10033, 50, N'Тест 5', N'Тесттт;тттттттт 5', CAST(N'2020-05-30T17:46:36.037' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 200000, N'ул. Вучетича, 28 корпус 3, Москва, Россия, 127206', N'+79864554545', 0, NULL, N'["/img/a/noPhoto.png"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10034, 1000, N'Готовый бизнес проект ', N'Как создавать красоту и деньги благодаря гальванике. Реализовать свой творческий потенциал и быть счастливым.
В общем как превратить листья с деревьев в деньги?
https://upravlenec.e-autopay.com/p/5500/ps
П.С.
Целевая аудитория реализации продукта весь мир, уровень продаж зависит от вашего вклада. Помимо обучения гальванике, попутно расскажут как продавать в интернете.
', CAST(N'2020-06-26T23:48:36.957' AS DateTime), N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 14970, N'Севастополь', N'79821395919', 0, NULL, N'["/img/a/g1TMt82J0WUJ8QHj8MhA.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (10035, 10, N'Skoda Oktavia', N'В хорошем состоянии.', CAST(N'2020-07-16T01:21:48.863' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100000, N'Тимирязевская ул., 38А строение 1, Москва, Россия, 127422', N'+79864889142', 0, NULL, N'["/img/a/e1pheumNfUSooc5OhG7K8w.png","/img/a/KzFZndm8GkCewRbzpDzTzQ.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (20035, 70, N'Микроволновка Samsung', N'Купили 5 лет назад. Отлично работает.
Пользовались бережно.', CAST(N'2020-07-26T19:19:31.460' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, N'Ивановская ул., 34, Москва', N'+79864522542', 0, NULL, N'["/img/a/5pCX225yECrJK1EdRDIKw.jpg","/img/a/GSI4kgcK8UmITf7eW8ClSw.jpg","/img/a/9FtOlXC3KUWJ6D938o8Kmw.jpg","/img/a/1ubiLdqmUKpYsar4SsM1A.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (20041, 50, N'Шкаф-купе', N'3 секции.
Купили несколько лет назад.
В хорошем состоянии.', CAST(N'2020-08-16T14:17:19.717' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, N'Черняховского ул., 19 строение 15, Москва, Россия, 125319', N'+79864522542', 0, NULL, N'["/img/a/PkfH63NfykK5IDAhQC97g.jpg","/img/a/KBl6y2RkKptV35fV8rg.jpg"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Adverts] ([Id], [Category], [Name], [Description], [Created], [CreatedUserId], [Price], [Address], [Phone], [MessageType], [Position], [ImgUrls], [YouTubeUrl], [IsApproved], [WhenAdminApproved], [Subcategory], [Color], [Vin], [Brand]) VALUES (20042, 50, N'Куртка', N'Новая куртка', CAST(N'2020-11-28T01:22:54.990' AS DateTime), N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', 5000, N'Ulitsa Engel''sa, 49, Gorodets, Nizhegorodskaya oblast'', Russia, 606505', N'+79999999999', 0, NULL, N'["/img/a/noPhoto.png"]', N'', 0, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Adverts] OFF
GO
INSERT [dbo].[Applications] ([ApplicationName], [ApplicationId], [Description]) VALUES (N'/', N'234ee901-21d6-4952-b871-b815b148fe46', NULL)
GO
SET IDENTITY_INSERT [dbo].[Auctions] ON 
GO
INSERT [dbo].[Auctions] ([Id], [Name], [StartPrice], [Created], [UserId], [ImgUrls], [Description], [DataEnd]) VALUES (1, N'Первый аукцион', 1000.0000, CAST(N'2020-11-28T01:02:29.647' AS DateTime), N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', NULL, N'Описание', NULL)
GO
SET IDENTITY_INSERT [dbo].[Auctions] OFF
GO
SET IDENTITY_INSERT [dbo].[CashIns] ON 
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (1, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', 2, N'Qiwi', CAST(N'2019-12-29T00:34:32.000' AS DateTime), N'79686399088', N'+79779393722')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (2, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4, N'Qiwi', CAST(N'2019-12-29T00:52:13.000' AS DateTime), N'79686399088', N'+79779393722')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (9, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 200, N'Qiwi', CAST(N'2020-01-12T01:54:19.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (10, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 100, N'Qiwi', CAST(N'2020-01-14T00:44:17.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (11, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 300, N'Qiwi', CAST(N'2020-01-20T16:14:15.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (12, N'd605cfec-b531-4b21-a58c-074b035402af', 100, N'Qiwi', CAST(N'2020-01-22T11:03:38.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (13, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 100, N'Qiwi', CAST(N'2020-01-24T17:13:57.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (14, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 200, N'Qiwi', CAST(N'2020-01-25T12:32:45.000' AS DateTime), N'79686399088', N'+79508631455')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (15, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 200, N'Qiwi', CAST(N'2020-01-25T12:40:08.000' AS DateTime), N'79686399088', N'+79508631455')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (16, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 2000, N'Qiwi', CAST(N'2020-01-26T18:14:11.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (17, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 2510, N'Qiwi', CAST(N'2020-03-18T23:02:35.000' AS DateTime), N'79686399088', N'+79821395919')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (18, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, N'Qiwi', CAST(N'2020-05-08T17:06:31.000' AS DateTime), N'79686399088', N'')
GO
INSERT [dbo].[CashIns] ([Id], [UserId], [Value], [Sposob], [WhenDate], [AcceptedAccount], [SendAccount]) VALUES (19, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 10, N'Qiwi', CAST(N'2020-06-28T18:49:48.000' AS DateTime), N'79686399088', N'+79508631455')
GO
SET IDENTITY_INSERT [dbo].[CashIns] OFF
GO
SET IDENTITY_INSERT [dbo].[CashOuts] ON 
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 200, CAST(N'2020-01-07T23:06:09.420' AS DateTime), N'+79686399088', CAST(N'2020-07-26T18:52:36.700' AS DateTime), 3, N'+79686399088', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (2, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, CAST(N'2020-01-07T23:09:25.890' AS DateTime), N'+79686399088', CAST(N'2020-07-26T18:52:31.990' AS DateTime), 2, N'+79686399088', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (3, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2, CAST(N'2020-01-07T23:12:19.240' AS DateTime), N'+79686399088', CAST(N'2020-07-26T18:52:26.517' AS DateTime), 3, N'+79686399088', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (4, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1, CAST(N'2020-01-08T00:06:41.287' AS DateTime), N'+79779393722', CAST(N'2020-01-08T00:06:45.447' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (5, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2, CAST(N'2020-01-14T03:06:35.900' AS DateTime), N'+79779393722', CAST(N'2020-01-14T03:06:38.583' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (6, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 200, CAST(N'2020-01-25T12:37:56.027' AS DateTime), N'+79508631455', CAST(N'2020-01-25T12:38:00.097' AS DateTime), 2, N'+79508631455', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (7, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 100, CAST(N'2020-01-25T12:42:58.073' AS DateTime), N'+79508631455', CAST(N'2020-01-25T12:43:02.287' AS DateTime), 2, N'+79508631455', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (8, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 49, CAST(N'2020-01-25T12:46:04.243' AS DateTime), N'5321300345885532', CAST(N'2020-07-26T18:48:34.773' AS DateTime), 2, N'5321300345885532', N'', 4, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (9, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2, CAST(N'2020-06-28T05:34:02.940' AS DateTime), N'+79779393722', CAST(N'2020-07-26T18:48:28.280' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (10, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2, CAST(N'2020-06-28T06:07:18.380' AS DateTime), N'+79779393722', CAST(N'2020-07-26T18:48:24.217' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (11, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, CAST(N'2020-06-28T16:09:11.970' AS DateTime), N'+79779393722', CAST(N'2020-07-26T18:48:16.023' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (12, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, CAST(N'2020-06-28T16:12:08.257' AS DateTime), N'+79779393722', CAST(N'2020-07-26T18:48:00.827' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (13, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, CAST(N'2020-06-28T17:53:35.007' AS DateTime), N'+79779393722', CAST(N'2020-06-28T17:53:45.500' AS DateTime), 2, N'+79779393722', N'', 1, NULL, 0)
GO
INSERT [dbo].[CashOuts] ([Id], [UserId], [Value], [WhenDate], [Sposob], [WhenAdminEvent], [State], [Number], [Comment], [Type], [PaymentNumber], [Result]) VALUES (14, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 2718.98, CAST(N'2020-07-10T20:38:51.130' AS DateTime), N'+79821395919', CAST(N'2020-07-26T18:38:44.923' AS DateTime), 2, N'+79821395919', N'', 1, NULL, 0)
GO
SET IDENTITY_INSERT [dbo].[CashOuts] OFF
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (10, N'Transport', N'Транспорт', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (101, N'Auto', N'Автомобили', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (102, N'Moto', N'Мотоциклы и мототехника', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (103, N'Truck', N'Грузовики и спецтехника', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (104, N'WaterTransport', N'Водный транспорт', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (105, N'SpareParts', N'Запчасти и аксессуары', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (20, N'Realty', N'Недвижимость', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (201, N'Apartment', N'Квартиры', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (202, N'Room', N'Комнаты', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (203, N'House', N'Дома, дачи, коттеджи', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (204, N'Land', N'Земельные участки', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (205, N'Garage', N'Гаражи и машиноместа', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (206, N'CommercialRealEstate', N'Коммерческая недвижимость', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (207, N'RealEstateAbroad', N'Недвижимость за рубежом', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (30, N'Job', N'Работа', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (301, N'Vacancy', N'Вакансии', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (302, N'Resume', N'Резюме', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (40, N'Services', N'Услуги', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (401, N'ItInternetTelecom', N'IT, интернет, телеком', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (4011, N'WebsiteDevelopmentMarketing', N'Cоздание и продвижение сайтов', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (40111, N'WebsiteDevelopment', N'Создание сайтов', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (40112, N'WebsiteMarketing', N'Продвижение сайтов', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (4012, N'SoftwareInstallationSetup', N'Установка и настройка ПО', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (4013, N'SettingupInternetNetworks', N'Настройка интернета и сетей', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (4014, N'ItMaster', N'It мастер на все случаи', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (50, N'PersonalGoods', N'Личные вещи', 1, NULL)
GO
INSERT [dbo].[Categories] ([Id], [Name], [Name(Ru)], [OrderId], [ParentCategoryId]) VALUES (501, N'ClothesShoesAccessories', N'Одежда, обувь, аксессуары', 1, NULL)
GO
SET IDENTITY_INSERT [dbo].[ChatActiveUsers] ON 
GO
INSERT [dbo].[ChatActiveUsers] ([Id], [UserId], [ChatId]) VALUES (25, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329', 9)
GO
INSERT [dbo].[ChatActiveUsers] ([Id], [UserId], [ChatId]) VALUES (33, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 9)
GO
INSERT [dbo].[ChatActiveUsers] ([Id], [UserId], [ChatId]) VALUES (34, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 9)
GO
SET IDENTITY_INSERT [dbo].[ChatActiveUsers] OFF
GO
SET IDENTITY_INSERT [dbo].[ChatMessages] ON 
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (2, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'some mnogo texta 2', CAST(N'2020-10-06T23:33:39.087' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (3, N'00000000-0000-0000-0000-000000000000', N'htttx', CAST(N'2020-10-07T18:31:42.527' AS DateTime), 0)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (4, N'00000000-0000-0000-0000-000000000000', N'qtx', CAST(N'2020-10-07T18:36:20.407' AS DateTime), 0)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (5, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'httx', CAST(N'2020-10-07T18:37:39.267' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (6, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'hi alex!', CAST(N'2020-10-07T21:58:06.433' AS DateTime), 5)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (7, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'hmm..', CAST(N'2020-10-07T22:02:12.297' AS DateTime), 5)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (8, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'йй', CAST(N'2020-10-07T22:07:37.470' AS DateTime), 5)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (9, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'ййййй', CAST(N'2020-10-07T22:11:26.073' AS DateTime), 5)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (10, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329', N'among us', CAST(N'2020-10-07T22:16:24.263' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (11, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'!!!!!', CAST(N'2020-10-13T19:51:11.457' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (12, N'a55a7415-80e3-4dfd-91a1-3ea9d8d88329', N'!!!!!!', CAST(N'2020-10-28T22:40:15.700' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (13, N'c55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'aaaaaaaaaa', CAST(N'2020-10-28T22:46:02.547' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (14, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'!!!!!!!!!!!!!!!!', CAST(N'2020-10-28T22:47:16.280' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (15, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'!!!!!!!!!!!!', CAST(N'2020-10-28T22:50:49.170' AS DateTime), 9)
GO
INSERT [dbo].[ChatMessages] ([Id], [UserId], [Message], [Date], [ChatId]) VALUES (16, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'3333', CAST(N'2020-10-28T22:52:25.517' AS DateTime), 9)
GO
SET IDENTITY_INSERT [dbo].[ChatMessages] OFF
GO
SET IDENTITY_INSERT [dbo].[Chats] ON 
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (1, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', NULL, 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (2, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88325', NULL, 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (3, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88324', NULL, 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (4, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', NULL, 1)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (5, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', NULL, 1)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (6, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88323', NULL, 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (7, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'Some chat for tests', 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (8, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'Some chat for tests 2', 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (9, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'Some chat for tests 3', 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (10, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329', N'someFrndt', 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (11, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329', N'someFrndt2', 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (12, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'chat test4', 0)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (13, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'hhh', 1)
GO
INSERT [dbo].[Chats] ([Id], [OwnerId], [ChatName], [ChatType]) VALUES (14, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'mmm', 1)
GO
SET IDENTITY_INSERT [dbo].[Chats] OFF
GO
SET IDENTITY_INSERT [dbo].[ChatUsers] ON 
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (3, 5, N'497b82eb-2f1f-410d-a71c-36b45111b74b')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (4, 5, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (5, 0, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88323')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (6, 0, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (7, 7, N'31c4e8bb-9c5b-45d7-8fa0-65c75f87e121')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (8, 0, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (9, 8, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (10, 0, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (11, 9, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (12, 9, N'31c4e8bb-9c5b-45d7-8fa0-65c75f87e121')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (13, 0, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (14, 10, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (15, 0, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (16, 11, N'a55a7415-80e3-4dfd-92a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (17, 0, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (18, 12, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (19, 13, N'b98b7ebc-4d5e-405b-88d8-087421c50b8e')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (20, 13, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (21, 14, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59')
GO
INSERT [dbo].[ChatUsers] ([Id], [ChatId], [UserId]) VALUES (22, 14, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
SET IDENTITY_INSERT [dbo].[ChatUsers] OFF
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 
GO
INSERT [dbo].[Comments] ([Id], [UserId], [UserName], [AdvertId], [Comment], [Date], [Likes], [DisLikes], [Type]) VALUES (1, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 20041, N'some comment to test', CAST(N'2020-09-23T16:19:37.803' AS DateTime), 0, 0, 1)
GO
INSERT [dbo].[Comments] ([Id], [UserId], [UserName], [AdvertId], [Comment], [Date], [Likes], [DisLikes], [Type]) VALUES (2, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 20041, N'some another comment', CAST(N'2020-09-23T16:26:12.503' AS DateTime), 0, 0, 1)
GO
INSERT [dbo].[Comments] ([Id], [UserId], [UserName], [AdvertId], [Comment], [Date], [Likes], [DisLikes], [Type]) VALUES (1002, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 20035, N'not bad', CAST(N'2020-09-28T20:34:19.487' AS DateTime), 0, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[Comments] OFF
GO
SET IDENTITY_INSERT [dbo].[Complaints] ON 
GO
INSERT [dbo].[Complaints] ([Id], [Message], [ComplaintType], [ObjectId], [ObjectType], [UserSender], [UserRecipier], [Data], [Status]) VALUES (1, N'some message chto ochen ne ponravilos', 1, 20041, 1, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2020-10-27T23:28:47.867' AS DateTime), 1)
GO
INSERT [dbo].[Complaints] ([Id], [Message], [ComplaintType], [ObjectId], [ObjectType], [UserSender], [UserRecipier], [Data], [Status]) VALUES (6, N'some zaloba', 1, 20041, 1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-29T00:00:00.000' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Complaints] OFF
GO
SET IDENTITY_INSERT [dbo].[Currencies] ON 
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (1, N'Russian Ruble', N'RURT', CAST(N'2018-11-18T19:07:12.273' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (2, N'United States Dollar', N'USDT', CAST(N'2018-12-11T15:01:55.457' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (3, N'Bitcoin', N'BTC', CAST(N'2018-12-11T15:02:12.333' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (4, N'Ethereum', N'ETH', CAST(N'2018-12-11T15:02:30.663' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (5, N'Ripple', N'XRP', CAST(N'2018-12-11T15:38:30.220' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (6, N'EOS', N'EOS', CAST(N'2018-12-11T15:38:48.550' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (7, N'Decentraland', N'MANA', CAST(N'2018-12-11T15:51:16.407' AS DateTime), 1)
GO
INSERT [dbo].[Currencies] ([Id], [Name], [Acronim], [DateAdd], [IsValid]) VALUES (8, N'Rentoolo token', N'RENT', CAST(N'2019-10-28T05:10:40.820' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[Currencies] OFF
GO
SET IDENTITY_INSERT [dbo].[DialogMessages] ON 
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (1, 1, N'Tests msg', N'497b82eb-2f1f-410d-a71c-36b45111b74b', CAST(N'2020-10-02T18:08:46.840' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (2, 1, N'vrdt,ljhf', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T19:29:48.930' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (3, 1, N'[;;lj,,jytdktr', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T19:31:17.260' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (4, 1, N'qqqqqqqqqqq', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T19:32:31.883' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (5, 1, N'qqqqqqqq22222222', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T19:32:52.573' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (6, 1, N'fgxn', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T21:35:55.747' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (7, 1, N'aa', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T22:13:13.880' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (8, 1, N'pooooooo', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T22:16:47.443' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (9, 1, N'oug', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T22:19:16.427' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (10, 1, N'рффффф', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T22:21:43.307' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (11, 1, N'hmmmm', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-02T22:24:23.057' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (12, 1, N'somebody was told me the world is gone around me', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:30:37.787' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (13, 1, N'HELP i need some body', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:33:10.540' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (14, 1, N'!!!!!!!!!!!!', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:35:25.603' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (15, 1, N'@@@@@@@@', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:36:13.593' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (16, 1, N'heh', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:38:23.367' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (17, 1, N'kek', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:40:21.817' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (18, 1, N'kekekekeekekeke', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:40:44.040' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (19, 1, N'qqaaassss', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:42:32.393' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (20, 1, N'ffffff', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:43:52.297' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (21, 1, N'rrrr', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:44:10.517' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (22, 1, N'oooo', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:44:18.477' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (23, 1, N'pops', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:46:56.103' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (24, 1, N'qerty', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:50:15.207' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (25, 1, N'zzz', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:53:28.117' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (26, 1, N't', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T13:58:40.450' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (27, 1, N'mega mozg', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T14:00:46.107' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (28, 1, N'cmd', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-03T14:03:26.523' AS DateTime))
GO
INSERT [dbo].[DialogMessages] ([Id], [DialogInfoId], [Message], [FromUserId], [Date]) VALUES (29, 1, N'!!!!!!!!!!!!!!!!!!', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-10-06T00:24:03.673' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[DialogMessages] OFF
GO
SET IDENTITY_INSERT [dbo].[DialogsInfo] ON 
GO
INSERT [dbo].[DialogsInfo] ([Id], [User1Id], [User2Id]) VALUES (1, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'497b82eb-2f1f-410d-a71c-36b45111b74b')
GO
SET IDENTITY_INSERT [dbo].[DialogsInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[DisLikes] ON 
GO
INSERT [dbo].[DisLikes] ([id], [CommentId], [UserId]) VALUES (2, 1, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
INSERT [dbo].[DisLikes] ([id], [CommentId], [UserId]) VALUES (3, 2, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
SET IDENTITY_INSERT [dbo].[DisLikes] OFF
GO
SET IDENTITY_INSERT [dbo].[Exceptions] ON 
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (1, N'Строка не найдена или изменена.', CAST(N'2019-07-12T00:51:12.257' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (2, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2019-12-29T00:36:53.637' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (3, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2019-12-29T00:36:53.927' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (4, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2019-12-29T00:36:53.993' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (5, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2019-12-29T00:36:54.080' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (6, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2019-12-29T00:36:54.567' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (7, N'Object reference not set to an instance of an object.', CAST(N'2019-12-29T00:52:15.477' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (8, N'Object reference not set to an instance of an object.', CAST(N'2019-12-29T00:52:15.477' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (9, N'Object reference not set to an instance of an object.', CAST(N'2019-12-29T00:52:15.493' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (10, N'Object reference not set to an instance of an object.', CAST(N'2019-12-29T00:52:15.493' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (11, N'Object reference not set to an instance of an object.', CAST(N'2020-01-12T01:54:55.730' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (12, N'Object reference not set to an instance of an object.', CAST(N'2020-01-12T01:54:55.747' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (13, N'Object reference not set to an instance of an object.', CAST(N'2020-01-12T01:54:55.747' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (14, N'Object reference not set to an instance of an object.', CAST(N'2020-01-12T01:54:55.747' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (15, N'Object reference not set to an instance of an object.', CAST(N'2020-01-12T01:54:55.933' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (16, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:44:38.050' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (17, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:44:38.050' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (18, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:44:38.067' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (19, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:44:38.067' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (20, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:44:38.207' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (21, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:48:48.617' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (22, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:48:48.617' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (23, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:48:48.633' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (24, N'Object reference not set to an instance of an object.', CAST(N'2020-01-14T00:48:48.633' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (25, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T00:57:02.923' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (26, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T00:57:10.550' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (27, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T00:57:11.683' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (28, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T00:57:34.577' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (29, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:00:05.750' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (30, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:00:31.490' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (31, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:00:31.537' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (32, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:00:31.590' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (33, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:00:31.630' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (34, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:00:41.063' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (35, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:03:58.727' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (36, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:03:58.793' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (37, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:03:58.850' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (38, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:03:58.887' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (39, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:04:56.313' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (40, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:04:56.353' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (41, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:13:53.077' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (42, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:13:53.130' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (43, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:13:53.167' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (44, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-14T01:13:53.217' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (45, N'Object reference not set to an instance of an object.', CAST(N'2020-01-21T13:04:09.100' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (46, N'Object reference not set to an instance of an object.', CAST(N'2020-01-21T13:04:09.117' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (47, N'Object reference not set to an instance of an object.', CAST(N'2020-01-21T13:04:09.117' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (48, N'Object reference not set to an instance of an object.', CAST(N'2020-01-21T13:04:09.130' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (49, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:01:22.117' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (50, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:01:22.133' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (51, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:01:22.133' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (52, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:01:22.133' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (53, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:27:44.520' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (54, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:27:44.537' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (55, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:27:44.537' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (56, N'Object reference not set to an instance of an object.', CAST(N'2020-01-22T11:27:44.537' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (57, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T05:57:36.900' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (58, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T05:57:36.900' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (59, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T05:57:36.917' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (60, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T05:57:36.917' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (61, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-24T06:46:08.517' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (62, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-24T06:46:08.567' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (63, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-24T06:46:08.617' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (64, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-01-24T06:46:08.657' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (65, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:14:52.780' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (66, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:14:52.797' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (67, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:14:52.797' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (68, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:14:52.810' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (69, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:53:43.280' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (70, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:53:43.280' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (71, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:53:43.280' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (72, N'Object reference not set to an instance of an object.', CAST(N'2020-01-24T17:53:43.297' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (73, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:33:28.127' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (74, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:33:28.143' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (75, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:33:28.143' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (76, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:33:28.157' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (77, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:40:36.160' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (78, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:40:36.160' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (79, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:40:36.177' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (80, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T12:40:36.177' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (81, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T23:24:08.547' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (82, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T23:24:08.563' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (83, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T23:24:08.563' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (84, N'Object reference not set to an instance of an object.', CAST(N'2020-01-25T23:24:08.563' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (85, N'Object reference not set to an instance of an object.', CAST(N'2020-01-26T18:31:14.607' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (86, N'Object reference not set to an instance of an object.', CAST(N'2020-01-26T18:31:14.623' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (87, N'Object reference not set to an instance of an object.', CAST(N'2020-01-26T18:31:14.640' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (88, N'Object reference not set to an instance of an object.', CAST(N'2020-01-27T22:33:07.390' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (89, N'Object reference not set to an instance of an object.', CAST(N'2020-01-27T22:33:07.403' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (90, N'Object reference not set to an instance of an object.', CAST(N'2020-01-27T22:33:07.403' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (91, N'Object reference not set to an instance of an object.', CAST(N'2020-03-05T09:49:30.340' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (92, N'Object reference not set to an instance of an object.', CAST(N'2020-03-05T09:49:30.370' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (93, N'Object reference not set to an instance of an object.', CAST(N'2020-03-05T09:49:30.370' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (94, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T22:09:18.220' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (95, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T22:09:18.237' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (96, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T22:09:18.237' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (97, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:02:09.457' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (98, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:02:09.470' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (99, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:02:09.470' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (100, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:04:28.827' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (101, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:04:28.843' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (102, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:04:28.843' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (103, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:09:43.200' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (104, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:09:43.200' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (105, N'Object reference not set to an instance of an object.', CAST(N'2020-03-18T23:09:43.217' AS DateTime), NULL)
GO
INSERT [dbo].[Exceptions] ([Id], [Value], [WhenDate], [UserId]) VALUES (106, N'Ссылка на объект не указывает на экземпляр объекта.', CAST(N'2020-07-02T00:01:24.143' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Exceptions] OFF
GO
SET IDENTITY_INSERT [dbo].[ExchangeItemRequests] ON 
GO
INSERT [dbo].[ExchangeItemRequests] ([Id], [ExchangeItemId], [Comment], [WantedExchangeItemId]) VALUES (1, 27, N'exchange comment test1', 29)
GO
SET IDENTITY_INSERT [dbo].[ExchangeItemRequests] OFF
GO
SET IDENTITY_INSERT [dbo].[ExchangeProducts] ON 
GO
INSERT [dbo].[ExchangeProducts] ([Id], [AdvertId], [Comment], [WantedObject], [Header], [SelectedRequestId]) VALUES (1, 27, N'some test', N'gold metal', N'gold metal', NULL)
GO
SET IDENTITY_INSERT [dbo].[ExchangeProducts] OFF
GO
SET IDENTITY_INSERT [dbo].[Favorites] ON 
GO
INSERT [dbo].[Favorites] ([Id], [UserId], [AdvertId], [Created]) VALUES (8, N'314bd290-5fc5-4a93-8131-db644b83aaed', 30, CAST(N'2019-10-11T20:55:04.870' AS DateTime))
GO
INSERT [dbo].[Favorites] ([Id], [UserId], [AdvertId], [Created]) VALUES (9, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2019-10-26T14:30:57.397' AS DateTime))
GO
INSERT [dbo].[Favorites] ([Id], [UserId], [AdvertId], [Created]) VALUES (10005, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2019-12-16T00:40:59.790' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Favorites] OFF
GO
SET IDENTITY_INSERT [dbo].[FavoritesByCookies] ON 
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (24, N'1a4e0f0b-71b5-4170-9359-26edba0cda9b', 27, CAST(N'2019-10-03T09:51:10.170' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (25, N'1d732ccc-5598-4b56-aa85-b0417d723154', 27, CAST(N'2019-10-11T17:12:10.660' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10026, N'1a4e0f0b-71b5-4170-9359-26edba0cda9b', 32, CAST(N'2019-12-09T18:54:01.293' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10028, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 32, CAST(N'2019-12-15T00:08:47.533' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10031, N'98957529-5a45-4cb4-91ea-24021396e7f8', 32, CAST(N'2019-12-16T00:16:11.780' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10032, N'98957529-5a45-4cb4-91ea-24021396e7f8', 31, CAST(N'2019-12-19T16:44:36.447' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10033, N'98957529-5a45-4cb4-91ea-24021396e7f8', 30, CAST(N'2019-12-19T16:44:37.140' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10034, N'a0091786-0021-4579-9b32-18da2d501caa', 32, CAST(N'2019-12-28T08:57:42.460' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10035, N'a0091786-0021-4579-9b32-18da2d501caa', 31, CAST(N'2019-12-28T08:57:43.930' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10038, N'4be87b8f-abbd-4f29-ac35-071a9a70bbaf', 32, CAST(N'2020-01-11T05:10:50.480' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10039, N'945578db-fd59-4f9e-864f-b95367d198c6', 31, CAST(N'2020-02-19T00:41:27.250' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10040, N'585a25a4-8845-43d9-88c0-dd85caceaa11', 32, CAST(N'2020-03-04T00:02:00.440' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10042, N'7d1ba263-1502-47da-aa59-e738c35a6ab3', 29, CAST(N'2020-04-07T13:07:38.517' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10043, N'23e06813-37c5-49d8-b493-f346b37b7879', 10031, CAST(N'2020-07-14T19:16:23.857' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10044, N'23e06813-37c5-49d8-b493-f346b37b7879', 10032, CAST(N'2020-07-14T19:16:25.753' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10045, N'23e06813-37c5-49d8-b493-f346b37b7879', 10033, CAST(N'2020-07-14T19:16:27.957' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10046, N'23e06813-37c5-49d8-b493-f346b37b7879', 10034, CAST(N'2020-07-14T19:16:29.947' AS DateTime))
GO
INSERT [dbo].[FavoritesByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10047, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10027, CAST(N'2020-07-25T20:37:36.883' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[FavoritesByCookies] OFF
GO
SET IDENTITY_INSERT [dbo].[ItemLikes] ON 
GO
INSERT [dbo].[ItemLikes] ([Id], [ObjectType], [ObjectId], [UserId], [Date]) VALUES (6, 0, 27, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-11-04T20:30:05.907' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ItemLikes] OFF
GO
SET IDENTITY_INSERT [dbo].[Likes] ON 
GO
INSERT [dbo].[Likes] ([Id], [CommentId], [UserId]) VALUES (1002, 1002, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329')
GO
SET IDENTITY_INSERT [dbo].[Likes] OFF
GO
SET IDENTITY_INSERT [dbo].[LoginStat] ON 
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (1, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T15:48:33.560' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (2, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T15:48:33.577' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (3, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T15:48:33.593' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (4, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T15:48:33.727' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (5, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T15:48:33.747' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (6, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:46.803' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (7, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:49.873' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (8, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:49.910' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (9, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:49.940' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:56.313' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (11, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:56.330' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (12, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:17:56.343' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (13, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:18:02.733' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (14, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:18:47.543' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (15, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:19:42.423' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (16, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:19:52.827' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (17, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:20:35.403' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (18, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:20:46.257' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (19, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:22:24.537' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-11-16T16:43:47.133' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (21, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-11-16T16:47:19.940' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (22, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-16T00:39:09.750' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (23, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-16T00:44:54.900' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (24, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-16T01:32:44.980' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (25, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'83.220.238.161', CAST(N'2019-12-16T10:40:02.113' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (26, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'83.220.238.161', CAST(N'2019-12-16T11:27:04.667' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (27, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'83.220.238.161', CAST(N'2019-12-16T11:27:04.667' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (28, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'83.220.238.161', CAST(N'2019-12-16T13:15:11.257' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (29, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'83.220.238.161', CAST(N'2019-12-16T13:15:11.257' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-16T23:42:05.337' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (31, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-24T19:38:17.027' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (32, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T13:26:18.147' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (33, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T13:31:08.623' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (34, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T15:47:35.503' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (35, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T16:11:13.127' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (36, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T16:14:46.433' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (37, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T16:36:01.180' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (38, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-28T16:57:34.693' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (39, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-29T00:33:09.050' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (40, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-29T00:34:12.147' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (41, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-29T00:36:58.050' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (42, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-29T00:49:48.433' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (43, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-29T00:51:20.690' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (44, NULL, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'localhost', CAST(N'2019-12-29T00:52:02.730' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (45, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-29T00:53:23.593' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (46, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-29T01:06:38.887' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (47, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-29T01:06:58.197' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (48, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2019-12-29T01:22:26.547' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (49, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'89.179.241.190', CAST(N'2019-12-31T01:17:35.930' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (50, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-03T21:40:20.687' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (51, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-07T14:08:10.370' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (52, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-07T22:08:37.787' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (53, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-07T22:38:27.603' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (54, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-07T22:54:45.020' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (55, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-07T23:08:01.070' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (56, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-07T23:12:03.603' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (57, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-08T00:06:06.530' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (58, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-08T01:32:33.893' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (59, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-08T01:52:52.297' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (60, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-08T02:13:30.670' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (61, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-08T02:32:05.403' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (62, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-08T02:33:44.373' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (63, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:13:18.973' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (64, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:14:26.807' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (65, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:16:24.487' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (66, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:16:31.870' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (67, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:21:59.207' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (68, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:26:37.243' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (69, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T05:27:25.930' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (70, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T07:25:51.420' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (71, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T07:35:15.423' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (72, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-11T07:36:56.787' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (73, NULL, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'localhost', CAST(N'2020-01-12T01:52:01.837' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (74, NULL, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'localhost', CAST(N'2020-01-12T02:24:49.293' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (75, NULL, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'localhost', CAST(N'2020-01-12T21:33:52.747' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (76, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-13T03:22:51.407' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (77, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T00:08:00.510' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (78, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T00:20:05.737' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (79, NULL, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'localhost', CAST(N'2020-01-14T00:42:57.570' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (80, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T00:47:19.433' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (81, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T00:54:06.937' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (82, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T01:13:42.073' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (83, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T01:25:07.257' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (84, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T01:25:44.630' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (85, NULL, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'localhost', CAST(N'2020-01-14T01:25:49.950' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (86, NULL, N'2e416d84-4e86-468a-8088-4d9a70ffb0de', N'localhost', CAST(N'2020-01-14T01:26:27.203' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (87, NULL, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'localhost', CAST(N'2020-01-14T01:27:20.457' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (88, NULL, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'localhost', CAST(N'2020-01-14T01:28:34.880' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (89, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T01:45:43.507' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (90, NULL, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'localhost', CAST(N'2020-01-14T01:56:03.043' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (91, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T02:20:59.160' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (92, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T03:06:35.260' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (93, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T04:26:12.653' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (94, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T07:56:31.757' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (95, NULL, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'localhost', CAST(N'2020-01-14T08:13:20.627' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (96, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T08:20:19.250' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (97, NULL, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'localhost', CAST(N'2020-01-14T08:24:53.587' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (98, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T08:28:03.477' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (99, NULL, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'localhost', CAST(N'2020-01-14T08:29:32.043' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (100, NULL, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'localhost', CAST(N'2020-01-14T08:31:31.923' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (101, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T08:32:55.163' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (102, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-14T08:56:33.860' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (103, NULL, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'localhost', CAST(N'2020-01-14T15:04:38.937' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (104, NULL, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'localhost', CAST(N'2020-01-14T22:30:07.040' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (105, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-15T20:08:55.070' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (106, NULL, N'2e416d84-4e86-468a-8088-4d9a70ffb0de', N'localhost', CAST(N'2020-01-15T22:53:44.067' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (107, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-16T00:10:32.070' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (108, NULL, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'localhost', CAST(N'2020-01-16T00:13:12.737' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (109, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-16T00:50:47.137' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (110, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T07:18:24.270' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (111, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T07:21:16.937' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (112, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T07:28:35.680' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (113, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T07:44:45.323' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (114, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T20:32:42.633' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (115, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T20:38:34.597' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (116, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-19T20:52:29.597' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (117, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-20T09:46:27.307' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (118, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-20T09:46:28.150' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (119, NULL, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'localhost', CAST(N'2020-01-20T16:11:32.887' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (120, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T03:51:48.873' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (121, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T04:21:22.427' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (122, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T12:28:20.867' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (123, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T12:29:09.873' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (124, NULL, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'localhost', CAST(N'2020-01-21T13:01:05.860' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (125, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T13:03:29.210' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (126, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T13:45:56.753' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (127, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T13:46:04.917' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (128, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T15:36:09.960' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (129, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-21T19:36:48.457' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (130, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T08:00:02.113' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (131, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T09:30:11.850' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (132, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T10:07:46.537' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (133, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T10:28:44.507' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (134, NULL, N'd605cfec-b531-4b21-a58c-074b035402af', N'localhost', CAST(N'2020-01-22T10:56:15.140' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (135, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T11:27:27.093' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (136, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T11:42:14.120' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (137, NULL, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'localhost', CAST(N'2020-01-22T11:56:56.117' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (138, NULL, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'localhost', CAST(N'2020-01-22T11:57:30.047' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (139, NULL, N'd605cfec-b531-4b21-a58c-074b035402af', N'localhost', CAST(N'2020-01-22T12:26:07.390' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (140, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-22T13:04:57.967' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (141, NULL, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'localhost', CAST(N'2020-01-22T13:37:37.640' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (142, NULL, N'd605cfec-b531-4b21-a58c-074b035402af', N'localhost', CAST(N'2020-01-22T15:10:16.077' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (143, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T05:37:18.083' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (144, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T05:45:17.937' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (145, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T07:41:12.510' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (146, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T07:54:40.030' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (147, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T08:01:13.580' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (148, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T08:05:09.903' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (149, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T08:06:59.827' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (150, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T08:08:46.030' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (151, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T08:53:28.187' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (152, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T08:53:54.017' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (153, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-23T09:10:13.983' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (154, NULL, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'localhost', CAST(N'2020-01-23T22:29:33.093' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (155, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-24T05:57:20.647' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (156, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-24T06:45:59.650' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (157, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-24T06:58:40.157' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (158, NULL, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', N'localhost', CAST(N'2020-01-24T17:11:52.413' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (159, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-24T17:53:21.847' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (160, NULL, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', N'localhost', CAST(N'2020-01-24T17:55:21.420' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (161, NULL, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', N'localhost', CAST(N'2020-01-24T19:48:05.720' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (162, NULL, N'0677b5f2-2ec7-4bbe-89f7-c6ed48cb9dca', N'localhost', CAST(N'2020-01-24T22:05:33.563' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (163, NULL, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'localhost', CAST(N'2020-01-24T22:42:41.447' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (164, NULL, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'localhost', CAST(N'2020-01-24T23:10:40.273' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (165, NULL, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'localhost', CAST(N'2020-01-24T23:18:31.300' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (166, NULL, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'localhost', CAST(N'2020-01-25T00:16:22.830' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (167, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-25T08:39:45.740' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (168, NULL, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'localhost', CAST(N'2020-01-25T09:43:33.433' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (169, NULL, N'023461b1-28b3-4e5b-b5bc-e2a179b1b032', N'localhost', CAST(N'2020-01-25T10:00:07.823' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (170, NULL, N'023461b1-28b3-4e5b-b5bc-e2a179b1b032', N'localhost', CAST(N'2020-01-25T10:05:41.337' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (171, NULL, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', N'localhost', CAST(N'2020-01-25T10:23:32.183' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (172, NULL, N'17dd7a4a-66e6-47a2-ad13-89dba1ccadb7', N'localhost', CAST(N'2020-01-25T11:05:31.193' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (173, NULL, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'localhost', CAST(N'2020-01-25T12:11:32.127' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (174, NULL, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', N'localhost', CAST(N'2020-01-25T12:33:29.670' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (175, NULL, N'037bc9a7-a702-4f15-9695-830d47fc9197', N'localhost', CAST(N'2020-01-25T17:00:25.053' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (176, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-25T19:56:21.527' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (177, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-25T20:34:08.267' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (178, NULL, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'localhost', CAST(N'2020-01-25T20:43:11.850' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (179, NULL, N'5ff870c8-71e7-4738-b7c0-81a3162a3cb0', N'localhost', CAST(N'2020-01-25T20:53:37.037' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (180, NULL, N'8c335406-4e98-462f-90ca-ac158cdd1142', N'localhost', CAST(N'2020-01-25T20:53:52.323' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (181, NULL, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'localhost', CAST(N'2020-01-25T21:14:06.377' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (182, NULL, N'26edc365-d524-48d2-b456-88abff129efd', N'localhost', CAST(N'2020-01-25T23:14:14.500' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (183, NULL, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'localhost', CAST(N'2020-01-25T23:52:26.170' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (184, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T09:37:03.677' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (185, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T14:56:03.580' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (186, NULL, N'f7db8012-d9f1-4cfd-b8c3-ce067edd6d19', N'localhost', CAST(N'2020-01-26T15:26:57.063' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (187, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T15:29:53.810' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (188, NULL, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'localhost', CAST(N'2020-01-26T18:10:37.043' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (189, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T18:31:00.303' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (190, NULL, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'localhost', CAST(N'2020-01-26T18:34:02.153' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (191, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T19:09:11.910' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (192, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T20:43:19.783' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (193, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T20:49:30.337' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (194, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T21:33:01.510' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (195, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T21:46:38.570' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (196, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-26T22:18:27.667' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (197, NULL, N'9891d3d6-e7eb-4911-98f5-fdde0c32b9cf', N'localhost', CAST(N'2020-01-26T22:51:53.063' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (198, NULL, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'localhost', CAST(N'2020-01-26T23:08:41.400' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (199, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T03:26:10.377' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (200, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T05:07:24.767' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (201, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T05:09:29.497' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (202, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T05:11:15.693' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (203, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T10:46:24.450' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (204, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T12:43:59.647' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (205, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T12:46:42.180' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (206, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T14:31:02.010' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (207, NULL, N'996da0e7-d189-47a3-8436-e54b1572872d', N'localhost', CAST(N'2020-01-27T17:21:37.747' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (208, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-27T22:31:30.480' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (209, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T04:04:39.790' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (210, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T04:39:14.577' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (211, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T05:55:15.447' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (212, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T06:01:40.697' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (213, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T06:03:56.867' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (214, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T06:17:48.237' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (215, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T09:16:09.933' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (216, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-28T09:50:04.017' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (217, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-29T20:47:12.603' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (218, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-29T23:00:45.387' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (219, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-29T23:01:01.953' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (220, NULL, N'037bc9a7-a702-4f15-9695-830d47fc9197', N'localhost', CAST(N'2020-01-30T06:03:45.777' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (221, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-30T08:58:57.697' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (222, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-01-31T00:05:24.603' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (223, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-01T09:54:07.267' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (224, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-01T23:09:09.807' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (225, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-06T11:24:01.187' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (226, NULL, N'9891d3d6-e7eb-4911-98f5-fdde0c32b9cf', N'localhost', CAST(N'2020-02-07T05:52:07.373' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (227, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-08T20:28:18.507' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (228, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-09T04:24:17.333' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (229, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-09T22:28:12.033' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (230, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-09T23:06:38.087' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (231, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-10T21:12:54.657' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (232, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-10T21:41:20.717' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (233, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-11T06:24:54.363' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (234, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-11T14:54:53.507' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (235, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-11T20:03:35.823' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (236, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-11T20:21:49.633' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (237, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-14T09:05:46.437' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (238, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-02-17T07:12:25.363' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (239, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-05T09:27:18.497' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (240, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-05T09:47:02.030' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (241, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-07T18:31:49.540' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (242, NULL, N'4d54d89b-7e4c-40a6-8638-739bdd618947', N'localhost', CAST(N'2020-03-08T14:19:37.777' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (243, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-11T14:51:12.860' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (244, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-12T21:58:20.390' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (245, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-12T22:29:41.253' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (246, NULL, N'ff342ff7-3798-4f20-8c15-bb16ad9e3100', N'localhost', CAST(N'2020-03-18T22:07:35.493' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (247, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-03-18T22:58:18.277' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (248, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-03-18T23:00:01.377' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (249, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-18T23:08:56.930' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (250, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-19T11:38:01.847' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (251, NULL, N'ff342ff7-3798-4f20-8c15-bb16ad9e3100', N'localhost', CAST(N'2020-03-19T17:41:49.553' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (252, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-23T02:24:16.160' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (253, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-03-24T16:09:36.430' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (254, NULL, N'497b82eb-2f1f-410d-a71c-36b45111b74b', N'localhost', CAST(N'2020-03-31T12:56:46.117' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (255, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-05T00:42:09.943' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (256, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-06T04:34:17.647' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (257, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-07T12:59:05.163' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (258, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-07T14:44:24.800' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (259, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-08T14:41:05.850' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (260, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-08T15:04:13.103' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (261, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-09T00:05:48.813' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (262, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-09T20:55:32.793' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (263, NULL, N'd0672d7a-632f-4901-a9d1-8b72e6c35869', N'localhost', CAST(N'2020-04-17T11:28:06.257' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (264, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-20T23:07:50.057' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (265, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-22T09:33:08.190' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (266, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-27T14:39:49.620' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (267, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-27T14:40:26.127' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (268, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-27T20:34:08.310' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (269, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-27T21:27:32.340' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (270, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-28T02:24:31.137' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (271, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-28T02:32:33.360' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (272, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-29T00:47:20.487' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (273, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-29T01:55:22.983' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (274, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-04-29T02:14:30.110' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (275, NULL, N'61066082-72b4-477f-92dc-d1af87de7de9', N'localhost', CAST(N'2020-04-29T02:15:07.797' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (276, NULL, N'61066082-72b4-477f-92dc-d1af87de7de9', N'localhost', CAST(N'2020-04-29T02:15:24.583' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (277, NULL, N'61066082-72b4-477f-92dc-d1af87de7de9', N'localhost', CAST(N'2020-04-29T17:09:22.397' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (278, NULL, N'61066082-72b4-477f-92dc-d1af87de7de9', N'localhost', CAST(N'2020-04-29T17:23:44.840' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (279, NULL, N'61066082-72b4-477f-92dc-d1af87de7de9', N'localhost', CAST(N'2020-04-29T17:24:23.513' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (280, NULL, N'61066082-72b4-477f-92dc-d1af87de7de9', N'localhost', CAST(N'2020-04-29T17:25:03.710' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (281, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-01T00:33:16.563' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (282, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-01T00:35:17.107' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (283, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-01T00:36:16.213' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (284, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-01T00:36:39.023' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (285, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-01T00:36:46.447' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (286, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-01T00:43:05.823' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (287, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-02T02:56:56.447' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (288, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-04T11:00:56.170' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (289, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-04T11:07:22.530' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (290, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-04T18:57:32.650' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (291, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-05T05:50:51.413' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (292, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-07T16:51:21.047' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (293, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-08T17:03:22.740' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (294, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-09T17:21:00.333' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (295, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-10T23:21:59.840' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (296, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-10T23:25:49.560' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (297, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-10T23:29:22.917' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (298, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-10T23:47:26.280' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (299, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-10T23:56:26.100' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (300, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-10T23:58:55.497' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (301, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-11T03:10:51.533' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (302, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-11T04:13:39.357' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (303, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-11T04:21:26.247' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (304, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-12T19:01:41.800' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (305, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-12T20:27:49.480' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (306, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-13T21:47:25.217' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (307, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-13T22:30:45.757' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (308, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-14T02:37:38.267' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (309, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-28T11:57:19.360' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (310, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-29T21:54:50.160' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (311, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-30T14:59:30.910' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (312, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-30T17:31:28.930' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (313, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-30T17:42:32.160' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (314, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-30T19:06:55.127' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (315, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-05-30T20:04:40.650' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (316, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-08T00:16:37.210' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (317, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-17T16:15:15.790' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (318, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-17T16:50:04.910' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (319, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-18T17:47:54.257' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (320, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-06-26T21:18:08.103' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (321, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-06-26T23:00:07.273' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (322, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-06-26T23:41:50.140' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (323, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-28T05:33:50.647' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (324, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-28T06:07:09.400' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (325, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-28T06:07:54.513' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (326, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-28T16:04:46.547' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (327, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-28T16:12:01.847' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (328, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-06-28T17:53:06.447' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (329, NULL, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', N'localhost', CAST(N'2020-06-28T18:42:42.680' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (330, NULL, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', N'localhost', CAST(N'2020-06-29T04:32:10.780' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (331, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-06-29T12:27:58.873' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (332, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-01T23:40:16.900' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (333, NULL, N'ee678bfb-bf49-4050-aad3-6c5025d3f0e5', N'localhost', CAST(N'2020-07-08T11:35:07.110' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (334, NULL, N'ee678bfb-bf49-4050-aad3-6c5025d3f0e5', N'localhost', CAST(N'2020-07-09T09:59:44.320' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (335, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-07-10T20:35:09.000' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (336, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-07-11T07:44:02.533' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (337, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-07-13T17:44:16.393' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (338, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-07-15T09:31:05.490' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (339, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-07-15T10:35:31.803' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (340, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-15T10:43:19.060' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (341, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-16T01:21:48.397' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (342, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-16T01:45:10.910' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (343, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-16T21:35:34.197' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10341, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-18T16:43:29.727' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10342, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-19T16:20:46.390' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10343, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-23T01:17:21.237' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10344, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-23T17:39:29.973' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10345, NULL, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'localhost', CAST(N'2020-07-26T16:29:17.737' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10346, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-26T17:30:31.597' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10347, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-26T17:52:14.097' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10348, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-26T19:19:30.917' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10349, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-27T22:29:22.447' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10350, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-07-29T11:00:57.227' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10351, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-08-16T12:13:13.393' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10352, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-08-16T12:15:04.680' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10353, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-08-16T13:12:41.693' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10354, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-08-16T14:05:39.270' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10355, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-08-16T14:15:01.230' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10356, NULL, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'localhost', CAST(N'2020-08-16T14:17:19.200' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10357, NULL, N'53446782-b6e0-43cf-a718-4e445e853160', N'localhost', CAST(N'2020-09-11T00:23:45.573' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10358, NULL, N'53446782-b6e0-43cf-a718-4e445e853160', N'localhost', CAST(N'2020-09-11T00:37:31.513' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10359, NULL, N'53446782-b6e0-43cf-a718-4e445e853160', N'localhost', CAST(N'2020-09-11T19:50:32.677' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10360, NULL, N'53446782-b6e0-43cf-a718-4e445e853160', N'localhost', CAST(N'2020-09-11T21:01:25.883' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10361, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-14T20:57:54.767' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10362, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-14T22:59:47.557' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10363, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T20:52:11.783' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10364, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:01:18.430' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10365, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:02:01.600' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10366, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:06:30.363' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10367, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:26:33.670' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10368, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:34:28.383' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10369, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:36:02.217' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10370, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:38:56.877' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10371, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:40:55.273' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10372, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T21:59:50.163' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10373, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T22:31:28.617' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10374, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T22:35:34.693' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10375, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T22:39:32.353' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10376, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-15T23:19:44.427' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10377, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-16T21:41:24.513' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10378, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-18T19:41:30.590' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10379, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-18T20:27:58.840' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10380, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-18T20:29:59.437' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (10381, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-18T20:32:27.690' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20361, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-23T15:37:41.843' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20362, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-23T16:19:01.737' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20363, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-23T16:28:32.823' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20364, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-23T16:33:39.113' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20365, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-23T16:36:05.867' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20366, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-23T16:45:10.570' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20367, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T14:09:09.327' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20368, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T14:16:05.690' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20369, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T14:23:55.697' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20370, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:18:04.543' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20371, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:21:44.817' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20372, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:24:15.500' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20373, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:28:17.997' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20374, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:30:38.853' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20375, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:33:38.820' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20376, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T15:37:30.493' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20377, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T16:41:11.763' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20378, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T16:41:11.763' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (20379, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-24T17:02:03.137' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30361, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-09-28T20:33:56.007' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30362, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-07T22:50:47.807' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30363, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-08T17:30:30.770' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30364, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-08T17:46:09.187' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30365, NULL, N'eb192af4-6fa7-4f34-ac02-5058cc5d424b', N'localhost', CAST(N'2020-10-08T23:19:12.370' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30366, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-13T19:42:59.750' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30367, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-13T19:53:41.777' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30368, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-13T20:08:40.547' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30369, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-13T23:18:09.967' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30370, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-13T23:21:41.197' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30371, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T18:41:10.750' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30372, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T18:42:12.110' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30373, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T19:35:00.760' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30374, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T19:41:30.320' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30375, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T19:52:56.360' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30376, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T20:43:39.010' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30377, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T20:48:30.683' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30378, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T20:51:40.337' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30379, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T21:15:14.760' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30380, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-14T21:17:00.847' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30381, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-27T23:27:25.857' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30382, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T15:23:46.700' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30383, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T15:47:33.087' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30384, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T17:17:48.283' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30385, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T18:07:12.347' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30386, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T18:16:59.357' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30387, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T19:49:49.933' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30388, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T19:50:16.597' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30389, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T19:55:55.070' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30390, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T20:31:47.807' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30391, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T20:45:50.853' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30392, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-28T22:36:40.173' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30393, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-10-29T22:31:53.877' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30394, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-02T13:49:39.837' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30395, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T02:14:10.317' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30396, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T16:26:05.997' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30397, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T17:17:19.867' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30398, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T17:30:49.530' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30399, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T17:48:13.893' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30400, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T18:20:35.663' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30401, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T18:38:42.077' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30402, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T18:46:00.797' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30403, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T18:57:34.730' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30404, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T20:24:40.190' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30405, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-04T20:29:36.230' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30406, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-10T12:54:53.847' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30407, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-13T18:02:10.373' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30408, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-13T18:05:06.060' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30409, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-13T18:27:30.320' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30410, NULL, N'92cfb222-e607-4103-8d48-02826604aa12', N'localhost', CAST(N'2020-11-13T18:28:06.990' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30411, NULL, N'92cfb222-e607-4103-8d48-02826604aa12', N'localhost', CAST(N'2020-11-13T18:32:47.580' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30412, NULL, N'92cfb222-e607-4103-8d48-02826604aa12', N'localhost', CAST(N'2020-11-14T14:52:11.927' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30413, NULL, N'92cfb222-e607-4103-8d48-02826604aa12', N'localhost', CAST(N'2020-11-15T13:39:23.463' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30414, NULL, N'92cfb222-e607-4103-8d48-02826604aa12', N'localhost', CAST(N'2020-11-15T14:21:34.807' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30415, NULL, N'92cfb222-e607-4103-8d48-02826604aa12', N'localhost', CAST(N'2020-11-15T14:41:45.460' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30416, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-18T18:31:29.390' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30417, NULL, N'e7bc0057-d3b9-4791-a9ea-c4589500ace9', N'localhost', CAST(N'2020-11-20T23:12:07.743' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30418, NULL, N'e7bc0057-d3b9-4791-a9ea-c4589500ace9', N'localhost', CAST(N'2020-11-20T23:12:38.500' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30419, NULL, N'e7bc0057-d3b9-4791-a9ea-c4589500ace9', N'localhost', CAST(N'2020-11-20T23:13:36.713' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30420, NULL, N'e7bc0057-d3b9-4791-a9ea-c4589500ace9', N'localhost', CAST(N'2020-11-20T23:59:40.823' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30421, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-21T14:45:57.013' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30422, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-11-21T14:50:24.793' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30423, NULL, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'localhost', CAST(N'2020-11-22T23:34:38.517' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30424, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T00:52:48.307' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30425, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:03:02.513' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30426, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:06:35.817' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30427, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:08:04.187' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30428, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:08:36.157' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30429, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:11:14.737' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30430, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:12:12.213' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30431, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:13:54.467' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30432, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:15:34.107' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30433, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:17:17.083' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30434, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:18:35.587' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30435, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:20:37.760' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30436, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:22:54.973' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30437, NULL, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'localhost', CAST(N'2020-11-28T01:31:36.110' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30438, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-12-02T21:43:49.697' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30439, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-12-02T21:44:00.183' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30440, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-12-03T08:57:44.677' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30441, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-12-03T09:11:23.090' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30442, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-12-03T10:30:27.930' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30443, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2020-12-03T10:32:06.283' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30444, NULL, N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', N'localhost', CAST(N'2020-12-03T10:35:07.517' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30445, NULL, N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', N'localhost', CAST(N'2020-12-03T10:41:02.083' AS DateTime))
GO
INSERT [dbo].[LoginStat] ([Id], [UserName], [UserId], [Ip], [WhenDate]) VALUES (30446, NULL, N'bd4551af-fc28-4b85-b147-20a051676b21', N'localhost', CAST(N'2021-01-16T19:23:18.093' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[LoginStat] OFF
GO
SET IDENTITY_INSERT [dbo].[LoginStatistics] ON 
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14543, N'mmmm', N'192.168.1.1', CAST(N'2019-06-01T19:46:28.847' AS DateTime), 20, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14544, N'mmm', N'::1', CAST(N'2019-09-27T16:35:27.617' AS DateTime), 328, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14545, N'mmmm', N'66.102.9.8', CAST(N'2019-05-22T01:24:03.583' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14546, N'mmmm', N'66.102.9.14', CAST(N'2019-05-22T01:24:09.590' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14547, N'mmmm', N'66.102.9.11', CAST(N'2019-05-22T10:00:17.850' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14548, N'dddddd', N'::1', CAST(N'2019-05-30T02:31:23.493' AS DateTime), 4, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14549, N'hhh', N'::1', CAST(N'2019-06-01T19:02:52.567' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14550, N'mmmm', N'66.102.9.40', CAST(N'2019-06-02T20:38:37.920' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14551, N'mmm', N'66.102.9.40', CAST(N'2019-06-19T09:02:06.467' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14552, N'mmm', N'83.220.238.240', CAST(N'2019-06-08T21:54:43.663' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14553, N'mmm', N'66.102.9.42', CAST(N'2019-06-08T21:54:43.163' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14554, N'mmm', N'192.168.1.1', CAST(N'2019-10-28T05:12:34.827' AS DateTime), 172, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14555, N'mmm', N'194.186.38.113', CAST(N'2019-06-17T13:54:38.760' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14556, N'mmm', N'66.102.9.38', CAST(N'2019-07-28T21:20:14.640' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14557, N'qwer', N'::1', CAST(N'2019-07-09T22:52:50.713' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14558, N'Hhhgg', N'66.102.9.42', CAST(N'2019-07-09T23:09:44.720' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14559, N'Hhhgg', N'91.193.177.1', CAST(N'2019-07-09T23:09:56.560' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14560, N'mmmyyy', N'66.102.9.38', CAST(N'2019-07-26T17:15:04.183' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14561, N'mmm', N'83.220.236.162', CAST(N'2019-08-08T17:58:21.520' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14562, N'mmm', N'217.77.104.20', CAST(N'2019-09-18T15:12:25.347' AS DateTime), 12, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14563, N'kkk', N'::1', CAST(N'2019-08-24T02:28:25.820' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14564, N'kkkr', N'::1', CAST(N'2019-08-24T02:32:31.657' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14565, N'nnn', N'192.168.1.1', CAST(N'2019-08-24T15:49:22.510' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14566, N'kkke', N'192.168.1.1', CAST(N'2019-08-24T15:50:19.637' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14567, N'Dmitriy', N'37.112.225.136', CAST(N'2019-08-24T22:38:46.910' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14568, N'ashfaq', N'122.170.10.235', CAST(N'2019-09-16T10:50:09.297' AS DateTime), 3, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14569, N'mmm', N'91.193.178.104', CAST(N'2019-09-19T21:07:50.657' AS DateTime), 4, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14570, N'kkkk', N'217.77.104.21', CAST(N'2019-10-02T21:36:13.327' AS DateTime), 35, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14571, N'nnnnkkk', N'91.193.177.120', CAST(N'2019-09-23T19:35:27.427' AS DateTime), 6, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14572, N'nnnnkkk', N'66.102.9.46', CAST(N'2019-09-25T20:33:06.337' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14573, N'nnnnkkk', N'66.102.9.48', CAST(N'2019-09-25T20:33:09.837' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14574, N'nnnnkkk', N'66.102.9.44', CAST(N'2019-09-25T21:43:38.360' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14575, N'nnnnkkk', N'91.193.179.98', CAST(N'2019-09-26T00:32:14.380' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14576, N'mmm22', N'::1', CAST(N'2019-09-27T17:08:43.183' AS DateTime), 20, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14577, N'nnnnkkk', N'192.168.1.1', CAST(N'2019-09-28T13:57:06.117' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14578, N'Mmm', N'91.193.179.54', CAST(N'2019-09-30T03:00:27.987' AS DateTime), 0, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14579, N'Yyy', N'91.193.179.252', CAST(N'2019-10-03T09:09:41.727' AS DateTime), 20, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14580, N'mmm422t', N'::1', CAST(N'2019-10-03T02:18:48.720' AS DateTime), 10, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14581, N'Yyy', N'192.168.1.1', CAST(N'2019-10-03T08:27:53.730' AS DateTime), 8, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14582, N'bbb', N'217.77.104.21', CAST(N'2019-10-04T12:54:09.197' AS DateTime), 2, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14583, N'nnnnkkk', N'91.193.177.190', CAST(N'2019-10-04T17:02:27.620' AS DateTime), 1, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14584, N'kkkuuu', N'217.77.104.21', CAST(N'2019-10-11T20:54:59.877' AS DateTime), 15, 0, N'')
GO
INSERT [dbo].[LoginStatistics] ([Id], [UserName], [Ip], [WhenLastDate], [Count], [Client], [Version]) VALUES (14585, N'mmm', N'91.193.177.87', CAST(N'2019-10-12T18:49:28.127' AS DateTime), 0, 0, N'')
GO
SET IDENTITY_INSERT [dbo].[LoginStatistics] OFF
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'92cfb222-e607-4103-8d48-02826604aa12', N'QMgUqT4v+3FiogLyA30rNmK88+UhA83AlN+dLvrYyEQ=', 1, N'1SwEmo2acIJQfpAkSHLZfQ==', N'ODMEN@CHOTO.COM', NULL, NULL, 1, 0, CAST(N'2020-11-13T15:28:06.630' AS DateTime), CAST(N'2020-11-15T10:39:23.083' AS DateTime), CAST(N'2020-11-13T15:28:06.630' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'd605cfec-b531-4b21-a58c-074b035402af', N'6156M90w4EuuP9nMaqOelFH8QH+eWoMzIPMkUEn9HLc=', 1, N'9eSCtHyNoPAMj3kn9G39VQ==', N'tengo87@yandex.ru', NULL, NULL, 1, 1, CAST(N'2020-01-22T07:56:14.597' AS DateTime), CAST(N'2020-07-26T23:50:40.643' AS DateTime), CAST(N'2020-01-22T07:56:14.597' AS DateTime), CAST(N'2020-07-26T23:50:40.660' AS DateTime), 5, CAST(N'2020-07-26T23:50:40.660' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'b98b7ebc-4d5e-405b-88d8-087421c50b8e', N'huULzXiHggt6nMmmS99xqOVAoLmEK1lsivziW5Bup20=', 1, N'YsKSD6kPT8dwNwajpg4OqA==', N'qwqw34@dterty.rt', NULL, NULL, 1, 0, CAST(N'2019-06-01T16:02:48.347' AS DateTime), CAST(N'2019-06-01T16:02:48.347' AS DateTime), CAST(N'2019-06-01T16:02:48.347' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'buzSEOjcXaXKoEz9GxhmpDvnHY/gR8RVLxxdt/cp1kE=', 1, N'PkHlToF+G7QNfsoGkvTMUQ==', N'wwweb.makc@yandex.ru', NULL, NULL, 1, 0, CAST(N'2020-03-18T19:58:17.997' AS DateTime), CAST(N'2020-07-26T13:29:17.127' AS DateTime), CAST(N'2020-03-18T19:58:17.997' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f42ba606-48bf-45ef-9ea4-1ee8c44add71', N'JmPjTm1xOZbqnOiWcga4Ji5fpoimxFV7kH+7s4eYyFY=', 1, N'Uo7CfMhy1LZEbK1B1Tpvsg==', N'wertgwret@wrty.rt', NULL, NULL, 1, 0, CAST(N'2019-08-23T23:32:27.017' AS DateTime), CAST(N'2019-08-23T23:32:27.017' AS DateTime), CAST(N'2019-08-23T23:32:27.017' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'90553147-77ee-4561-b0f7-1f239afac377', N'T21vh9EpEqeNCsJ1F+DVTxfdZz/p5X3h/200cZYQO/s=', 1, N'dctEroda38LDQz00FTbxxQ==', N'Fghgg@ffh.ru', NULL, NULL, 1, 0, CAST(N'2019-07-09T20:09:44.003' AS DateTime), CAST(N'2019-07-09T20:09:44.003' AS DateTime), CAST(N'2019-07-09T20:09:44.003' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'bd4551af-fc28-4b85-b147-20a051676b21', N'O7UewHtPed2cHPerH5q9aql8EK3yQ/BJwDglVJIl4d4=', 1, N'tydRAI+CzyJwxioxKMFMbw==', N'admin@admin.com', NULL, NULL, 1, 0, CAST(N'2020-11-02T10:49:39.630' AS DateTime), CAST(N'2021-01-16T16:23:17.993' AS DateTime), CAST(N'2020-11-02T10:49:39.630' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'TzlB0UbSX3jM7tcXxPxerAgW32vvkx69ORDkccyGdBY=', 1, N'KIq9CZf+cZ+l8ZtgJuc2dA==', N'uirykkkku@wert.ty', NULL, NULL, 1, 0, CAST(N'2020-01-13T22:27:19.773' AS DateTime), CAST(N'2020-01-13T22:27:19.773' AS DateTime), CAST(N'2020-01-13T22:27:19.773' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', N'rbVZEB4KQ80pAOWgCAUiBVBOa/OSUVpDGk8ChGiIhuU=', 1, N'71cD+RlvmdOj/MpqQCp6fQ==', N'vladislavbelov0282@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-12-03T07:35:07.173' AS DateTime), CAST(N'2020-12-03T07:41:01.850' AS DateTime), CAST(N'2020-12-03T07:35:07.173' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'497b82eb-2f1f-410d-a71c-36b45111b74b', N'tKgc6n8h4SpetHuQB7vBCHUWpWyO0kkWLgFZxiO4LD4=', 1, N'wLI087K7rurp38k6qs2kdA==', N'mssqlanddotnet@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-03-31T09:56:45.163' AS DateTime), CAST(N'2020-03-31T09:56:45.163' AS DateTime), CAST(N'2020-03-31T09:56:45.163' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qghi81d22Wv3NNbidngvFaVD7Cn2KwsZZpVDbGVoKNk=', 1, N'nWfOG4Z4ZUzEftE5CNi2Mw==', N'kesha.tkachenko2017@mail.ru', NULL, NULL, 1, 0, CAST(N'2020-09-14T17:57:51.973' AS DateTime), CAST(N'2020-11-22T20:34:38.083' AS DateTime), CAST(N'2020-09-14T17:57:51.973' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'2e416d84-4e86-468a-8088-4d9a70ffb0de', N'1qVi3lCHBfY7U0x5zX6m9/8NYHqJ26bEUdR+ih3/m/8=', 1, N'HfVtgd/mfcwk9NGgA6zLag==', N'nnkkkn@ert.rt', NULL, NULL, 1, 0, CAST(N'2020-01-13T22:26:26.813' AS DateTime), CAST(N'2020-01-13T22:26:26.813' AS DateTime), CAST(N'2020-01-13T22:26:26.813' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'53446782-b6e0-43cf-a718-4e445e853160', N'9ELxxBzNJJ1xFKr2btLGEKFfSKRc9j84sgQroBs0POA=', 1, N'PSIdC42RZpDyZPLsv1yuEA==', N'kesha.tkachenko2017@mail.ru', NULL, NULL, 1, 0, CAST(N'2020-09-10T21:23:42.990' AS DateTime), CAST(N'2020-09-10T21:23:42.990' AS DateTime), CAST(N'2020-09-10T21:23:42.990' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'UefYQxgYhG5LF55T11vyijCIKuRYut3G/WnZxY0y9BI=', 1, N'gP5Mur5191AAjm2iSd6DJw==', N'Vb@intelligent365.ru', NULL, NULL, 1, 0, CAST(N'2020-01-24T19:42:41.040' AS DateTime), CAST(N'2020-01-25T09:11:31.830' AS DateTime), CAST(N'2020-01-24T19:42:41.040' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'eb192af4-6fa7-4f34-ac02-5058cc5d424b', N'ztGDhzDq5lyOhurrSPdMkaIa+ekB1emq154PMlSJkT4=', 1, N'pasMYkLdVfB0JHf+vejq/Q==', N'frba', NULL, NULL, 1, 0, CAST(N'2020-10-08T20:18:57.443' AS DateTime), CAST(N'2020-10-08T20:18:57.443' AS DateTime), CAST(N'2020-10-08T20:18:57.443' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'3b767454-13e2-4213-a8d4-51d5b07b5fb1', N'Eoen3cBV1Ozy3Rwlb1mtbaFz3lonuFqrGHBxD/gDVjU=', 1, N'4UGT2cYSDikPzRBwTZxl1Q==', N'ashfaqshaikh85@gmail.com', NULL, NULL, 1, 0, CAST(N'2019-09-16T07:48:57.050' AS DateTime), CAST(N'2019-09-16T07:48:57.050' AS DateTime), CAST(N'2019-09-16T07:48:57.050' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f95dea8f-3fae-4c54-be1d-572e5dfe9116', N'5SoJELyLeIksnDPNRaIzVoiCbf494/FUanpnTsKgnTg=', 1, N'TBLKsAOUNk4shiwM1QsxrA==', N'Fghуgg@ffh.ru', NULL, NULL, 1, 0, CAST(N'2019-10-02T21:34:44.667' AS DateTime), CAST(N'2019-10-02T21:34:44.667' AS DateTime), CAST(N'2019-10-02T21:34:44.667' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'b1e3c30f-91b1-48c1-a2e4-5c8cc7b75dc7', N'0FgbF9kMT73o0b2yClopwWlwg9M6yF8Kbt/lOx3DGZ0=', 1, N'Vr6pbjUR1QeUs0I+kKO8KQ==', N'nnn@ert.rt', NULL, NULL, 1, 0, CAST(N'2019-08-24T12:44:51.830' AS DateTime), CAST(N'2019-08-24T12:44:51.830' AS DateTime), CAST(N'2019-08-24T12:44:51.830' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'31c4e8bb-9c5b-45d7-8fa0-65c75f87e121', N'vQifheZwcFohTHemE2fz4VWZoV+MWKy/WOK0qC9j0BM=', 1, N'OopTnV8RRu5zRvUKSPKwQw==', N'kiberaleks@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-04-27T20:01:50.303' AS DateTime), CAST(N'2020-11-21T11:48:46.193' AS DateTime), CAST(N'2020-04-27T20:01:50.303' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 1, CAST(N'2020-11-21T11:48:46.200' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', N'6G8FZ5L8xP2k2Ic//JjYVzI2B9KPlp5oaNtSVwV4sCA=', 1, N'krHpQwIhU72Z8bLl+lnebw==', N'kiberaleks@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-25T07:23:31.887' AS DateTime), CAST(N'2020-11-21T11:47:48.350' AS DateTime), CAST(N'2020-01-25T07:23:31.887' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 4, CAST(N'2020-11-21T11:47:48.357' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'ee678bfb-bf49-4050-aad3-6c5025d3f0e5', N'8ECY6G7FmPdtryFnbIbOV6innMf1/dytOczm8tIWwyY=', 1, N'ZM7Ci7eOHbBoU2yIndBv8Q==', N'reyrsk@ya.ru', NULL, NULL, 1, 0, CAST(N'2020-07-08T08:35:05.923' AS DateTime), CAST(N'2020-07-08T08:35:05.923' AS DateTime), CAST(N'2020-07-08T08:35:05.923' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'c11636fe-d0d9-4a60-8647-6f00f6154c29', N'NvE/uVcJMQXJaOyr1WiuqGfEdGejN55Gi4SmViF07KU=', 1, N'+5C1dcMmt4qLlUFLOfu5Tw==', N'dfgdfg@sdfgsdf.gh', NULL, NULL, 1, 0, CAST(N'2019-05-29T23:27:42.610' AS DateTime), CAST(N'2019-05-29T23:27:42.610' AS DateTime), CAST(N'2019-05-29T23:27:42.610' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'V7+YpvAFuozFHLpnj6/zlgdsFcLmCeRmOa0vR/f6m8o=', 1, N'gWGDvyHxBId+N28ZdEwGyQ==', N'N.pavlov80@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-25T17:43:11.413' AS DateTime), CAST(N'2020-01-26T20:08:41.040' AS DateTime), CAST(N'2020-01-25T17:43:11.413' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'4d54d89b-7e4c-40a6-8638-739bdd618947', N'0YMhgD3+ahakqrhxs0AkSuGXEKHD9G9cMzdxo17Vrrg=', 1, N'OpTGBnuU0+56HnKRrWYHKQ==', N'lll@lll.ll', NULL, NULL, 1, 0, CAST(N'2020-03-08T11:19:37.117' AS DateTime), CAST(N'2020-03-08T11:19:37.117' AS DateTime), CAST(N'2020-03-08T11:19:37.117' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'K4kMwLhvh7mPX8+4Y19lfm1oUkPjscLnZ4Zj7Q3m7/Y=', 1, N'ho7gCpgxYuPDASuBXt7XOw==', N'mmm@mmm22.ru', NULL, NULL, 1, 0, CAST(N'2018-04-08T23:25:09.273' AS DateTime), CAST(N'2020-08-16T09:05:55.227' AS DateTime), CAST(N'2018-06-23T19:45:50.323' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'5ff870c8-71e7-4738-b7c0-81a3162a3cb0', N'bLtzyQkwfa8sQ5Cq0j5vcDIqe9AWa3yd9LGxZovqOas=', 1, N'eiyaTqHxU+AUo9VOn28kkw==', N'dennismen360@mail.ru', NULL, NULL, 1, 0, CAST(N'2020-01-25T17:53:36.757' AS DateTime), CAST(N'2020-01-25T17:53:36.757' AS DateTime), CAST(N'2020-01-25T17:53:36.757' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'037bc9a7-a702-4f15-9695-830d47fc9197', N'atSwyoDT2qRCCNqJiIeAorpxeu29Yx6ihDvHcevmXsE=', 1, N'3EmGttvBV8Vz9mjIEineCw==', N'laricevan9@gmail.ru', NULL, NULL, 1, 0, CAST(N'2020-01-25T14:00:24.023' AS DateTime), CAST(N'2020-01-30T03:03:44.933' AS DateTime), CAST(N'2020-01-25T14:00:24.023' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'a4dbb6d6-0937-49ca-a2dc-83c522007c61', N'9cc6cJyL5h5Rs6RpzGPqKGkP9TuPVOgyJ9klVet4Nss=', 1, N'rJT6PeyG3Bb4gqGKfRmgOw==', N'Fghghhg@ffh.ru', NULL, NULL, 1, 0, CAST(N'2019-09-23T16:26:06.307' AS DateTime), CAST(N'2019-10-04T14:02:15.157' AS DateTime), CAST(N'2019-09-23T16:26:06.307' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'26edc365-d524-48d2-b456-88abff129efd', N'jdwNp8Jxx6S12c/X0tBkQROCZcftuZlpxr2IrzuyV4Q=', 1, N'jvdX6MaecETShwJCsXiL+A==', N'gromi2k@yandex.ru', NULL, NULL, 1, 0, CAST(N'2020-01-25T20:14:13.203' AS DateTime), CAST(N'2020-01-25T20:14:13.203' AS DateTime), CAST(N'2020-01-25T20:14:13.203' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'17dd7a4a-66e6-47a2-ad13-89dba1ccadb7', N'V9cy74eYP2ZWN5Hp8Jw3pbTyX1Aej/2WkJjcrK+X+nE=', 1, N'NKHpz4rS7YFKK178Srr4dQ==', N'kdv12044@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-25T08:05:30.897' AS DateTime), CAST(N'2020-01-25T08:05:30.897' AS DateTime), CAST(N'2020-01-25T08:05:30.897' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'd0672d7a-632f-4901-a9d1-8b72e6c35869', N'oyBDw39YRMAxmH2LEjolwsHUa5iEL7h7WGYWkTF60ZY=', 1, N'TUFYq0b5WF9aN3QkrHMNBA==', N'maps.apihyd@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-04-17T08:28:05.117' AS DateTime), CAST(N'2020-04-17T08:28:05.117' AS DateTime), CAST(N'2020-04-17T08:28:05.117' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'cad96d26-bfd4-48a3-8999-8e18a4d02357', N'rkkH0jmikJKzcTQniW5qNtvXuMxIMUIEzgdBALqmCkA=', 1, N'8zROEh8wz5N+QNNk0cdAcw==', N'dmitriyraspel@yandex.ru', NULL, NULL, 1, 0, CAST(N'2019-08-24T19:38:17.910' AS DateTime), CAST(N'2019-08-24T19:38:17.910' AS DateTime), CAST(N'2019-08-24T19:38:17.910' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'1e256f7a-97fc-453a-9f0b-957c99c75b06', N'yFQ3gCYcF0hILmDvUve6mTj9nQkPKXPmSTileXxyfsg=', 1, N'a50gu+1zU4xb1A0g1sNNxw==', N'fasteat@outlook.com', NULL, NULL, 1, 0, CAST(N'2018-12-17T17:29:27.347' AS DateTime), CAST(N'2018-12-17T17:29:27.347' AS DateTime), CAST(N'2018-12-17T17:29:27.347' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', N'8r+FVERxNsOxxJ+0tdTPToKJmM5TZ5hevo1lQ6uMPrM=', 1, N'Q8v4P7xvl2MVTSWOKH9UjQ==', N'krasovteam@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-24T14:11:51.460' AS DateTime), CAST(N'2020-01-24T14:11:51.460' AS DateTime), CAST(N'2020-01-24T14:11:51.460' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'9350b6bd-62dc-4e69-86fc-abd4fdfed066', N'asfQu4VL/6/5n72TVlJOi2Odll6S7syOk0rgLIFx5Fg=', 1, N'jtEsGs4BjCa+uW8w7rir/g==', N'wwdw@iuy.ri', NULL, NULL, 1, 0, CAST(N'2019-08-24T12:50:19.137' AS DateTime), CAST(N'2019-08-24T12:50:19.137' AS DateTime), CAST(N'2019-08-24T12:50:19.137' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8c335406-4e98-462f-90ca-ac158cdd1142', N'dgYn3noeF43FDFOXaSZhu309RTqamWBBuiY+DDpE104=', 1, N'RaIpR9Sc1ujm+p6pNF8EbQ==', N'kantemir04111991@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-25T17:53:52.013' AS DateTime), CAST(N'2020-01-25T17:53:52.013' AS DateTime), CAST(N'2020-01-25T17:53:52.013' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'd9112c68-192f-40f5-b678-ad25e61d092e', N'JkueKEeFH7GdoW0Sx8wIpUejAQF4srT2THe8b79VE9s=', 1, N'px8Ps38hRy9/Bfs1rBkHmQ==', N'uiryu@wert.ty', NULL, NULL, 1, 0, CAST(N'2019-08-23T23:28:21.770' AS DateTime), CAST(N'2019-08-23T23:28:21.770' AS DateTime), CAST(N'2019-08-23T23:28:21.770' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'4f8e9d04-5c62-405a-8011-b207702f3b54', N'T1LqNOr4ZD8NzQrwsBOpxTLPGhQU6oUJw2yxegCX6TU=', 1, N'ytusKP4Ku8mfmJz/T6o1Zg==', N'qwer@wqert.er', NULL, NULL, 1, 0, CAST(N'2019-07-09T19:52:43.120' AS DateTime), CAST(N'2019-07-09T19:52:43.120' AS DateTime), CAST(N'2019-07-09T19:52:43.120' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'cn4l4Qs06IHsBkJ4VBE/xfjM3XUjZ+5sAzKxMuAQTH4=', 1, N'4VAbjgKtajo4zrsH7SOnwA==', N'uirrrryu@wert.ty', NULL, NULL, 1, 0, CAST(N'2019-11-16T12:48:33.113' AS DateTime), CAST(N'2019-12-28T10:26:17.660' AS DateTime), CAST(N'2019-11-16T12:48:33.113' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'ff342ff7-3798-4f20-8c15-bb16ad9e3100', N'zixvLyby3wiBgUnyxV1fW2HXivXoBZRwqr5bTc8+Lww=', 1, N'asGk1kaFC9oLXsyhSHstdA==', N'Wwweb.makc@yandex.ru', NULL, NULL, 1, 0, CAST(N'2020-03-18T19:07:34.260' AS DateTime), CAST(N'2020-03-18T19:07:34.260' AS DateTime), CAST(N'2020-03-18T19:07:34.260' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'e7bc0057-d3b9-4791-a9ea-c4589500ace9', N'nn4DaBiK9JGJ42+lvX1GhiG0wraJbEk9Av/bZMlCgnQ=', 1, N'z7vDzqgbpofd/2YDvpmV1A==', N'mathew.dubrovin@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-11-20T20:12:07.507' AS DateTime), CAST(N'2020-11-20T20:59:40.750' AS DateTime), CAST(N'2020-11-20T20:12:07.507' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'0677b5f2-2ec7-4bbe-89f7-c6ed48cb9dca', N'nBO/OK1zfEAVnVX7OT3zOmy0QyJrrbD5N3xBbE1BB0M=', 1, N'2rRrHpwIA6eR+WqFqgAWOA==', N'Freebar4ik@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-24T19:05:32.380' AS DateTime), CAST(N'2020-01-24T19:05:32.380' AS DateTime), CAST(N'2020-01-24T19:05:32.380' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'FCMEn4a0Jsl2XR67ifw25r2eRIw144Nb1+VM0h3sj7o=', 1, N'McDh7MOrDnDidp3JeX4cYg==', N'medved.solo@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-11T22:52:00.793' AS DateTime), CAST(N'2020-01-23T19:29:32.703' AS DateTime), CAST(N'2020-01-11T22:52:00.793' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'lbcI6wC3BxzEU/mTMsHmf1YsGqIJnSaiAkub5hwSs+M=', 1, N'Pa8hAmWrDNmxGZYdZwquvw==', N'solovievmaksim@mail.ru', NULL, NULL, 1, 0, CAST(N'2020-01-13T21:42:57.133' AS DateTime), CAST(N'2020-01-13T21:42:57.133' AS DateTime), CAST(N'2020-01-13T21:42:57.133' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f7db8012-d9f1-4cfd-b8c3-ce067edd6d19', N'WwyvJjyzLu2RFdZ7AN7YAkYbZf2TwQs9trDQsP8YL+c=', 1, N'sA+Tl8pAY2qfk5Os4fc0RQ==', N'newashington4@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-26T12:26:56.640' AS DateTime), CAST(N'2020-01-26T12:26:56.640' AS DateTime), CAST(N'2020-01-26T12:26:56.640' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'a52f6fd5-0b77-4345-b7e1-ce1ede063d64', N'9V4qDtuRfoSvARvG7KdhPIgolPJQ6yM/ecyhs8UvbT4=', 1, N'OGwN66VNlbzglrtI0nx6mA==', N'fghdfg@sdfg.er', NULL, NULL, 1, 0, CAST(N'2019-05-19T21:31:49.467' AS DateTime), CAST(N'2019-06-02T02:11:44.417' AS DateTime), CAST(N'2019-05-19T21:31:49.467' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'61066082-72b4-477f-92dc-d1af87de7de9', N'QlkaBrlStev4TbMoUuq+hIagTN6vzyUhakPBR2MpCq0=', 1, N'FjgoyPJWxE5jol9pJDbpQQ==', N'rrr@wertwqer.er', NULL, NULL, 1, 0, CAST(N'2020-04-28T23:15:07.523' AS DateTime), CAST(N'2020-04-28T23:15:24.427' AS DateTime), CAST(N'2020-04-28T23:15:07.523' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'cddd0879-5144-4527-a449-d39c7642aac5', N'l+Yu2WXCem9aUzIlcLnS76ynWUqQTTyaoDAc647x7t8=', 1, N'ZhV8vc40PrPycohdwtrEFA==', N'kkkhk@rty.er', NULL, NULL, 1, 0, CAST(N'2019-09-21T14:38:40.560' AS DateTime), CAST(N'2019-10-01T18:10:52.697' AS DateTime), CAST(N'2019-09-21T14:38:40.560' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f574ce33-7829-4678-81cb-d7daa7fe550b', N'+qTpRniYAXQBuyCPhiI9x2NIK3sTpSCdqH4uFYMSt9k=', 1, N'rx1v50qIjJHov/qTVCjBxg==', N'Fgh2242gg@ffh.ru', NULL, NULL, 1, 0, CAST(N'2019-09-27T13:36:12.427' AS DateTime), CAST(N'2019-09-27T13:36:12.427' AS DateTime), CAST(N'2019-09-27T13:36:12.427' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'f4b751df-6328-4553-8f4c-db280ef332d3', N'bYnO/asUBqWVAA7/dHz2nXtpiVZvIYZFPa+7Uf1QyFY=', 1, N'QvIR2dvkGtNlyi4dWUXc9A==', N'qwwwssdddqq@qqq.qw', NULL, NULL, 1, 0, CAST(N'2018-12-17T14:43:49.040' AS DateTime), CAST(N'2018-12-17T14:43:49.040' AS DateTime), CAST(N'2018-12-17T14:43:49.040' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'314bd290-5fc5-4a93-8131-db644b83aaed', N'vLHQgLJNtDkebbBSpdV+EcLArCtEYpmE7IlSrLPgwjs=', 1, N'7b8GeYa3FoIQBEJBU+XwUA==', N'qwer@wert.rt', NULL, NULL, 1, 0, CAST(N'2019-10-08T16:16:36.940' AS DateTime), CAST(N'2019-10-30T17:01:54.853' AS DateTime), CAST(N'2019-10-08T16:16:36.940' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'91dc9014-911a-43cf-b55f-dd4ace944035', N'JQh89muEYSoqn/7xd2qBBHH5oBMVkK8tvkH67W39Vpc=', 1, N'k4Usi1FKolzUjP/7m7JvGw==', N'wert@wert.rt', NULL, NULL, 1, 0, CAST(N'2019-10-03T09:48:59.873' AS DateTime), CAST(N'2019-10-04T09:54:08.947' AS DateTime), CAST(N'2019-10-03T09:48:59.873' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'J70bxu2LyeSPpVmARgFXNqIp0bPjjUZouQxZp9+N0x0=', 1, N'wgHFVvdCtKYLuYXG3kWv2g==', N'alex.pigalyov@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-11-27T21:52:39.733' AS DateTime), CAST(N'2020-11-30T21:42:20.957' AS DateTime), CAST(N'2020-11-27T21:52:39.733' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'023461b1-28b3-4e5b-b5bc-e2a179b1b032', N'Jte6S1uPDwh15NapvY7qn1XDp9FyQm5H3ZAXTDaqob4=', 1, N't9dyKsETOiNlj+fF+PMPog==', N'nadinaleksandr1@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-25T07:00:07.403' AS DateTime), CAST(N'2020-01-25T07:05:40.993' AS DateTime), CAST(N'2020-01-25T07:00:07.403' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'996da0e7-d189-47a3-8436-e54b1572872d', N'WjTBu9/DUvLq0GMGriWcGFTnfQP5Pz+yUZ6wreHhzYk=', 1, N'63SFwiaoJG9ujvkZBPVyrQ==', N'egorigorevichk@mail.ru', NULL, NULL, 1, 0, CAST(N'2020-01-27T14:21:36.233' AS DateTime), CAST(N'2020-01-27T14:21:36.233' AS DateTime), CAST(N'2020-01-27T14:21:36.233' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'20a94868-76d0-456d-8268-e7c1318f03d3', N'CtoEgdB36ixKYO5lBR7rdOh8htgWelow8rwQElS/z90=', 1, N'ChNt8aptlfhHn2jCkayfqg==', N'qwer@wqрttпert.er', NULL, NULL, 1, 0, CAST(N'2019-07-26T14:15:03.497' AS DateTime), CAST(N'2019-07-26T14:15:03.497' AS DateTime), CAST(N'2019-07-26T14:15:03.497' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'dc40c4f1-f346-48fe-b4b3-fc629df690ff', N'h9T5e1Hb3xCi2invLmVD+WPYJoITse7Yc2lFrtGnzpA=', 1, N'rqshTAvZXAz2IWdyx8T/KQ==', N'Fgh@ffh.ruh', NULL, NULL, 1, 0, CAST(N'2019-10-02T19:18:03.867' AS DateTime), CAST(N'2019-10-02T19:18:03.867' AS DateTime), CAST(N'2019-10-02T19:18:03.867' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'+2IHbiXLSr35HwtT4Kn4YKzxP9hiKDo6ANJrOrYVDSI=', 1, N'jkW+8yikpya5omgj3fdMXA==', N'miss_sweetlana@icloud.com', NULL, NULL, 1, 0, CAST(N'2020-01-20T13:11:31.657' AS DateTime), CAST(N'2020-01-22T08:57:29.690' AS DateTime), CAST(N'2020-01-20T13:11:31.657' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'9891d3d6-e7eb-4911-98f5-fdde0c32b9cf', N'fDngDol4sHu1R29VcKwNyBs3sqJxrxaxGsrOpJ+2A5A=', 1, N'lkttDWxrrdyWTueHvSlqMg==', N'maryolovo@gmail.com', NULL, NULL, 1, 0, CAST(N'2020-01-26T19:51:52.687' AS DateTime), CAST(N'2020-02-07T02:52:06.577' AS DateTime), CAST(N'2020-01-26T19:51:52.687' AS DateTime), CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[NewAezakmi] ON 
GO
INSERT [dbo].[NewAezakmi] ([id], [Text], [Date], [Authorld], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-11-13T06:38:20.100' AS DateTime), N'8710f37b-2be9-4b58-999c-c387f98086da', CAST(N'2020-11-13T06:38:20.100' AS DateTime), 1)
GO
INSERT [dbo].[NewAezakmi] ([id], [Text], [Date], [Authorld], [CreateDate], [Active]) VALUES (2, N'Вторая ность ', CAST(N'2020-11-13T06:38:49.573' AS DateTime), N'8710f37b-2be9-4b58-999c-c387f98086da', CAST(N'2020-11-13T06:38:49.573' AS DateTime), 0)
GO
INSERT [dbo].[NewAezakmi] ([id], [Text], [Date], [Authorld], [CreateDate], [Active]) VALUES (4, N'Работа окончена', CAST(N'2020-11-13T07:57:45.827' AS DateTime), N'8710f37b-2be9-4b58-999c-c387f98086da', CAST(N'2020-11-13T07:57:45.827' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewAezakmi] OFF
GO
SET IDENTITY_INSERT [dbo].[News] ON 
GO
INSERT [dbo].[News] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Запуст проекта! Открытая регистрация пользователей.', CAST(N'2019-05-01T08:30:00.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2019-01-01T08:30:00.000' AS DateTime), 1)
GO
INSERT [dbo].[News] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'Стала доступна возможность пополнять баланс и производить покупку и продажу токенов. Пополнение через сервис Qiwi с возможностью оплаты по пластиковой карте. Так же доступна возможность мгновенного вывода средств.', CAST(N'2019-12-29T01:23:26.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2019-12-29T01:23:26.750' AS DateTime), 1)
GO
INSERT [dbo].[News] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'С сегодняшнего дня стоимость токенов увеличивается постояно по ставке 30% годовых. В сутки стоимость растет на 0.07191%.', CAST(N'2020-01-19T07:49:13.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2020-01-19T07:49:13.180' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[News] OFF
GO
SET IDENTITY_INSERT [dbo].[News_towardsbackwards] ON 
GO
INSERT [dbo].[News_towardsbackwards] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-11-21T17:15:39.583' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-21T17:15:39.583' AS DateTime), 1)
GO
INSERT [dbo].[News_towardsbackwards] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (6, N'Вторая новость', CAST(N'2020-11-22T11:19:50.780' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-22T11:19:50.780' AS DateTime), 1)
GO
INSERT [dbo].[News_towardsbackwards] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (8, N'Третья новость', CAST(N'2020-11-22T11:20:42.337' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-22T11:20:42.337' AS DateTime), 1)
GO
INSERT [dbo].[News_towardsbackwards] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (9, N'Новость о распродаже', CAST(N'2020-11-22T11:20:47.420' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-22T11:20:47.420' AS DateTime), 1)
GO
INSERT [dbo].[News_towardsbackwards] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (10, N'Новость о новых фичах', CAST(N'2020-11-22T11:21:03.617' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-22T11:21:03.617' AS DateTime), 1)
GO
INSERT [dbo].[News_towardsbackwards] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (11, N'Новость о новых поступлениях', CAST(N'2020-11-22T11:21:19.057' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-22T11:21:19.057' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[News_towardsbackwards] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsAlexPigalyov] ON 
GO
INSERT [dbo].[NewsAlexPigalyov] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-11-25T02:20:46.660' AS DateTime), N'c4977904-dd9f-4404-aacf-e30c39f22a18', CAST(N'2020-11-25T02:20:46.660' AS DateTime), NULL)
GO
INSERT [dbo].[NewsAlexPigalyov] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Вторая новость', CAST(N'2020-11-25T02:21:34.603' AS DateTime), N'c4977904-dd9f-4404-aacf-e30c39f22a18', CAST(N'2020-11-25T02:21:34.603' AS DateTime), NULL)
GO
INSERT [dbo].[NewsAlexPigalyov] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (4, N'Первая активная новость', CAST(N'2020-11-25T03:08:26.740' AS DateTime), N'c4977904-dd9f-4404-aacf-e30c39f22a18', CAST(N'2020-11-25T03:08:26.740' AS DateTime), 1)
GO
INSERT [dbo].[NewsAlexPigalyov] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (5, N'Вторая активная новость', CAST(N'2020-11-25T02:21:34.603' AS DateTime), N'c4977904-dd9f-4404-aacf-e30c39f22a18', CAST(N'2020-11-25T03:11:27.967' AS DateTime), 1)
GO
INSERT [dbo].[NewsAlexPigalyov] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (6, N'Третья активная новость', CAST(N'2020-11-25T03:11:39.077' AS DateTime), N'c4977904-dd9f-4404-aacf-e30c39f22a18', CAST(N'2020-11-25T03:11:39.077' AS DateTime), 1)
GO
INSERT [dbo].[NewsAlexPigalyov] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (7, N'Новость которую мы создали на фронте', CAST(N'2020-11-26T00:57:35.000' AS DateTime), N'c4977904-dd9f-4404-aacf-e30c39f22a18', CAST(N'2020-11-26T00:57:35.347' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsAlexPigalyov] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsAntares] ON 
GO
INSERT [dbo].[NewsAntares] ([Id], [text], [date], [authorId], [createDate], [active]) VALUES (1, N'Первая новость', CAST(N'2020-11-21T14:57:38.277' AS DateTime), N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', CAST(N'2020-11-21T14:57:38.277' AS DateTime), 1)
GO
INSERT [dbo].[NewsAntares] ([Id], [text], [date], [authorId], [createDate], [active]) VALUES (2, N'Вторая новость ', CAST(N'2020-11-21T19:06:56.203' AS DateTime), N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', CAST(N'2020-11-21T19:06:56.203' AS DateTime), 1)
GO
INSERT [dbo].[NewsAntares] ([Id], [text], [date], [authorId], [createDate], [active]) VALUES (3, N'Третья запись ', CAST(N'2020-11-21T19:07:15.953' AS DateTime), N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', CAST(N'2020-11-21T19:07:15.953' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsAntares] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsAzizjan] ON 
GO
INSERT [dbo].[NewsAzizjan] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-11-12T18:17:12.530' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-12T18:17:12.530' AS DateTime), 1)
GO
INSERT [dbo].[NewsAzizjan] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'Вторая новость', CAST(N'2020-11-12T18:17:27.233' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-12T18:17:27.233' AS DateTime), 1)
GO
INSERT [dbo].[NewsAzizjan] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Котик ест блинчики', CAST(N'2020-11-12T18:20:41.443' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-12T18:20:41.443' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsAzizjan] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsBatrebleSs] ON 
GO
INSERT [dbo].[NewsBatrebleSs] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-11-23T21:20:39.080' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-23T21:20:39.080' AS DateTime), 1)
GO
INSERT [dbo].[NewsBatrebleSs] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Вторвая новость', CAST(N'2020-11-23T21:43:05.380' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-23T21:43:05.380' AS DateTime), 1)
GO
INSERT [dbo].[NewsBatrebleSs] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (4, N'НиЧЕго не поНяТно', CAST(N'2020-11-23T21:48:19.857' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-23T21:48:19.857' AS DateTime), 1)
GO
INSERT [dbo].[NewsBatrebleSs] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (5, N'Физика для мудаков', CAST(N'2020-11-23T21:49:34.063' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-23T21:49:34.063' AS DateTime), 1)
GO
INSERT [dbo].[NewsBatrebleSs] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (6, N'бездарный ахах', CAST(N'2020-11-23T21:51:47.693' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-23T21:51:47.693' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsBatrebleSs] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsEducation] ON 
GO
INSERT [dbo].[NewsEducation] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-11-10T13:00:07.760' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-10T13:00:07.760' AS DateTime), 1)
GO
INSERT [dbo].[NewsEducation] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'Вторая новость', CAST(N'2020-11-10T13:16:19.970' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-10T13:16:19.970' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsEducation] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsEoll73] ON 
GO
INSERT [dbo].[NewsEoll73] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'First News', CAST(N'2020-11-22T14:04:41.060' AS DateTime), N'906588b4-25c6-4bde-9a2a-2478610203bb', CAST(N'2020-11-22T14:04:41.060' AS DateTime), 1)
GO
INSERT [dbo].[NewsEoll73] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Second News', CAST(N'2020-11-22T15:11:55.287' AS DateTime), N'906588b4-25c6-4bde-9a2a-2478610203bb', CAST(N'2020-11-22T15:11:55.287' AS DateTime), 1)
GO
INSERT [dbo].[NewsEoll73] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (4, N'new News', CAST(N'2020-11-22T15:12:32.283' AS DateTime), N'906588b4-25c6-4bde-9a2a-2478610203bb', CAST(N'2020-11-22T15:12:32.283' AS DateTime), 1)
GO
INSERT [dbo].[NewsEoll73] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (5, N'News About MathWeySun', CAST(N'2020-11-22T15:13:49.260' AS DateTime), N'906588b4-25c6-4bde-9a2a-2478610203bb', CAST(N'2020-11-22T15:13:49.260' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsEoll73] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsGGdotNET] ON 
GO
INSERT [dbo].[NewsGGdotNET] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'Первая новость', CAST(N'2020-11-12T16:59:59.230' AS DateTime), N'0082479a-19e3-4846-a681-60666b4c9860', CAST(N'2020-11-12T16:59:59.230' AS DateTime), 1)
GO
INSERT [dbo].[NewsGGdotNET] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Вторая новость', CAST(N'2020-11-12T17:46:56.160' AS DateTime), N'0082479a-19e3-4846-a681-60666b4c9860', CAST(N'2020-11-12T17:46:56.160' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsGGdotNET] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsGodnebeles] ON 
GO
INSERT [dbo].[NewsGodnebeles] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'The first News', CAST(N'2021-02-27T07:44:00.627' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2021-02-27T07:44:00.627' AS DateTime), 1)
GO
INSERT [dbo].[NewsGodnebeles] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (6, N'The second News', CAST(N'2021-02-27T08:31:37.293' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2021-02-27T08:31:37.293' AS DateTime), 1)
GO
INSERT [dbo].[NewsGodnebeles] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (7, N'The third News', CAST(N'2021-02-27T08:33:51.560' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2021-02-27T08:33:51.560' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsGodnebeles] OFF
GO
SET IDENTITY_INSERT [dbo].[Newsillfyar] ON 
GO
INSERT [dbo].[Newsillfyar] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'новость1', CAST(N'2021-01-16T19:34:38.680' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2021-01-16T19:34:38.680' AS DateTime), 1)
GO
INSERT [dbo].[Newsillfyar] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'новость2', CAST(N'2021-01-16T20:19:57.900' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2021-01-16T20:19:57.900' AS DateTime), 1)
GO
INSERT [dbo].[Newsillfyar] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (4, N'новость3', CAST(N'2021-01-16T20:20:04.290' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2021-01-16T20:20:04.290' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[Newsillfyar] OFF
GO
INSERT [dbo].[NewsIlya] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'1', CAST(N'2020-11-12T22:21:31.977' AS DateTime), N'd605cfec-b531-4b21-a58c-074b035402af', CAST(N'2020-11-12T22:21:31.977' AS DateTime), 1)
GO
INSERT [dbo].[NewsIlya] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'2', CAST(N'2020-11-12T22:21:47.807' AS DateTime), N'd605cfec-b531-4b21-a58c-074b035402af', CAST(N'2020-11-12T22:21:47.807' AS DateTime), 1)
GO
INSERT [dbo].[NewsIlya] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'QQQQQQQQQQQQQQQQQQ', CAST(N'2020-11-12T22:22:05.773' AS DateTime), N'd605cfec-b531-4b21-a58c-074b035402af', CAST(N'2020-11-12T22:22:05.773' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsMrshkVV] ON 
GO
INSERT [dbo].[NewsMrshkVV] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (11, N'Initial', CAST(N'2020-11-20T11:34:50.970' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-20T11:34:50.970' AS DateTime), 1)
GO
INSERT [dbo].[NewsMrshkVV] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (14, N'Свежайшая новость', CAST(N'2020-11-20T12:22:06.913' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-20T12:22:06.913' AS DateTime), 1)
GO
INSERT [dbo].[NewsMrshkVV] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (15, N'Еще свежее. Прямо с магазина', CAST(N'2020-11-20T12:22:30.980' AS DateTime), N'bd4551af-fc28-4b85-b147-20a051676b21', CAST(N'2020-11-20T12:22:30.980' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsMrshkVV] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsRaspel] ON 
GO
INSERT [dbo].[NewsRaspel] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Новость 1', CAST(N'2020-10-11T18:00:38.063' AS DateTime), N'a08d3f83-1ac9-4b75-bfba-0c5a84e178c4', CAST(N'2020-10-11T18:00:38.063' AS DateTime), 1)
GO
INSERT [dbo].[NewsRaspel] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'Новость 2', CAST(N'2020-10-11T18:00:55.317' AS DateTime), N'a08d3f83-1ac9-4b75-bfba-0c5a84e178c4', CAST(N'2020-10-11T18:00:55.317' AS DateTime), 1)
GO
INSERT [dbo].[NewsRaspel] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Новость 3', CAST(N'2020-10-11T18:01:23.377' AS DateTime), N'a08d3f83-1ac9-4b75-bfba-0c5a84e178c4', CAST(N'2020-10-11T18:01:23.377' AS DateTime), 1)
GO
INSERT [dbo].[NewsRaspel] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (4, N'Тестовая Новость', CAST(N'2020-10-11T19:58:29.980' AS DateTime), N'a08d3f83-1ac9-4b75-bfba-0c5a84e178c4', CAST(N'2020-10-11T19:58:29.980' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsRaspel] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsShCodder] ON 
GO
INSERT [dbo].[NewsShCodder] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (2, N'Добавлена страница новостей', CAST(N'2020-11-16T01:04:44.317' AS DateTime), N'1e256f7a-97fc-453a-9f0b-957c99c75b06', CAST(N'2020-11-16T01:04:44.317' AS DateTime), 1)
GO
INSERT [dbo].[NewsShCodder] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (3, N'Выгружен инит скрипт', CAST(N'2020-11-16T01:05:20.073' AS DateTime), N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', CAST(N'2020-11-16T01:05:20.073' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsShCodder] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsVark] ON 
GO
INSERT [dbo].[NewsVark] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'ЦБ РФ принял решение сохранить ключевую ставку на уровне 4,25% годовых. Инфляция складывается в соответствии с прогнозом и по итогам 2020 года ожидается в интервале 3,9–4,2%, но инфляционные ожидания выросли, ухудшается эпидемиологическая обстановка, и ситуация на внешних рынках остается неустойчивой.', CAST(N'2020-11-08T08:30:00.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2020-11-08T20:43:27.313' AS DateTime), 1)
GO
INSERT [dbo].[NewsVark] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (7, N'Американские СМИ объявили о победе Байдена на выборах. Он получил 273 голоса выборщиков', CAST(N'2020-11-08T07:49:13.000' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2020-11-08T20:46:11.093' AS DateTime), 1)
GO
INSERT [dbo].[NewsVark] ([Id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (9, N'Разработчик BioWare в субботу заявил о том, что намеревается перезапустить трилогию Mass Effect, а также добавить к ней четвертую игру, работа над которой идет полным ходом. Теперь коллекция игр с улучшенной графикой выйдет под названием Mass Effect Legendary Edition.
Источник: https://discover24.ru/2020/11/bioware-anonsirovala-mass-effect-legendary-edition-i-novuyu-mass-effect/', CAST(N'2020-11-08T20:50:19.557' AS DateTime), N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', CAST(N'2020-11-08T20:50:19.557' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsVark] OFF
GO
SET IDENTITY_INSERT [dbo].[NewsVlad] ON 
GO
INSERT [dbo].[NewsVlad] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (1, N'Первая новость', CAST(N'2020-12-03T09:14:02.320' AS DateTime), N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', CAST(N'2020-12-03T09:14:02.320' AS DateTime), 1)
GO
INSERT [dbo].[NewsVlad] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (16, N'Вторая новость', CAST(N'2020-12-03T11:15:43.233' AS DateTime), N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', CAST(N'2020-12-03T11:15:43.233' AS DateTime), 1)
GO
INSERT [dbo].[NewsVlad] ([id], [Text], [Date], [AuthorId], [CreateDate], [Active]) VALUES (17, N'Третья новость', CAST(N'2020-12-03T11:18:02.503' AS DateTime), N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', CAST(N'2020-12-03T11:18:02.503' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[NewsVlad] OFF
GO
SET IDENTITY_INSERT [dbo].[Operations] ON 
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3, N'a52f6fd5-0b77-4345-b7e1-ce1ede063d64', 0, 14, N'Учетная запись создана.', CAST(N'2019-05-20T00:31:49.747' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (4, N'c11636fe-d0d9-4a60-8647-6f00f6154c29', 0, 14, N'Учетная запись создана.', CAST(N'2019-05-30T02:27:42.690' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (5, N'b98b7ebc-4d5e-405b-88d8-087421c50b8e', 0, 14, N'Учетная запись создана.', CAST(N'2019-06-01T19:02:48.493' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (6, N'4f8e9d04-5c62-405a-8011-b207702f3b54', 0, 14, N'Учетная запись создана.', CAST(N'2019-07-09T22:52:43.370' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (7, N'90553147-77ee-4561-b0f7-1f239afac377', 0, 14, N'Учетная запись создана.', CAST(N'2019-07-09T23:09:44.237' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (8, N'20a94868-76d0-456d-8268-e7c1318f03d3', 0, 14, N'Учетная запись создана.', CAST(N'2019-07-26T17:15:03.763' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (9, N'd9112c68-192f-40f5-b678-ad25e61d092e', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24T02:28:22.043' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (10, N'f42ba606-48bf-45ef-9ea4-1ee8c44add71', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24T02:32:27.477' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (11, N'b1e3c30f-91b1-48c1-a2e4-5c8cc7b75dc7', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24T15:44:52.577' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (12, N'9350b6bd-62dc-4e69-86fc-abd4fdfed066', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24T15:50:19.357' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (13, N'cad96d26-bfd4-48a3-8999-8e18a4d02357', 0, 14, N'Учетная запись создана.', CAST(N'2019-08-24T22:38:18.253' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (14, N'3b767454-13e2-4213-a8d4-51d5b07b5fb1', 0, 14, N'Учетная запись создана.', CAST(N'2019-09-16T10:48:57.470' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (15, N'cddd0879-5144-4527-a449-d39c7642aac5', 0, 14, N'Учетная запись создана.', CAST(N'2019-09-21T17:38:40.900' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (16, N'a4dbb6d6-0937-49ca-a2dc-83c522007c61', 0, 14, N'Учетная запись создана.', CAST(N'2019-09-23T19:26:06.647' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (17, N'f574ce33-7829-4678-81cb-d7daa7fe550b', 0, 14, N'Учетная запись создана.', CAST(N'2019-09-27T16:36:12.683' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (18, N'dc40c4f1-f346-48fe-b4b3-fc629df690ff', 0, 14, N'Учетная запись создана.', CAST(N'2019-10-02T22:18:04.197' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (19, N'f95dea8f-3fae-4c54-be1d-572e5dfe9116', 0, 14, N'Учетная запись создана.', CAST(N'2019-10-03T00:34:45.037' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (20, N'91dc9014-911a-43cf-b55f-dd4ace944035', 0, 14, N'Учетная запись создана.', CAST(N'2019-10-03T12:49:00.247' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (21, N'314bd290-5fc5-4a93-8131-db644b83aaed', 0, 14, N'Учетная запись создана.', CAST(N'2019-10-08T19:16:37.297' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (22, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-10-28T05:10:59.307' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (23, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-10-28T05:11:02.130' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (24, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 500, 14, N'Покупка 500 токенов на сумму 50.', CAST(N'2019-10-28T05:11:10.727' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (25, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Покупка 100 токенов на сумму 10.', CAST(N'2019-10-28T05:11:36.043' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (26, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-10-28T05:11:37.230' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (27, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-10-28T05:11:46.513' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (28, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, 14, N'Продажа 10 токенов на сумму 1.', CAST(N'2019-10-28T05:11:50.990' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (29, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100.', CAST(N'2019-10-28T05:11:56.870' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (30, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100.', CAST(N'2019-10-28T05:12:04.357' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1019, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', 0, 14, N'Учетная запись создана.', CAST(N'2019-11-16T15:48:33.407' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1020, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-11-16T16:47:39.187' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1021, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100.', CAST(N'2019-11-16T16:47:52.090' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1022, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Продажа 100 токенов на сумму 10.', CAST(N'2019-11-16T16:47:57.487' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1023, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100.', CAST(N'2019-11-16T16:48:02.730' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1024, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-11-16T16:48:05.740' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1025, N'709c2b20-4bb0-4369-bd80-b53ed855eb19', 2, 1, N'Пополнение баланса на сумму 2 р. Способ: ''Qiwi''.', CAST(N'2019-12-29T00:34:32.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1026, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4, 1, N'Пополнение баланса на сумму 4 р. Способ: ''Qiwi''.', CAST(N'2019-12-29T00:52:13.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1027, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-12-29T01:07:00.667' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1028, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2019-12-29T01:07:04.137' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1029, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Покупка 100 токенов на сумму 10.', CAST(N'2019-12-29T01:07:38.277' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1030, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100.', CAST(N'2019-12-29T01:07:44.223' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1031, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2020-01-03T21:45:23.123' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1032, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2020-01-03T21:45:25.103' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1033, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -200, 15, N'Запрос вывода на сумму 200 р. Способ: Qiwi. Номер (счет): +79686399088', CAST(N'2020-01-07T23:06:23.363' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1034, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -10, 15, N'Запрос вывода на сумму 10 р. Способ: Qiwi. Номер (счет): +79686399088', CAST(N'2020-01-07T23:09:28.823' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1035, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -2, 15, N'Запрос вывода на сумму 2 р. Способ: Qiwi. Номер (счет): +79686399088', CAST(N'2020-01-07T23:12:19.387' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1036, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -1, 15, N'Запрос вывода на сумму 1 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-01-08T00:06:41.380' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1037, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, 14, N'Покупка 10 токенов на сумму 1.', CAST(N'2020-01-08T02:32:20.143' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1038, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, 14, N'Покупка 10 токенов на сумму 1.', CAST(N'2020-01-08T02:33:52.300' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1039, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10, 14, N'Покупка 10 токенов на сумму 1.', CAST(N'2020-01-08T02:34:03.257' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1040, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100.', CAST(N'2020-01-08T02:34:11.397' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1041, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 50, 14, N'Продажа 50 токенов на сумму 5.', CAST(N'2020-01-08T02:34:17.763' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1042, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-12T01:52:01.573' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1043, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 200, 1, N'Пополнение баланса на сумму 200 р. Способ: ''Qiwi''.', CAST(N'2020-01-12T01:54:19.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1044, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2020-01-14T00:20:17.110' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1045, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-14T00:42:57.337' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1046, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-01-14T00:44:17.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1047, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-01-14T00:44:17.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1048, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 200, 1, N'Пополнение баланса на сумму 200 р. Способ: ''Qiwi''.', CAST(N'2020-01-12T01:54:19.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1049, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 200, 1, N'Пополнение баланса на сумму 200 р. Способ: ''Qiwi''.', CAST(N'2020-01-12T01:54:19.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1050, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-01-14T00:44:17.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1051, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 200, 1, N'Пополнение баланса на сумму 200 р. Способ: ''Qiwi''.', CAST(N'2020-01-12T01:54:19.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1052, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-01-14T00:44:17.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1053, N'2e416d84-4e86-468a-8088-4d9a70ffb0de', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-14T01:26:27.060' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1054, N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-14T01:27:20.257' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1055, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 1000, 14, N'Покупка 1000 токенов на сумму 100.', CAST(N'2020-01-14T01:39:34.657' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1056, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -2, 15, N'Запрос вывода на сумму 2 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-01-14T03:06:36.040' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1057, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20, 14, N'Покупка 20 токенов на сумму 2.', CAST(N'2020-01-14T08:33:17.050' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1058, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1000.', CAST(N'2020-01-16T00:11:41.537' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1059, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1000.', CAST(N'2020-01-16T00:11:46.280' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1060, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 2000, 14, N'Покупка 2000 токенов на сумму 200.', CAST(N'2020-01-16T00:13:25.870' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1061, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1000,7191.', CAST(N'2020-01-19T07:21:27.920' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1062, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 500,35955.', CAST(N'2020-01-19T20:32:58.513' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1063, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20000, 14, N'Покупка 20000 токенов на сумму 2001,4382.', CAST(N'2020-01-19T20:33:07.983' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1064, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-20T16:11:32.373' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1065, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 300, 1, N'Пополнение баланса на сумму 300 р. Способ: ''Qiwi''.', CAST(N'2020-01-20T16:14:15.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1066, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,287950411653.', CAST(N'2020-01-22T08:00:09.540' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1067, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 501,439752058264.', CAST(N'2020-01-22T08:00:21.350' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1068, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1002,87950411653.', CAST(N'2020-01-22T08:00:37.213' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1069, N'd605cfec-b531-4b21-a58c-074b035402af', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-22T10:56:14.877' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1070, N'd605cfec-b531-4b21-a58c-074b035402af', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-01-22T11:03:38.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1071, N'd605cfec-b531-4b21-a58c-074b035402af', 996, 14, N'Покупка 996 токенов на сумму 99,8867986100062.', CAST(N'2020-01-22T11:32:56.987' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1072, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 2990, 14, N'Покупка 2990 токенов на сумму 299,860971730842.', CAST(N'2020-01-22T13:38:11.927' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1073, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,383423876644.', CAST(N'2020-01-23T08:02:20.363' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1074, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Продажа 1000 токенов на сумму 100,383590319982.', CAST(N'2020-01-23T08:05:17.910' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1075, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Продажа 100 токенов на сумму 10,0383600015711.', CAST(N'2020-01-23T08:05:36.280' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1076, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 501,918117235272.', CAST(N'2020-01-23T08:06:01.927' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1077, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,45256626981.', CAST(N'2020-01-24T06:59:07.923' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1078, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2000, 14, N'Покупка 2000 токенов на сумму 200,90516973115.', CAST(N'2020-01-24T06:59:30.280' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1079, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 502,263017306702.', CAST(N'2020-01-24T06:59:53.413' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1080, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 200, 14, N'Покупка 200 токенов на сумму 20,0905224710122.', CAST(N'2020-01-24T07:00:04.787' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1081, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1004,5262205748.', CAST(N'2020-01-24T07:00:16.457' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1082, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4000, 14, N'Покупка 4000 токенов на сумму 401,810637000354.', CAST(N'2020-01-24T07:01:02.817' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1083, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1, 14, N'Покупка 1 токенов на сумму 0,100452669761043.', CAST(N'2020-01-24T07:01:15.110' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1084, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2000, 14, N'Покупка 2000 токенов на сумму 200,90545109991.', CAST(N'2020-01-24T07:02:24.327' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1085, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-24T17:11:52.117' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1086, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-01-24T17:13:57.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1087, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 995, 14, N'Покупка 995 токенов на сумму 99,9875014876541.', CAST(N'2020-01-24T19:49:37.463' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1088, N'0677b5f2-2ec7-4bbe-89f7-c6ed48cb9dca', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-24T22:05:33.097' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1089, N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-24T22:42:41.183' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1090, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1005,29693682687.', CAST(N'2020-01-25T08:39:53.977' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1091, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 50000, 14, N'Покупка 50000 токенов на сумму 5026,48525053223.', CAST(N'2020-01-25T08:40:07.610' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1092, N'023461b1-28b3-4e5b-b5bc-e2a179b1b032', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T10:00:07.653' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1093, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T10:23:32.010' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1094, N'17dd7a4a-66e6-47a2-ad13-89dba1ccadb7', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T11:05:31.020' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1095, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 200, 1, N'Пополнение баланса на сумму 200 р. Способ: ''Qiwi''.', CAST(N'2020-01-25T12:32:45.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1096, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,976370266703.', CAST(N'2020-01-25T12:36:05.280' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1097, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,976391191057.', CAST(N'2020-01-25T12:36:18.620' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1098, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', -200, 15, N'Запрос вывода на сумму 200 р. Способ: Qiwi. Номер (счет): +79508631455', CAST(N'2020-01-25T12:37:56.057' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1099, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 200, 1, N'Пополнение баланса на сумму 200 р. Способ: ''Qiwi''.', CAST(N'2020-01-25T12:40:08.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1100, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,976824164216.', CAST(N'2020-01-25T12:40:47.860' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1101, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,976835431175.', CAST(N'2020-01-25T12:40:54.473' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1102, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,976851526832.', CAST(N'2020-01-25T12:41:04.943' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1103, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,976861184226.', CAST(N'2020-01-25T12:41:10.200' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1104, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,97688532771.', CAST(N'2020-01-25T12:41:25.690' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1105, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,976894985104.', CAST(N'2020-01-25T12:41:31.947' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1106, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,976904642498.', CAST(N'2020-01-25T12:41:37.763' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1107, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,976915909458.', CAST(N'2020-01-25T12:41:44.940' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1108, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,976925566852.', CAST(N'2020-01-25T12:41:50.337' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1109, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,97693361468.', CAST(N'2020-01-25T12:41:55.533' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1110, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Покупка 1989 токенов на сумму 199,976951319902.', CAST(N'2020-01-25T12:42:06.750' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1111, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1989, 14, N'Продажа 1989 токенов на сумму 199,976957758165.', CAST(N'2020-01-25T12:42:10.947' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1112, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', -100, 15, N'Запрос вывода на сумму 100 р. Способ: Qiwi. Номер (счет): +79508631455', CAST(N'2020-01-25T12:42:58.073' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1113, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', -99.98, 15, N'Запрос вывода на сумму 49 р. Способ: BankCard. Номер (счет): 5321300345885532', CAST(N'2020-01-25T12:46:04.243' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1114, N'037bc9a7-a702-4f15-9695-830d47fc9197', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T17:00:24.727' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1115, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,562542992702.', CAST(N'2020-01-25T19:56:24.473' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1116, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 3000, 14, N'Покупка 3000 токенов на сумму 301,687641119072.', CAST(N'2020-01-25T19:56:29.107' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1117, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1005,64381992636.', CAST(N'2020-01-25T20:34:16.660' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1118, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T20:43:11.617' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1119, N'5ff870c8-71e7-4738-b7c0-81a3162a3cb0', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T20:53:36.897' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1120, N'8c335406-4e98-462f-90ca-ac158cdd1142', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T20:53:52.153' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1121, N'26edc365-d524-48d2-b456-88abff129efd', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-25T23:14:14.123' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1122, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 503,023862547997.', CAST(N'2020-01-26T09:37:16.967' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1123, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2000, 14, N'Покупка 2000 токенов на сумму 201,209588745436.', CAST(N'2020-01-26T09:37:43.657' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1124, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1006,20286849819.', CAST(N'2020-01-26T14:56:34.997' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1125, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 503,101466643591.', CAST(N'2020-01-26T14:56:42.317' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1126, N'f7db8012-d9f1-4cfd-b8c3-ce067edd6d19', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-26T15:26:56.830' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1127, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,621905806951.', CAST(N'2020-01-26T15:29:53.827' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1128, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 2000, 1, N'Пополнение баланса на сумму 2000 р. Способ: ''Qiwi''.', CAST(N'2020-01-26T18:14:11.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1129, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,630730710445.', CAST(N'2020-01-26T18:31:29.413' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1130, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 500, 14, N'Покупка 500 токенов на сумму 50,3153681900697.', CAST(N'2020-01-26T18:31:36.713' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1131, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 19874, 14, N'Покупка 19874 токенов на сумму 1999,93886056304.', CAST(N'2020-01-26T18:35:20.417' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1132, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 500, 14, N'Покупка 500 токенов на сумму 50,3162911420554.', CAST(N'2020-01-26T19:09:35.267' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1133, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 50000, 14, N'Покупка 50000 токенов на сумму 5031,97810290212.', CAST(N'2020-01-26T21:33:13.070' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1134, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,641798568935.', CAST(N'2020-01-26T22:19:13.217' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1135, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,642179292535.', CAST(N'2020-01-26T22:27:03.417' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1136, N'9891d3d6-e7eb-4911-98f5-fdde0c32b9cf', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-26T22:51:52.877' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1137, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1006,59081066006.', CAST(N'2020-01-27T03:26:16.507' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1138, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 100,680481946438.', CAST(N'2020-01-27T10:46:28.493' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1139, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9930, 14, N'Покупка 9930 токенов на сумму 999,814014195307.', CAST(N'2020-01-27T12:44:11.080' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1140, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9931, 14, N'Покупка 9931 токенов на сумму 999,915980041893.', CAST(N'2020-01-27T12:46:49.687' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1141, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1006,91405348834.', CAST(N'2020-01-27T14:31:07.487' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1142, N'996da0e7-d189-47a3-8436-e54b1572872d', 0, 14, N'Учетная запись создана.', CAST(N'2020-01-27T17:21:37.293' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1143, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9928, 14, N'Покупка 9928 токенов на сумму 999,896421211375.', CAST(N'2020-01-27T22:31:56.517' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1144, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1985, 14, N'Покупка 1985 токенов на сумму 199,955725613077.', CAST(N'2020-01-28T04:05:17.560' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1145, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 503,742929122675.', CAST(N'2020-01-28T09:18:11.160' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1146, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1985, 14, N'Покупка 1985 токенов на сумму 199,989033402392.', CAST(N'2020-01-28T09:50:11.507' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1147, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9915, 14, N'Покупка 9915 токенов на сумму 999,973460064836.', CAST(N'2020-01-29T20:47:40.277' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1148, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 504,275441575109.', CAST(N'2020-01-29T20:57:29.770' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1149, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1983, 14, N'Покупка 1983 токенов на сумму 199,997956552979.', CAST(N'2020-01-29T21:21:28.900' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1150, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9911, 14, N'Покупка 9911 токенов на сумму 999,946959419907.', CAST(N'2020-01-30T08:59:50.173' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1151, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9907, 14, N'Покупка 9907 токенов на сумму 1000,00432304221.', CAST(N'2020-01-31T00:06:00.293' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1152, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1979, 14, N'Покупка 1979 токенов на сумму 199,959079575156.', CAST(N'2020-02-01T09:54:31.603' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1153, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4946, 14, N'Покупка 4946 токенов на сумму 499,938114001568.', CAST(N'2020-02-01T23:09:49.680' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1154, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4946, 14, N'Продажа 4946 токенов на сумму 499,938234719844.', CAST(N'2020-02-01T23:10:19.880' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1155, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4946, 14, N'Покупка 4946 токенов на сумму 499,938254839557.', CAST(N'2020-02-01T23:10:24.733' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1156, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9844, 14, N'Покупка 9844 токенов на сумму 999,966304368552.', CAST(N'2020-02-08T20:29:09.550' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1157, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 19683, 14, N'Покупка 19683 токенов на сумму 1999,9305744109.', CAST(N'2020-02-09T04:24:29.707' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1158, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 29525, 14, N'Покупка 29525 токенов на сумму 2999,94878996801.', CAST(N'2020-02-09T04:25:57.610' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1159, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Продажа 100 токенов на сумму 10,1607090442913.', CAST(N'2020-02-09T04:26:20.760' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1160, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Покупка 100 токенов на сумму 10,1607106799251.', CAST(N'2020-02-09T04:26:40.323' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1161, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 49183, 14, N'Покупка 49183 токенов на сумму 4999,95503338227.', CAST(N'2020-02-09T22:28:59.987' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1162, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 983, 14, N'Покупка 983 токенов на сумму 99,9338219150579.', CAST(N'2020-02-09T23:06:38.120' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1163, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 19659, 14, N'Покупка 19659 токенов на сумму 1999,90353633248.', CAST(N'2020-02-10T21:14:23.933' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1164, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 49149, 14, N'Покупка 49149 токенов на сумму 4999,97763606263.', CAST(N'2020-02-10T21:41:48.347' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1165, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 982, 14, N'Покупка 982 токенов на сумму 99,9274538542123.', CAST(N'2020-02-11T06:25:15.687' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1166, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 982, 14, N'Покупка 982 токенов на сумму 99,9274643100891.', CAST(N'2020-02-11T06:25:28.870' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1167, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 982, 14, N'Покупка 982 токенов на сумму 99,9274707444749.', CAST(N'2020-02-11T06:25:36.687' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1168, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 15000, 14, N'Покупка 15000 токенов на сумму 1526,76264419737.', CAST(N'2020-02-11T14:55:06.847' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1169, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 49116, 14, N'Покупка 49116 токенов на сумму 4999,97875375617.', CAST(N'2020-02-11T20:04:33.547' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1170, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 982, 14, N'Покупка 982 токенов на сумму 99,9678497590362.', CAST(N'2020-02-11T20:22:10.600' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1171, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 3500, 14, N'Покупка 3500 токенов на сумму 356,953529566495.', CAST(N'2020-02-14T09:06:07.050' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1172, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1956, 14, N'Покупка 1956 токенов на сумму 199,905789136877.', CAST(N'2020-02-17T07:13:11.867' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1173, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9665, 14, N'Покупка 9665 токенов на сумму 999,986392047109.', CAST(N'2020-03-05T09:29:04.797' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1174, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9665, 14, N'Покупка 9665 токенов на сумму 999,986448387987.', CAST(N'2020-03-05T09:29:11.567' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1175, N'4d54d89b-7e4c-40a6-8638-739bdd618947', 0, 14, N'Учетная запись создана.', CAST(N'2020-03-08T14:19:37.600' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1176, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2000, 14, N'Покупка 2000 токенов на сумму 207,8562079169.', CAST(N'2020-03-11T14:51:34.373' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1177, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9609, 14, N'Покупка 9609 токенов на сумму 999,569529762112.', CAST(N'2020-03-12T21:58:53.323' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1178, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 520,129315452462.', CAST(N'2020-03-12T22:29:56.430' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1179, N'ff342ff7-3798-4f20-8c15-bb16ad9e3100', 0, 14, N'Учетная запись создана.', CAST(N'2020-03-18T22:07:35.073' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1180, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 0, 14, N'Учетная запись создана.', CAST(N'2020-03-18T22:58:18.120' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1181, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 2510, 1, N'Пополнение баланса на сумму 2510 р. Способ: ''Qiwi''.', CAST(N'2020-03-18T23:02:35.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1182, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 24024, 14, N'Покупка 24024 токенов на сумму 2509,96264166638.', CAST(N'2020-03-18T23:05:35.220' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1183, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 104,477473508572.', CAST(N'2020-03-18T23:09:02.420' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1184, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 9567, 14, N'Покупка 9567 токенов на сумму 999,921079075672.', CAST(N'2020-03-19T11:38:09.590' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1185, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 95428, 14, N'Покупка 95428 токенов на сумму 9999,96545094808.', CAST(N'2020-03-23T02:24:56.843' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1186, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 104,907815525533.', CAST(N'2020-03-24T16:09:42.060' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1187, N'497b82eb-2f1f-410d-a71c-36b45111b74b', 0, 14, N'Учетная запись создана.', CAST(N'2020-03-31T12:56:45.880' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1188, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 94545, 14, N'Покупка 94545 токенов на сумму 9999,96037639762.', CAST(N'2020-04-05T00:42:49.083' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1189, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 50000, 14, N'Покупка 50000 токенов на сумму 5292,86162228865.', CAST(N'2020-04-06T04:34:41.793' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1190, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1059,59165975243.', CAST(N'2020-04-07T12:59:10.683' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1191, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 56000, 14, N'Покупка 56000 токенов на сумму 5934,01581009583.', CAST(N'2020-04-07T14:44:44.470' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1192, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 94303, 14, N'Покупка 94303 токенов на сумму 9999,94918494895.', CAST(N'2020-04-08T14:41:59.420' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1193, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 106,041766607433.', CAST(N'2020-04-08T15:04:15.117' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1194, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 106,041769167993.', CAST(N'2020-04-08T15:04:18.987' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1195, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 530,360038282204.', CAST(N'2020-04-09T00:06:11.200' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1196, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 94218, 14, N'Покупка 94218 токенов на сумму 9999,92707325255.', CAST(N'2020-04-09T20:56:10.420' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1197, N'd0672d7a-632f-4901-a9d1-8b72e6c35869', 0, 14, N'Учетная запись создана.', CAST(N'2020-04-17T11:28:05.850' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1198, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 106,985456147045.', CAST(N'2020-04-20T23:08:18.903' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1199, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 107,519919637626.', CAST(N'2020-04-27T21:27:32.870' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1200, N'31c4e8bb-9c5b-45d7-8fa0-65c75f87e121', 0, 14, N'Учетная запись создана.', CAST(N'2020-04-27T23:01:54.890' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1201, N'61066082-72b4-477f-92dc-d1af87de7de9', 0, 14, N'Учетная запись создана.', CAST(N'2020-04-29T02:15:07.640' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1202, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 107,849210606706.', CAST(N'2020-05-02T02:57:03.517' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1203, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 107,849213210843.', CAST(N'2020-05-02T02:57:06.650' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1204, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 107,84921581498.', CAST(N'2020-05-02T02:57:09.740' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1205, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 108,02962183435.', CAST(N'2020-05-04T11:01:02.877' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1206, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 108,438503757972.', CAST(N'2020-05-09T17:21:07.633' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1207, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 92135, 14, N'Покупка 92135 токенов на сумму 9999,9315565726.', CAST(N'2020-05-10T23:26:44.877' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1208, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 108,535698999204.', CAST(N'2020-05-10T23:27:47.417' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1209, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 542,679425362317.', CAST(N'2020-05-10T23:31:21.023' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1210, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 14, N'Покупка 100 токенов на сумму 10,8553638073539.', CAST(N'2020-05-11T04:21:30.333' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1211, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 108,677888742928.', CAST(N'2020-05-12T19:01:46.837' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1212, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 91926, 14, N'Покупка 91926 токенов на сумму 9999,94550589899.', CAST(N'2020-05-14T02:38:08.990' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1213, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Продажа 10000 токенов на сумму 1087,82604390893.', CAST(N'2020-05-14T02:39:00.783' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1214, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1087,82664804942.', CAST(N'2020-05-14T02:40:10.027' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1215, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 109,912532740947.', CAST(N'2020-05-28T11:57:25.973' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1216, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 90889, 14, N'Покупка 90889 токенов на сумму 9999,91215525576.', CAST(N'2020-05-29T21:55:35.183' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1217, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2500, 14, N'Покупка 2500 токенов на сумму 275,058423088638.', CAST(N'2020-05-29T21:55:58.023' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1218, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 550,442142456218.', CAST(N'2020-05-30T17:31:33.560' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1219, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1100,88432921641.', CAST(N'2020-05-30T17:31:38.733' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1220, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 550,467529201554.', CAST(N'2020-05-30T19:07:03.647' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1221, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 90295, 14, N'Покупка 90295 токенов на сумму 9999,95727623321.', CAST(N'2020-06-08T00:17:14.837' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1222, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 111,51803510003.', CAST(N'2020-06-17T16:15:26.820' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1223, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 89671, 14, N'Покупка 89671 токенов на сумму 9999,93662302499.', CAST(N'2020-06-17T16:16:02.250' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1224, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 557,599532907082.', CAST(N'2020-06-17T16:50:11.137' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1225, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1116,03221101704.', CAST(N'2020-06-18T17:48:05.210' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1226, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 24024, 14, N'Продажа 24024 токенов на сумму 2696,8966889863.', CAST(N'2020-06-26T21:21:28.067' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1227, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -2, 15, N'Запрос вывода на сумму 2 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-06-28T05:34:03.063' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1228, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -2, 15, N'Запрос вывода на сумму 2 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-06-28T06:07:18.430' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1229, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -10, 15, N'Запрос вывода на сумму 10 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-06-28T16:09:12.027' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1230, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -10, 15, N'Запрос вывода на сумму 10 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-06-28T16:12:08.330' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1231, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', -10, 15, N'Запрос вывода на сумму 10 р. Способ: Qiwi. Номер (счет): +79779393722', CAST(N'2020-06-28T17:53:35.087' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1232, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 23978, 14, N'Покупка 23978 токенов на сумму 2696,85334765745.', CAST(N'2020-06-29T12:31:20.847' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1233, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 100, 1, N'Пополнение баланса на сумму 100 р. Способ: ''Qiwi''.', CAST(N'2020-05-08T17:06:31.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1234, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 10, 1, N'Пополнение баланса на сумму 10 р. Способ: ''Qiwi''.', CAST(N'2020-06-28T18:49:48.000' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1235, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1126,74094125372.', CAST(N'2020-07-02T00:03:25.033' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1236, N'ee678bfb-bf49-4050-aad3-6c5025d3f0e5', 0, 14, N'Учетная запись создана.', CAST(N'2020-07-08T11:35:06.813' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1237, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 23978, 14, N'Продажа 23978 токенов на сумму 2718,90063120408.', CAST(N'2020-07-10T20:37:19.463' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1238, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', -2718.98, 15, N'Запрос вывода на сумму 2718,98 р. Способ: Qiwi. Номер (счет): +79821395919', CAST(N'2020-07-10T20:38:51.160' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (1239, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 42000, 14, N'Покупка 42000 токенов на сумму 4783,16227327443.', CAST(N'2020-07-16T21:36:01.407' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2239, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1140,32567016682.', CAST(N'2020-07-18T16:43:44.877' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2240, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 570,162867207097.', CAST(N'2020-07-18T16:43:51.367' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2241, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1000, 14, N'Покупка 1000 токенов на сумму 114,032761594429.', CAST(N'2020-07-18T16:47:16.647' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2242, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 87694, 14, N'Покупка 87694 токенов на сумму 9999,99221475264.', CAST(N'2020-07-18T16:47:56.393' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2243, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 50000, 14, N'Покупка 50000 токенов на сумму 5719,59963983731.', CAST(N'2020-07-23T01:17:42.203' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2244, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10000, 14, N'Покупка 10000 токенов на сумму 1146,92837627834.', CAST(N'2020-07-26T17:30:52.610' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2245, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 87114, 14, N'Покупка 87114 токенов на сумму 9999,98153274037.', CAST(N'2020-07-27T22:30:05.817' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2246, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5000, 14, N'Покупка 5000 токенов на сумму 574,594287088901.', CAST(N'2020-07-29T11:01:58.753' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2247, N'53446782-b6e0-43cf-a718-4e445e853160', 0, 14, N'Учетная запись создана.', CAST(N'2020-09-11T00:23:44.883' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (2248, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 0, 14, N'Учетная запись создана.', CAST(N'2020-09-14T20:57:53.863' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3248, N'eb192af4-6fa7-4f34-ac02-5058cc5d424b', 0, 14, N'Учетная запись создана.', CAST(N'2020-10-08T23:19:05.957' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3249, N'bd4551af-fc28-4b85-b147-20a051676b21', 0, 14, N'Учетная запись создана.', CAST(N'2020-11-02T13:49:39.767' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3250, N'92cfb222-e607-4103-8d48-02826604aa12', 0, 14, N'Учетная запись создана.', CAST(N'2020-11-13T18:28:06.830' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3251, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', 0, 14, N'Учетная запись создана.', CAST(N'2020-11-28T00:52:39.963' AS DateTime))
GO
INSERT [dbo].[Operations] ([Id], [UserId], [Value], [Type], [Comment], [WhenDate]) VALUES (3252, N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', 0, 14, N'Учетная запись создана.', CAST(N'2020-12-03T10:35:07.353' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Operations] OFF
GO
SET IDENTITY_INSERT [dbo].[Rates] ON 
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (1, CAST(N'2021-01-02T14:09:47.513' AS DateTime), N'{"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (2, CAST(N'2021-01-02T14:15:32.963' AS DateTime), N'{"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (3, CAST(N'2021-01-02T14:23:46.690' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (4, CAST(N'2021-01-02T17:45:20.210' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (5, CAST(N'2021-01-02T17:45:38.007' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (6, CAST(N'2021-01-02T17:45:54.013' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (7, CAST(N'2021-01-02T17:46:18.993' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (8, CAST(N'2021-01-02T17:46:34.010' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (9, CAST(N'2021-01-02T17:46:56.800' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (10, CAST(N'2021-01-02T17:47:17.680' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (11, CAST(N'2021-01-02T17:47:33.997' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (12, CAST(N'2021-01-02T17:47:56.987' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (13, CAST(N'2021-01-02T17:48:20.027' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (14, CAST(N'2021-01-02T17:48:39.480' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (15, CAST(N'2021-01-02T17:48:56.800' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (16, CAST(N'2021-01-02T17:49:17.863' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (17, CAST(N'2021-01-02T17:49:37.483' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (18, CAST(N'2021-01-02T17:49:56.790' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (19, CAST(N'2021-01-02T18:21:28.800' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (20, CAST(N'2021-01-02T18:21:57.017' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (21, CAST(N'2021-01-02T18:29:32.780' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (22, CAST(N'2021-01-02T18:31:19.203' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (23, CAST(N'2021-01-02T18:31:52.773' AS DateTime), N'{"XAU":1889.7,"PAL":2394.0,"PL":1084.8,"XAG":26.45,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (24, CAST(N'2021-01-02T18:33:22.087' AS DateTime), N'{"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (25, CAST(N'2021-01-02T18:34:06.507' AS DateTime), N'{"XAU":7.0,"PAL":9.0,"PL":9.0,"XAG":26.36,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (26, CAST(N'2021-01-02T18:34:17.873' AS DateTime), N'{"XAU":7.0,"PAL":9.0,"PL":9.0,"XAG":26.36,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (27, CAST(N'2021-01-02T18:34:39.043' AS DateTime), N'{"XAU":7.0,"PAL":9.0,"PL":9.0,"XAG":26.36,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
INSERT [dbo].[Rates] ([Id], [Date], [Value]) VALUES (28, CAST(N'2021-01-02T19:57:37.660' AS DateTime), N'{"XAU":7.0,"PAL":9.0,"PL":9.0,"XAG":26.36,"USD":1.0,"ALL":101.99776,"GBP":0.73137,"BYN":2.64324,"BGN":1.61189,"HUF":298.8981,"DKK":6.1331,"EUR":0.82416,"ISK":128.65102,"MKD":50.78048,"MDL":17.38421,"NOK":8.63202,"PLN":3.7542,"RUB":74.51399,"RON":4.00887,"RSD":96.88798,"UAH":28.66511,"HRK":6.22107,"CZK":21.61189,"SEK":8.26833,"CHF":0.89}')
GO
SET IDENTITY_INSERT [dbo].[Rates] OFF
GO
SET IDENTITY_INSERT [dbo].[Recipes] ON 
GO
INSERT [dbo].[Recipes] ([Id], [Name], [Discription], [Created], [ImgUrl], [CountLikes], [TimeMinutesToCook], [UserId]) VALUES (1, N'Окрошка', N'Готовится из огурцов , вареной картошки, яиц и кваса', CAST(N'2020-08-11T00:38:48.257' AS DateTime), NULL, 74151, 30, 1)
GO
INSERT [dbo].[Recipes] ([Id], [Name], [Discription], [Created], [ImgUrl], [CountLikes], [TimeMinutesToCook], [UserId]) VALUES (2, N'Блины', N'На молоке', CAST(N'2020-08-11T00:39:23.613' AS DateTime), NULL, 5548, 15, 1)
GO
INSERT [dbo].[Recipes] ([Id], [Name], [Discription], [Created], [ImgUrl], [CountLikes], [TimeMinutesToCook], [UserId]) VALUES (3, N'Суп пюре ', N'Овощной суп пюре ', CAST(N'2020-08-11T00:40:07.530' AS DateTime), NULL, 3541, 45, 1)
GO
SET IDENTITY_INSERT [dbo].[Recipes] OFF
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'8b6f8834-7b96-43e1-9dec-16115fd48554', N'KeyManager', NULL)
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'821ee111-22d6-2251-b87c-b215b542f444', N'AdvertManager', NULL)
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'211ee111-19d6-4951-b87c-b215b542fe11', N'Administrator', NULL)
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'234ee901-21d6-4952-b871-b815b148fe46', N'234ee951-11d6-2151-b87c-b815b542fe41', N'CashOutManager', NULL)
GO
SET IDENTITY_INSERT [dbo].[Settings] ON 
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (2, 1, N'HoursDifference', N'0', N'Разница во времени с сервером', CAST(N'2018-06-22T14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (3, 2, N'ReferralPercent', N'10', N'Реферальные проценты 1го уровня', CAST(N'2018-06-22T14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (7, 3, N'ReferralPercent2', N'5', N'Реферальный процент 2го уровня', CAST(N'2018-06-22T14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (9, 4, N'ReferralPercent3', N'5', N'Реферальный процент 3го уровня', CAST(N'2018-06-22T14:33:37.840' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (11, 20, N'UsersCount', N'5', N'Количество пользователей в системе, отображаемое на главной странице', CAST(N'2018-11-17T23:51:02.053' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (12, 21, N'UsersCountRegisteredToday', N'2', N'Количество пользователей зарегистрированных за 24 часа', CAST(N'2018-11-17T23:51:02.057' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (13, 22, N'UsersCountOnline', N'2', N'Количество пользователей онлайн', CAST(N'2018-11-17T23:51:02.057' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (18, 24, N'TokenTodayCost', N'0,1', N'Цена токена сегодня', CAST(N'2019-09-29T18:30:13.920' AS DateTime))
GO
INSERT [dbo].[Settings] ([Id], [Order], [Name], [Value], [Description], [UpdateDate]) VALUES (19, 25, N'AvailableTokensCount', N'4897995214', N'Количество доступных токенов', CAST(N'2020-01-08T01:35:25.490' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Settings] OFF
GO
SET IDENTITY_INSERT [dbo].[TenderRequest] ON 
GO
INSERT [dbo].[TenderRequest] ([Id], [Description], [ProviderId], [ProviderName], [Cost], [CustomerId], [DateStart], [DateCompleted], [DateDelivered], [DateWin], [TenderId]) VALUES (1, N'Zavtra viezhau', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 301, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[TenderRequest] ([Id], [Description], [ProviderId], [ProviderName], [Cost], [CustomerId], [DateStart], [DateCompleted], [DateDelivered], [DateWin], [TenderId]) VALUES (2, N'заберу с адмиралтейской', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 200, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[TenderRequest] ([Id], [Description], [ProviderId], [ProviderName], [Cost], [CustomerId], [DateStart], [DateCompleted], [DateDelivered], [DateWin], [TenderId]) VALUES (3, N'beru', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 101, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', NULL, NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[TenderRequest] OFF
GO
SET IDENTITY_INSERT [dbo].[Tenders] ON 
GO
INSERT [dbo].[Tenders] ([Id], [Name], [Description], [UserOwnerId], [Cost], [ImgUrls], [Status], [Created], [CurrencyId], [CategoryId]) VALUES (1, N'Some tender 1', N'some opisanie', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 100, NULL, NULL, CAST(N'2020-11-04T01:34:11.877' AS DateTime), 0, 0)
GO
INSERT [dbo].[Tenders] ([Id], [Name], [Description], [UserOwnerId], [Cost], [ImgUrls], [Status], [Created], [CurrencyId], [CategoryId]) VALUES (2, N'tender 2', N'', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 40, NULL, NULL, CAST(N'2020-11-04T02:14:10.650' AS DateTime), 0, 0)
GO
INSERT [dbo].[Tenders] ([Id], [Name], [Description], [UserOwnerId], [Cost], [ImgUrls], [Status], [Created], [CurrencyId], [CategoryId]) VALUES (3, N'ten 3', N'', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 222, NULL, NULL, CAST(N'2020-11-04T02:19:39.873' AS DateTime), 0, 0)
GO
INSERT [dbo].[Tenders] ([Id], [Name], [Description], [UserOwnerId], [Cost], [ImgUrls], [Status], [Created], [CurrencyId], [CategoryId]) VALUES (4, N't 4', N'dlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliudlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvvvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvvvvvvvvvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvdlsjvhaeliuhdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvdlsjvhaeliuhvlodfhlvvlodfhlvhvlodfhlvvlodfhlv', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 140, NULL, NULL, CAST(N'2020-11-04T02:21:08.160' AS DateTime), 0, 0)
GO
SET IDENTITY_INSERT [dbo].[Tenders] OFF
GO
SET IDENTITY_INSERT [dbo].[TokensBuying] ON 
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:07:41.827' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:10:59.290' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (3, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:11:02.113' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (4, 500, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 50, CAST(N'2019-10-28T05:11:10.710' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (5, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 10, CAST(N'2019-10-28T05:11:36.030' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (6, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:11:37.213' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (7, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:11:46.497' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1002, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-11-16T16:47:39.140' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1003, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-11-16T16:48:05.693' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1004, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-12-29T01:07:00.557' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1005, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-12-29T01:07:04.043' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1006, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 10, CAST(N'2019-12-29T01:07:38.183' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1007, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2020-01-03T21:45:23.047' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1008, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2020-01-03T21:45:25.090' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1009, 10, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 1, CAST(N'2020-01-08T02:32:20.010' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1010, 10, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 1, CAST(N'2020-01-08T02:33:52.173' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1011, 10, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 1, CAST(N'2020-01-08T02:34:03.150' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1012, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2020-01-14T00:20:17.033' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1013, 1000, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 0.1, 100, CAST(N'2020-01-14T01:39:34.613' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1014, 20, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 2, CAST(N'2020-01-14T08:33:16.973' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1015, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 1000, CAST(N'2020-01-16T00:11:41.443' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1016, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 1000, CAST(N'2020-01-16T00:11:46.263' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1017, 2000, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 0.1, 200, CAST(N'2020-01-16T00:13:25.840' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1018, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10007191, 1000.7191, CAST(N'2020-01-19T07:21:27.843' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1019, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10007191, 500.35955, CAST(N'2020-01-19T20:32:58.437' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1020, 20000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10007191, 2001.4382, CAST(N'2020-01-19T20:33:07.967' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1021, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10028795041165275, 100.28795041165276, CAST(N'2020-01-22T08:00:09.447' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1022, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10028795041165275, 501.43975205826382, CAST(N'2020-01-22T08:00:21.333' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1023, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10028795041165275, 1002.8795041165276, CAST(N'2020-01-22T08:00:37.197' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1024, 996, N'd605cfec-b531-4b21-a58c-074b035402af', 0.10028795041165275, 99.886798610006153, CAST(N'2020-01-22T11:32:56.957' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1025, 2990, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 0.10028795041165275, 299.86097173084175, CAST(N'2020-01-22T13:38:11.787' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1026, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10038342387664397, 100.38342387664396, CAST(N'2020-01-23T08:02:18.590' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1027, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1003836234470545, 501.91811723527246, CAST(N'2020-01-23T08:06:01.827' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1028, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045256626980988, 100.45256626980988, CAST(N'2020-01-24T06:59:07.847' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1029, 2000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045258486557512, 200.90516973115021, CAST(N'2020-01-24T06:59:30.263' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1030, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045260346134032, 502.26301730670167, CAST(N'2020-01-24T06:59:53.413' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1031, 200, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045261235506088, 20.090522471012175, CAST(N'2020-01-24T07:00:04.770' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1032, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1004526220574804, 1004.526220574804, CAST(N'2020-01-24T07:00:16.440' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1033, 4000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045265925008848, 401.81063700035389, CAST(N'2020-01-24T07:01:02.803' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1034, 1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045266976104296, 0.10045266976104296, CAST(N'2020-01-24T07:01:15.097' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1035, 2000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10045272554995512, 200.90545109991024, CAST(N'2020-01-24T07:02:24.327' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1036, 995, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 0.10048995124387344, 99.987501487654086, CAST(N'2020-01-24T19:49:37.370' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1037, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.100529693682687, 1005.29693682687, CAST(N'2020-01-25T08:39:53.883' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1038, 50000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1005297050106445, 5026.4852505322251, CAST(N'2020-01-25T08:40:07.610' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1039, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.1005411615217212, 199.97637026670347, CAST(N'2020-01-25T12:36:05.250' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1040, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054138972559874, 199.97682416421591, CAST(N'2020-01-25T12:40:47.843' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1041, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054140348257008, 199.97685152683189, CAST(N'2020-01-25T12:41:04.943' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1042, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054142047647584, 199.97688532771048, CAST(N'2020-01-25T12:41:25.673' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1043, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054143018727917, 199.97690464249823, CAST(N'2020-01-25T12:41:37.763' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1044, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054144070731606, 199.97692556685169, CAST(N'2020-01-25T12:41:50.323' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1045, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054145365505381, 199.976951319902, CAST(N'2020-01-25T12:42:06.733' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1046, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10056254299270193, 100.56254299270192, CAST(N'2020-01-25T19:56:24.397' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1047, 3000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10056254703969073, 301.68764111907217, CAST(N'2020-01-25T19:56:29.093' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1048, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10056438199263622, 1005.6438199263622, CAST(N'2020-01-25T20:34:16.583' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1049, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1006047725095994, 503.023862547997, CAST(N'2020-01-26T09:37:16.887' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1050, 2000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10060479437271808, 201.20958874543615, CAST(N'2020-01-26T09:37:43.643' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1051, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10062028684981852, 1006.2028684981852, CAST(N'2020-01-26T14:56:34.907' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1052, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10062029332871821, 503.101466643591, CAST(N'2020-01-26T14:56:42.300' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1053, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10062190580695075, 100.62190580695076, CAST(N'2020-01-26T15:29:53.810' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1054, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10063073071044512, 100.63073071044512, CAST(N'2020-01-26T18:31:29.367' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1055, 500, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10063073638013945, 50.315368190069719, CAST(N'2020-01-26T18:31:36.697' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1056, 19874, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 0.10063091781035741, 1999.9388605630431, CAST(N'2020-01-26T18:35:20.400' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1057, 500, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1006325822841109, 50.316291142055448, CAST(N'2020-01-26T19:09:35.250' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1058, 50000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10063956205804241, 5031.97810290212, CAST(N'2020-01-26T21:33:13.013' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1059, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1006417985689352, 100.64179856893522, CAST(N'2020-01-26T22:19:13.140' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1060, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10064217929253476, 100.64217929253478, CAST(N'2020-01-26T22:27:03.403' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1061, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10065908106600628, 1006.5908106600627, CAST(N'2020-01-27T03:26:16.427' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1062, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10068048194643849, 100.68048194643848, CAST(N'2020-01-27T10:46:28.413' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1063, 9930, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10068620485350524, 999.814014195307, CAST(N'2020-01-27T12:44:11.003' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1064, 9931, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10068633370676602, 999.91598004189348, CAST(N'2020-01-27T12:46:49.670' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1065, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1006914053488344, 1006.9140534883441, CAST(N'2020-01-27T14:31:07.470' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1066, 9928, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10071478859905068, 999.89642121137524, CAST(N'2020-01-27T22:31:56.440' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1067, 1985, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10073336302925802, 199.95572561307716, CAST(N'2020-01-28T04:05:17.467' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1068, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.100748585824535, 503.74292912267504, CAST(N'2020-01-28T09:18:11.067' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1069, 1985, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10075014277198566, 199.98903340239153, CAST(N'2020-01-28T09:50:11.490' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1070, 9915, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10085461019312517, 999.97346006483588, CAST(N'2020-01-29T20:47:40.200' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1071, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1008550883150217, 504.27544157510846, CAST(N'2020-01-29T20:57:29.753' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1072, 1983, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10085625645636841, 199.99795655297857, CAST(N'2020-01-29T21:21:28.887' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1073, 9911, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1008926404419238, 999.94695941990676, CAST(N'2020-01-30T08:59:50.080' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1074, 9907, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10093916655316552, 1000.0043230422108, CAST(N'2020-01-31T00:06:00.217' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1075, 1979, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10104046466657723, 199.95907957515641, CAST(N'2020-02-01T09:54:31.527' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1076, 4946, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10107927901366121, 499.93811400156824, CAST(N'2020-02-01T23:09:49.600' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1077, 4946, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10107930748879028, 499.93825483955681, CAST(N'2020-02-01T23:10:24.733' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1078, 9844, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10158129869652093, 999.96630436855185, CAST(N'2020-02-08T20:29:09.473' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1079, 19683, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1016069996652389, 1999.9305744108972, CAST(N'2020-02-09T04:24:29.627' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1080, 29525, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10160707163312482, 2999.9487899680103, CAST(N'2020-02-09T04:25:57.597' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1081, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1016071067992509, 10.16071067992509, CAST(N'2020-02-09T04:26:40.307' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1082, 49183, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10166022880634094, 4999.9550333822663, CAST(N'2020-02-09T22:28:59.893' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1083, 983, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10166207722793276, 99.933821915057891, CAST(N'2020-02-09T23:06:38.103' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1084, 19659, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10172966765005756, 1999.9035363324815, CAST(N'2020-02-10T21:14:23.857' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1085, 49149, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10173101458956696, 4999.9776360626265, CAST(N'2020-02-10T21:41:48.330' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1086, 982, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10175911797781292, 99.927453854212274, CAST(N'2020-02-11T06:25:15.597' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1087, 982, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10175912862534534, 99.927464310089121, CAST(N'2020-02-11T06:25:28.857' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1088, 982, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10175913517767296, 99.92747074447486, CAST(N'2020-02-11T06:25:36.687' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1089, 15000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1017841762798246, 1526.7626441973691, CAST(N'2020-02-11T14:55:06.767' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1090, 49116, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10179938825955227, 4999.97875375617, CAST(N'2020-02-11T20:04:33.467' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1091, 982, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10180025433710412, 99.967849759036241, CAST(N'2020-02-11T20:22:10.587' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1092, 3500, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1019867227332842, 356.95352956649464, CAST(N'2020-02-14T09:06:06.963' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1093, 1956, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10220132368960969, 199.90578913687651, CAST(N'2020-02-17T07:13:11.773' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1094, 9665, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10346470688537082, 999.986392047109, CAST(N'2020-03-05T09:29:04.717' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1095, 9665, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10346471271474264, 999.98644838798748, CAST(N'2020-03-05T09:29:11.550' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1096, 2000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10392810395845016, 207.85620791690033, CAST(N'2020-03-11T14:51:34.297' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1097, 9609, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10402430323260614, 999.56952976211244, CAST(N'2020-03-12T21:58:53.247' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1098, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10402586309049236, 520.12931545246192, CAST(N'2020-03-12T22:29:56.337' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1099, 24024, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 0.10447729943666236, 2509.9626416663764, CAST(N'2020-03-18T23:05:35.190' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1100, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10447747350857196, 104.47747350857196, CAST(N'2020-03-18T23:09:02.407' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1101, 9567, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10451772541817418, 999.92107907567242, CAST(N'2020-03-19T11:38:09.523' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1102, 95428, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10479068460984288, 9999.9654509480843, CAST(N'2020-03-23T02:24:56.767' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1103, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1049078155255328, 104.90781552553278, CAST(N'2020-03-24T16:09:41.983' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1104, 94545, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10576932017978338, 9999.96037639762, CAST(N'2020-04-05T00:42:49.007' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1105, 50000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10585723244577308, 5292.861622288654, CAST(N'2020-04-06T04:34:41.717' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1106, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10595916597524258, 1059.5916597524258, CAST(N'2020-04-07T12:59:10.607' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1107, 56000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10596456803742554, 5934.0158100958306, CAST(N'2020-04-07T14:44:44.457' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1108, 94303, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1060406263316008, 9999.94918494895, CAST(N'2020-04-08T14:41:59.343' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1109, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10604176660743342, 106.04176660743342, CAST(N'2020-04-08T15:04:15.100' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1110, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10604176916799309, 106.04176916799308, CAST(N'2020-04-08T15:04:18.970' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1111, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10607200765644084, 530.36003828220419, CAST(N'2020-04-09T00:06:11.123' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1112, 94218, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10613605758191164, 9999.9270732525511, CAST(N'2020-04-09T20:56:10.343' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1113, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10698545614704529, 106.98545614704528, CAST(N'2020-04-20T23:08:18.793' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1114, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10751991963762608, 107.51991963762607, CAST(N'2020-04-27T21:27:32.457' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1115, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1078492106067059, 107.8492106067059, CAST(N'2020-05-02T02:57:03.420' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1116, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10784921321084295, 107.84921321084296, CAST(N'2020-05-02T02:57:06.637' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1117, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10784921581498004, 107.84921581498004, CAST(N'2020-05-02T02:57:09.723' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1118, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10802962183435004, 108.02962183435004, CAST(N'2020-05-04T11:01:02.800' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1119, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10843850375797168, 108.43850375797167, CAST(N'2020-05-09T17:21:07.557' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1120, 92135, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10853564396345142, 9999.9315565725956, CAST(N'2020-05-10T23:26:44.800' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1121, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10853569899920416, 108.53569899920414, CAST(N'2020-05-10T23:27:47.403' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1122, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1085358850724634, 542.67942536231692, CAST(N'2020-05-10T23:31:20.967' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1123, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10855363807353911, 10.855363807353912, CAST(N'2020-05-11T04:21:30.253' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1124, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10867788874292826, 108.67788874292826, CAST(N'2020-05-12T19:01:46.760' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1125, 91926, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1087825588614645, 9999.9455058989861, CAST(N'2020-05-14T02:38:08.947' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1126, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10878266480494188, 1087.826648049419, CAST(N'2020-05-14T02:40:09.990' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1127, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1099125327409473, 109.9125327409473, CAST(N'2020-05-28T11:57:25.897' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1128, 90889, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11002334886791317, 9999.91215525576, CAST(N'2020-05-29T21:55:35.090' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1129, 2500, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1100233692354551, 275.05842308863777, CAST(N'2020-05-29T21:55:58.007' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1130, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1100884284912436, 550.442142456218, CAST(N'2020-05-30T17:31:33.513' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1131, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11008843292164054, 1100.8843292164054, CAST(N'2020-05-30T17:31:38.697' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1132, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11009350584031086, 550.46752920155427, CAST(N'2020-05-30T19:07:03.567' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1133, 90295, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11074763028111428, 9999.9572762332136, CAST(N'2020-06-08T00:17:14.743' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1134, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11151803510003006, 111.51803510003006, CAST(N'2020-06-17T16:15:26.743' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1135, 89671, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11151806741337772, 9999.9366230249943, CAST(N'2020-06-17T16:16:02.237' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1136, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1115199065814165, 557.59953290708245, CAST(N'2020-06-17T16:50:11.120' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1137, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11160322110170444, 1116.0322110170446, CAST(N'2020-06-18T17:48:05.117' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1138, 23978, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 0.11247198880880165, 2696.8533476574457, CAST(N'2020-06-29T12:31:20.770' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1139, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11267409412537158, 1126.7409412537161, CAST(N'2020-07-02T00:03:24.957' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1140, 42000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11388481603034346, 4783.1622732744254, CAST(N'2020-07-16T21:36:01.327' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2140, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11403256701668241, 1140.325670166824, CAST(N'2020-07-18T16:43:44.783' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2141, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11403257344141932, 570.16286720709661, CAST(N'2020-07-18T16:43:51.367' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2142, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11403276159442941, 114.0327615944294, CAST(N'2020-07-18T16:47:16.630' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2143, 87694, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11403279830721184, 9999.9922147526358, CAST(N'2020-07-18T16:47:56.380' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2144, 50000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11439199279674617, 5719.5996398373072, CAST(N'2020-07-23T01:17:42.127' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2145, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11469283762783392, 1146.9283762783391, CAST(N'2020-07-26T17:30:52.533' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2146, 87114, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11479189949652602, 9999.9815327403667, CAST(N'2020-07-27T22:30:05.737' AS DateTime))
GO
INSERT [dbo].[TokensBuying] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2147, 5000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.11491885741778028, 574.59428708890141, CAST(N'2020-07-29T11:01:58.677' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TokensBuying] OFF
GO
SET IDENTITY_INSERT [dbo].[TokensCost] ON 
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (1, 0.10007191, CAST(N'2020-01-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (2, 0.100143871710481, CAST(N'2020-01-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (3, 0.100215885168628, CAST(N'2020-01-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (4, 0.10028795041165275, CAST(N'2020-01-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (5, 0.10036006747679378, CAST(N'2020-01-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (6, 0.10043223640131636, CAST(N'2020-01-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (7, 0.10050445722251254, CAST(N'2020-01-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (8, 0.10057672997770126, CAST(N'2020-01-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (9, 0.10064905470422822, CAST(N'2020-01-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (10, 0.10072143143946603, CAST(N'2020-01-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (11, 0.10079386022081416, CAST(N'2020-01-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (12, 0.10086634108569896, CAST(N'2020-01-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (13, 0.10093887407157368, CAST(N'2020-01-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (14, 0.10101145921591856, CAST(N'2020-02-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (15, 0.10108409655624072, CAST(N'2020-02-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (16, 0.10115678613007433, CAST(N'2020-02-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (17, 0.10122952797498044, CAST(N'2020-02-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (18, 0.10130232212854726, CAST(N'2020-02-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (19, 0.1013751686283899, CAST(N'2020-02-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (20, 0.10144806751215058, CAST(N'2020-02-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (21, 0.10152101881749856, CAST(N'2020-02-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (22, 0.10159402258213024, CAST(N'2020-02-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (23, 0.10166707884376904, CAST(N'2020-02-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (24, 0.10174018764016558, CAST(N'2020-02-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (25, 0.10181334900909762, CAST(N'2020-02-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (26, 0.10188656298837008, CAST(N'2020-02-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (27, 0.101959829615815, CAST(N'2020-02-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (28, 0.10203314892929172, CAST(N'2020-02-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (29, 0.10210652096668678, CAST(N'2020-02-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (30, 0.10217994576591392, CAST(N'2020-02-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (31, 0.10225342336491421, CAST(N'2020-02-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (32, 0.10232695380165592, CAST(N'2020-02-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (33, 0.10240053711413467, CAST(N'2020-02-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (34, 0.10247417334037344, CAST(N'2020-02-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (35, 0.10254786251842252, CAST(N'2020-02-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (36, 0.10262160468635952, CAST(N'2020-02-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (37, 0.10269539988228948, CAST(N'2020-02-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (38, 0.10276924814434482, CAST(N'2020-02-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (39, 0.10284314951068542, CAST(N'2020-02-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (40, 0.10291710401949857, CAST(N'2020-02-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (41, 0.10299111170899895, CAST(N'2020-02-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (42, 0.10306517261742892, CAST(N'2020-02-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (43, 0.1031392867830581, CAST(N'2020-03-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (44, 0.10321345424418379, CAST(N'2020-03-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (45, 0.10328767503913081, CAST(N'2020-03-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (46, 0.10336194920625144, CAST(N'2020-03-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (47, 0.10343627678392564, CAST(N'2020-03-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (48, 0.10351065781056096, CAST(N'2020-03-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (49, 0.10358509232459254, CAST(N'2020-03-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (50, 0.10365958036448315, CAST(N'2020-03-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (51, 0.10373412196872324, CAST(N'2020-03-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (52, 0.10380871717583096, CAST(N'2020-03-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (53, 0.1038833660243521, CAST(N'2020-03-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (54, 0.1039580685528602, CAST(N'2020-03-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (55, 0.10403282479995656, CAST(N'2020-03-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (56, 0.10410763480427022, CAST(N'2020-03-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (57, 0.10418249860445795, CAST(N'2020-03-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (58, 0.10425741623920444, CAST(N'2020-03-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (59, 0.10433238774722205, CAST(N'2020-03-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (60, 0.10440741316725108, CAST(N'2020-03-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (61, 0.10448249253805964, CAST(N'2020-03-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (62, 0.10455762589844377, CAST(N'2020-03-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (63, 0.10463281328722732, CAST(N'2020-03-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (64, 0.10470805474326216, CAST(N'2020-03-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (65, 0.10478335030542806, CAST(N'2020-03-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (66, 0.10485870001263269, CAST(N'2020-03-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (67, 0.10493410390381178, CAST(N'2020-03-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (68, 0.105009562017929, CAST(N'2020-03-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (69, 0.1050850743939761, CAST(N'2020-03-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (70, 0.1051606410709728, CAST(N'2020-03-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (71, 0.10523626208796696, CAST(N'2020-03-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (72, 0.1053119374840344, CAST(N'2020-03-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (73, 0.10538766729827916, CAST(N'2020-03-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (74, 0.10546345156983336, CAST(N'2020-04-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (75, 0.10553929033785722, CAST(N'2020-04-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (76, 0.10561518364153916, CAST(N'2020-04-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (77, 0.10569113152009579, CAST(N'2020-04-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (78, 0.10576713401277192, CAST(N'2020-04-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (79, 0.10584319115884049, CAST(N'2020-04-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (80, 0.1059193029976028, CAST(N'2020-04-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (81, 0.1059954695683884, CAST(N'2020-04-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (82, 0.10607169091055502, CAST(N'2020-04-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (83, 0.10614796706348879, CAST(N'2020-04-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (84, 0.10622429806660416, CAST(N'2020-04-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (85, 0.10630068395934383, CAST(N'2020-04-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (86, 0.106377124781179, CAST(N'2020-04-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (87, 0.10645362057160916, CAST(N'2020-04-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (88, 0.1065301713701622, CAST(N'2020-04-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (89, 0.10660677721639449, CAST(N'2020-04-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (90, 0.1066834381498908, CAST(N'2020-04-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (91, 0.1067601542102644, CAST(N'2020-04-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (92, 0.106836925437157, CAST(N'2020-04-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (93, 0.10691375187023886, CAST(N'2020-04-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (94, 0.10699063354920876, CAST(N'2020-04-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (95, 0.10706757051379398, CAST(N'2020-04-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (96, 0.10714456280375044, CAST(N'2020-04-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (97, 0.10722161045886264, CAST(N'2020-04-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (98, 0.1072987135189436, CAST(N'2020-04-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (99, 0.10737587202383508, CAST(N'2020-04-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (100, 0.1074530860134074, CAST(N'2020-04-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (101, 0.10753035552755964, CAST(N'2020-04-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (102, 0.10760768060621952, CAST(N'2020-04-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (103, 0.10768506128934344, CAST(N'2020-04-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (104, 0.1077624976169166, CAST(N'2020-05-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (105, 0.10783998962895294, CAST(N'2020-05-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (106, 0.10791753736549511, CAST(N'2020-05-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (107, 0.10799514086661466, CAST(N'2020-05-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (108, 0.10807280017241185, CAST(N'2020-05-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (109, 0.10815051532301584, CAST(N'2020-05-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (110, 0.1082282863585846, CAST(N'2020-05-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (111, 0.10830611331930506, CAST(N'2020-05-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (112, 0.10838399624539298, CAST(N'2020-05-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (113, 0.10846193517709304, CAST(N'2020-05-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (114, 0.10853993015467887, CAST(N'2020-05-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (115, 0.10861798121845312, CAST(N'2020-05-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (116, 0.10869608840874732, CAST(N'2020-05-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (117, 0.10877425176592204, CAST(N'2020-05-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (118, 0.10885247133036692, CAST(N'2020-05-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (119, 0.10893074714250058, CAST(N'2020-05-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (120, 0.10900907924277074, CAST(N'2020-05-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (121, 0.10908746767165424, CAST(N'2020-05-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (122, 0.10916591246965691, CAST(N'2020-05-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (123, 0.10924441367731384, CAST(N'2020-05-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (124, 0.1093229713351892, CAST(N'2020-05-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (125, 0.10940158548387634, CAST(N'2020-05-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (126, 0.1094802561639978, CAST(N'2020-05-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (127, 0.10955898341620532, CAST(N'2020-05-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (128, 0.10963776728117992, CAST(N'2020-05-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (129, 0.10971660779963184, CAST(N'2020-05-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (130, 0.10979550501230054, CAST(N'2020-05-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (131, 0.10987445895995487, CAST(N'2020-05-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (132, 0.109953469683393, CAST(N'2020-05-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (133, 0.11003253722344232, CAST(N'2020-05-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (134, 0.1101116616209597, CAST(N'2020-05-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (135, 0.11019084291683132, CAST(N'2020-06-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (136, 0.11027008115197284, CAST(N'2020-06-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (137, 0.11034937636732919, CAST(N'2020-06-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (138, 0.11042872860387495, CAST(N'2020-06-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (139, 0.110508137902614, CAST(N'2020-06-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (140, 0.11058760430457976, CAST(N'2020-06-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (141, 0.1106671278508352, CAST(N'2020-06-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (142, 0.11074670858247274, CAST(N'2020-06-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (143, 0.11082634654061441, CAST(N'2020-06-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (144, 0.11090604176641176, CAST(N'2020-06-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (145, 0.11098579430104598, CAST(N'2020-06-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (146, 0.11106560418572786, CAST(N'2020-06-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (147, 0.11114547146169782, CAST(N'2020-06-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (148, 0.11122539617022592, CAST(N'2020-06-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (149, 0.11130537835261194, CAST(N'2020-06-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (150, 0.1113854180501853, CAST(N'2020-06-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (151, 0.11146551530430519, CAST(N'2020-06-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (152, 0.11154567015636052, CAST(N'2020-06-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (153, 0.11162588264776996, CAST(N'2020-06-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (154, 0.11170615281998196, CAST(N'2020-06-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (155, 0.11178648071447482, CAST(N'2020-06-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (156, 0.1118668663727566, CAST(N'2020-06-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (157, 0.11194730983636524, CAST(N'2020-06-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (158, 0.11202781114686858, CAST(N'2020-06-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (159, 0.11210837034586428, CAST(N'2020-06-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (160, 0.11218898747498, CAST(N'2020-06-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (161, 0.11226966257587326, CAST(N'2020-06-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (162, 0.11235039569023156, CAST(N'2020-06-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (163, 0.11243118685977242, CAST(N'2020-06-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (164, 0.11251203612624328, CAST(N'2020-06-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (165, 0.11259294353142169, CAST(N'2020-07-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (166, 0.11267390911711513, CAST(N'2020-07-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (167, 0.11275493292516124, CAST(N'2020-07-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (168, 0.11283601499742772, CAST(N'2020-07-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (169, 0.11291715537581236, CAST(N'2020-07-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (170, 0.11299835410224313, CAST(N'2020-07-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (171, 0.11307961121867804, CAST(N'2020-07-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (172, 0.1131609267671054, CAST(N'2020-07-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (173, 0.11324230078954362, CAST(N'2020-07-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (174, 0.11332373332804138, CAST(N'2020-07-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (175, 0.11340522442467756, CAST(N'2020-07-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (176, 0.11348677412156136, CAST(N'2020-07-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (177, 0.11356838246083216, CAST(N'2020-07-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (178, 0.11365004948465976, CAST(N'2020-07-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (179, 0.11373177523524418, CAST(N'2020-07-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (180, 0.11381355975481584, CAST(N'2020-07-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (181, 0.11389540308563552, CAST(N'2020-07-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (182, 0.11397730526999442, CAST(N'2020-07-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (183, 0.11405926635021409, CAST(N'2020-07-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (184, 0.11414128636864653, CAST(N'2020-07-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (185, 0.1142233653676742, CAST(N'2020-07-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (186, 0.1143055033897101, CAST(N'2020-07-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (187, 0.11438770047719764, CAST(N'2020-07-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (188, 0.11446995667261078, CAST(N'2020-07-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (189, 0.11455227201845404, CAST(N'2020-07-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (190, 0.11463464655726252, CAST(N'2020-07-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (191, 0.11471708033160184, CAST(N'2020-07-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (192, 0.11479957338406828, CAST(N'2020-07-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (193, 0.11488212575728878, CAST(N'2020-07-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (194, 0.11496473749392085, CAST(N'2020-07-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (195, 0.11504740863665272, CAST(N'2020-07-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (196, 0.11513013922820334, CAST(N'2020-08-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (197, 0.11521292931132234, CAST(N'2020-08-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (198, 0.1152957789287901, CAST(N'2020-08-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (199, 0.1153786881234178, CAST(N'2020-08-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (200, 0.11546165693804734, CAST(N'2020-08-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (201, 0.11554468541555148, CAST(N'2020-08-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (202, 0.11562777359883382, CAST(N'2020-08-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (203, 0.11571092153082874, CAST(N'2020-08-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (204, 0.11579412925450155, CAST(N'2020-08-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (205, 0.11587739681284846, CAST(N'2020-08-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (206, 0.1159607242488966, CAST(N'2020-08-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (207, 0.11604411160570397, CAST(N'2020-08-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (208, 0.11612755892635962, CAST(N'2020-08-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (209, 0.11621106625398356, CAST(N'2020-08-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (210, 0.1162946336317268, CAST(N'2020-08-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (211, 0.1163782611027714, CAST(N'2020-08-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (212, 0.1164619487103304, CAST(N'2020-08-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (213, 0.11654569649764798, CAST(N'2020-08-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (214, 0.11662950450799944, CAST(N'2020-08-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (215, 0.11671337278469114, CAST(N'2020-08-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (216, 0.11679730137106062, CAST(N'2020-08-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (217, 0.11688129031047656, CAST(N'2020-08-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (218, 0.1169653396463388, CAST(N'2020-08-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (219, 0.11704944942207848, CAST(N'2020-08-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (220, 0.1171336196811579, CAST(N'2020-08-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (221, 0.11721785046707062, CAST(N'2020-08-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (222, 0.11730214182334148, CAST(N'2020-08-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (223, 0.11738649379352666, CAST(N'2020-08-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (224, 0.11747090642121358, CAST(N'2020-08-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (225, 0.11755537975002108, CAST(N'2020-08-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (226, 0.11763991382359933, CAST(N'2020-08-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (227, 0.11772450868562986, CAST(N'2020-09-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (228, 0.11780916437982572, CAST(N'2020-09-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (229, 0.11789388094993124, CAST(N'2020-09-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (230, 0.11797865843972231, CAST(N'2020-09-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (231, 0.11806349689300633, CAST(N'2020-09-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (232, 0.11814839635362208, CAST(N'2020-09-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (233, 0.11823335686543998, CAST(N'2020-09-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (234, 0.11831837847236192, CAST(N'2020-09-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (235, 0.1184034612183214, CAST(N'2020-09-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (236, 0.11848860514728347, CAST(N'2020-09-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (237, 0.1185738103032449, CAST(N'2020-09-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (238, 0.11865907673023396, CAST(N'2020-09-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (239, 0.11874440447231068, CAST(N'2020-09-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (240, 0.11882979357356673, CAST(N'2020-09-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (241, 0.11891524407812548, CAST(N'2020-09-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (242, 0.11900075603014206, CAST(N'2020-09-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (243, 0.11908632947380334, CAST(N'2020-09-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (244, 0.11917196445332796, CAST(N'2020-09-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (245, 0.11925766101296634, CAST(N'2020-09-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (246, 0.11934341919700076, CAST(N'2020-09-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (247, 0.11942923904974533, CAST(N'2020-09-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (248, 0.11951512061554598, CAST(N'2020-09-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (249, 0.11960106393878062, CAST(N'2020-09-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (250, 0.119687069063859, CAST(N'2020-09-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (251, 0.1197731360352228, CAST(N'2020-09-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (252, 0.11985926489734576, CAST(N'2020-09-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (253, 0.11994545569473344, CAST(N'2020-09-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (254, 0.12003170847192352, CAST(N'2020-09-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (255, 0.12011802327348568, CAST(N'2020-09-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (256, 0.12020440014402165, CAST(N'2020-09-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (257, 0.1202908391281652, CAST(N'2020-10-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (258, 0.12037734027058226, CAST(N'2020-10-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (259, 0.12046390361597084, CAST(N'2020-10-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (260, 0.12055052920906108, CAST(N'2020-10-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (261, 0.12063721709461532, CAST(N'2020-10-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (262, 0.12072396731742806, CAST(N'2020-10-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (263, 0.120810779922326, CAST(N'2020-10-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (264, 0.12089765495416815, CAST(N'2020-10-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (265, 0.12098459245784568, CAST(N'2020-10-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (266, 0.12107159247828211, CAST(N'2020-10-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (267, 0.12115865506043326, CAST(N'2020-10-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (268, 0.1212457802492872, CAST(N'2020-10-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (269, 0.12133296808986448, CAST(N'2020-10-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (270, 0.1214202186272179, CAST(N'2020-10-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (271, 0.12150753190643274, CAST(N'2020-10-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (272, 0.12159490797262663, CAST(N'2020-10-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (273, 0.12168234687094975, CAST(N'2020-10-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (274, 0.12176984864658466, CAST(N'2020-10-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (275, 0.12185741334474642, CAST(N'2020-10-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (276, 0.12194504101068264, CAST(N'2020-10-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (277, 0.12203273168967339, CAST(N'2020-10-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (278, 0.12212048542703144, CAST(N'2020-10-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (279, 0.12220830226810205, CAST(N'2020-10-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (280, 0.12229618225826304, CAST(N'2020-10-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (281, 0.12238412544292494, CAST(N'2020-10-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (282, 0.12247213186753096, CAST(N'2020-10-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (283, 0.12256020157755689, CAST(N'2020-10-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (284, 0.12264833461851132, CAST(N'2020-10-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (285, 0.12273653103593549, CAST(N'2020-10-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (286, 0.12282479087540343, CAST(N'2020-10-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (287, 0.12291311418252192, CAST(N'2020-10-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (288, 0.1230015010029306, CAST(N'2020-11-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (289, 0.1230899513823018, CAST(N'2020-11-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (290, 0.12317846536634081, CAST(N'2020-11-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (291, 0.12326704300078574, CAST(N'2020-11-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (292, 0.1233556843314076, CAST(N'2020-11-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (293, 0.12344438940401033, CAST(N'2020-11-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (294, 0.12353315826443072, CAST(N'2020-11-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (295, 0.12362199095853868, CAST(N'2020-11-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (296, 0.12371088753223695, CAST(N'2020-11-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (297, 0.12379984803146141, CAST(N'2020-11-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (298, 0.12388887250218082, CAST(N'2020-11-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (299, 0.12397796099039714, CAST(N'2020-11-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (300, 0.12406711354214534, CAST(N'2020-11-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (301, 0.1241563302034935, CAST(N'2020-11-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (302, 0.12424561102054282, CAST(N'2020-11-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (303, 0.12433495603942768, CAST(N'2020-11-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (304, 0.12442436530631564, CAST(N'2020-11-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (305, 0.12451383886740744, CAST(N'2020-11-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (306, 0.12460337676893696, CAST(N'2020-11-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (307, 0.12469297905717153, CAST(N'2020-11-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (308, 0.12478264577841151, CAST(N'2020-11-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (309, 0.12487237697899078, CAST(N'2020-11-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (310, 0.12496217270527638, CAST(N'2020-11-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (311, 0.12505203300366874, CAST(N'2020-11-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (312, 0.12514195792060168, CAST(N'2020-11-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (313, 0.12523194750254238, CAST(N'2020-11-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (314, 0.12532200179599146, CAST(N'2020-11-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (315, 0.12541212084748296, CAST(N'2020-11-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (316, 0.12550230470358439, CAST(N'2020-11-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (317, 0.12559255341089673, CAST(N'2020-11-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (318, 0.1256828670160545, CAST(N'2020-12-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (319, 0.12577324556572575, CAST(N'2020-12-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (320, 0.12586368910661205, CAST(N'2020-12-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (321, 0.12595419768544861, CAST(N'2020-12-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (322, 0.12604477134900419, CAST(N'2020-12-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (323, 0.12613541014408128, CAST(N'2020-12-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (324, 0.12622611411751589, CAST(N'2020-12-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (325, 0.1263168833161778, CAST(N'2020-12-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (326, 0.12640771778697046, CAST(N'2020-12-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (327, 0.12649861757683106, CAST(N'2020-12-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (328, 0.12658958273273055, CAST(N'2020-12-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (329, 0.12668061330167366, CAST(N'2020-12-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (330, 0.1267717093306989, CAST(N'2020-12-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (331, 0.12686287086687861, CAST(N'2020-12-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (332, 0.126954097957319, CAST(N'2020-12-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (333, 0.1270453906491601, CAST(N'2020-12-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (334, 0.12713674898957592, CAST(N'2020-12-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (335, 0.12722817302577433, CAST(N'2020-12-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (336, 0.12731966280499715, CAST(N'2020-12-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (337, 0.12741121837452021, CAST(N'2020-12-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (338, 0.12750283978165333, CAST(N'2020-12-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (339, 0.12759452707374033, CAST(N'2020-12-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (340, 0.12768628029815909, CAST(N'2020-12-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (341, 0.12777809950232147, CAST(N'2020-12-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (342, 0.12786998473367359, CAST(N'2020-12-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (343, 0.12796193603969558, CAST(N'2020-12-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (344, 0.12805395346790172, CAST(N'2020-12-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (345, 0.12814603706584049, CAST(N'2020-12-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (346, 0.12823818688109454, CAST(N'2020-12-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (347, 0.12833040296128073, CAST(N'2020-12-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (348, 0.12842268535405019, CAST(N'2020-12-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (349, 0.12851503410708828, CAST(N'2021-01-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (350, 0.12860744926811468, CAST(N'2021-01-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (351, 0.12869993088488338, CAST(N'2021-01-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (352, 0.1287924790051827, CAST(N'2021-01-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (353, 0.12888509367683532, CAST(N'2021-01-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (354, 0.12897777494769833, CAST(N'2021-01-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (355, 0.12907052286566323, CAST(N'2021-01-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (356, 0.12916333747865594, CAST(N'2021-01-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (357, 0.12925621883463684, CAST(N'2021-01-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (358, 0.12934916698160082, CAST(N'2021-01-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (359, 0.12944218196757729, CAST(N'2021-01-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (360, 0.12953526384063016, CAST(N'2021-01-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (361, 0.12962841264885797, CAST(N'2021-01-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (362, 0.12972162844039376, CAST(N'2021-01-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (363, 0.12981491126340525, CAST(N'2021-01-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (364, 0.12990826116609475, CAST(N'2021-01-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (365, 0.13000167819669933, CAST(N'2021-01-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (366, 0.13009516240349056, CAST(N'2021-01-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (367, 0.1301887138347749, CAST(N'2021-01-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (368, 0.13028233253889349, CAST(N'2021-01-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (369, 0.13037601856422221, CAST(N'2021-01-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (370, 0.13046977195917173, CAST(N'2021-01-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (371, 0.13056359277218757, CAST(N'2021-01-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (372, 0.13065748105175004, CAST(N'2021-01-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (373, 0.13075143684637436, CAST(N'2021-01-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (374, 0.13084546020461058, CAST(N'2021-01-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (375, 0.13093955117504372, CAST(N'2021-01-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (376, 0.1310337098062937, CAST(N'2021-01-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (377, 0.1311279361470154, CAST(N'2021-01-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (378, 0.13122223024589871, CAST(N'2021-01-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (379, 0.13131659215166855, CAST(N'2021-01-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (380, 0.13141102191308482, CAST(N'2021-02-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (381, 0.13150551957894252, CAST(N'2021-02-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (382, 0.13160008519807173, CAST(N'2021-02-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (383, 0.13169471881933767, CAST(N'2021-02-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (384, 0.13178942049164066, CAST(N'2021-02-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (385, 0.13188419026391621, CAST(N'2021-02-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (386, 0.131979028185135, CAST(N'2021-02-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (387, 0.13207393430430292, CAST(N'2021-02-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (388, 0.13216890867046113, CAST(N'2021-02-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (389, 0.13226395133268606, CAST(N'2021-02-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (390, 0.1323590623400894, CAST(N'2021-02-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (391, 0.13245424174181816, CAST(N'2021-02-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (392, 0.1325494895870547, CAST(N'2021-02-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (393, 0.13264480592501676, CAST(N'2021-02-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (394, 0.13274019080495744, CAST(N'2021-02-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (395, 0.13283564427616529, CAST(N'2021-02-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (396, 0.13293116638796429, CAST(N'2021-02-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (397, 0.13302675718971388, CAST(N'2021-02-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (398, 0.133122416730809, CAST(N'2021-02-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (399, 0.13321814506068011, CAST(N'2021-02-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (400, 0.13331394222879325, CAST(N'2021-02-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (401, 0.13340980828465, CAST(N'2021-02-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (402, 0.13350574327778747, CAST(N'2021-02-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (403, 0.13360174725777851, CAST(N'2021-02-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (404, 0.13369782027423158, CAST(N'2021-02-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (405, 0.13379396237679078, CAST(N'2021-02-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (406, 0.13389017361513594, CAST(N'2021-02-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (407, 0.1339864540389826, CAST(N'2021-02-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (408, 0.13408280369808204, CAST(N'2021-03-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (409, 0.13417922264222132, CAST(N'2021-03-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (410, 0.13427571092122334, CAST(N'2021-03-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (411, 0.1343722685849468, CAST(N'2021-03-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (412, 0.13446889568328624, CAST(N'2021-03-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (413, 0.1345655922661721, CAST(N'2021-03-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (414, 0.13466235838357071, CAST(N'2021-03-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (415, 0.13475919408548434, CAST(N'2021-03-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (416, 0.1348560994219512, CAST(N'2021-03-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (417, 0.13495307444304552, CAST(N'2021-03-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (418, 0.13505011919887752, CAST(N'2021-03-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (419, 0.13514723373959345, CAST(N'2021-03-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (420, 0.13524441811537558, CAST(N'2021-03-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (421, 0.13534167237644237, CAST(N'2021-03-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (422, 0.13543899657304825, CAST(N'2021-03-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (423, 0.13553639075548393, CAST(N'2021-03-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (424, 0.13563385497407621, CAST(N'2021-03-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (425, 0.13573138927918807, CAST(N'2021-03-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (426, 0.13582899372121873, CAST(N'2021-03-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (427, 0.13592666835060366, CAST(N'2021-03-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (428, 0.13602441321781458, CAST(N'2021-03-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (429, 0.13612222837335952, CAST(N'2021-03-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (430, 0.13622011386778279, CAST(N'2021-03-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (431, 0.13631806975166513, CAST(N'2021-03-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (432, 0.13641609607562352, CAST(N'2021-03-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (433, 0.1365141928903115, CAST(N'2021-03-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (434, 0.13661236024641893, CAST(N'2021-03-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (435, 0.13671059819467213, CAST(N'2021-03-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (436, 0.13680890678583393, CAST(N'2021-03-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (437, 0.1369072860707036, CAST(N'2021-03-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (438, 0.13700573610011704, CAST(N'2021-03-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (439, 0.13710425692494663, CAST(N'2021-04-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (440, 0.13720284859610135, CAST(N'2021-04-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (441, 0.1373015111645268, CAST(N'2021-04-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (442, 0.13740024468120521, CAST(N'2021-04-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (443, 0.13749904919715547, CAST(N'2021-04-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (444, 0.13759792476343313, CAST(N'2021-04-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (445, 0.13769687143113052, CAST(N'2021-04-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (446, 0.13779588925137665, CAST(N'2021-04-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (447, 0.13789497827533731, CAST(N'2021-04-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (448, 0.13799413855421511, CAST(N'2021-04-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (449, 0.13809337013924944, CAST(N'2021-04-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (450, 0.13819267308171657, CAST(N'2021-04-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (451, 0.13829204743292964, CAST(N'2021-04-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (452, 0.13839149324423866, CAST(N'2021-04-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (453, 0.13849101056703059, CAST(N'2021-04-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (454, 0.13859059945272934, CAST(N'2021-04-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (455, 0.1386902599527958, CAST(N'2021-04-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (456, 0.13878999211872786, CAST(N'2021-04-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (457, 0.13888979600206045, CAST(N'2021-04-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (458, 0.13898967165436552, CAST(N'2021-04-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (459, 0.13908961912725218, CAST(N'2021-04-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (460, 0.1391896384723666, CAST(N'2021-04-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (461, 0.13928972974139206, CAST(N'2021-04-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (462, 0.13938989298604909, CAST(N'2021-04-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (463, 0.13949012825809537, CAST(N'2021-04-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (464, 0.13959043560932577, CAST(N'2021-04-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (465, 0.13969081509157244, CAST(N'2021-04-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (466, 0.13979126675670478, CAST(N'2021-04-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (467, 0.13989179065662952, CAST(N'2021-04-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (468, 0.13999238684329071, CAST(N'2021-04-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (469, 0.14009305536866973, CAST(N'2021-05-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (470, 0.14019379628478534, CAST(N'2021-05-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (471, 0.14029460964369372, CAST(N'2021-05-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (472, 0.1403954954974885, CAST(N'2021-05-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (473, 0.14049645389830076, CAST(N'2021-05-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (474, 0.14059748489829904, CAST(N'2021-05-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (475, 0.14069858854968942, CAST(N'2021-05-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (476, 0.14079976490471549, CAST(N'2021-05-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (477, 0.14090101401565849, CAST(N'2021-05-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (478, 0.14100233593483713, CAST(N'2021-05-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (479, 0.14110373071460788, CAST(N'2021-05-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (480, 0.14120519840736476, CAST(N'2021-05-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (481, 0.14130673906553953, CAST(N'2021-05-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (482, 0.14140835274160157, CAST(N'2021-05-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (483, 0.14151003948805804, CAST(N'2021-05-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (484, 0.14161179935745391, CAST(N'2021-05-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (485, 0.14171363240237186, CAST(N'2021-05-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (486, 0.14181553867543242, CAST(N'2021-05-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (487, 0.14191751822929394, CAST(N'2021-05-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (488, 0.14201957111665262, CAST(N'2021-05-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (489, 0.14212169739024261, CAST(N'2021-05-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (490, 0.14222389710283592, CAST(N'2021-05-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (491, 0.14232617030724257, CAST(N'2021-05-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (492, 0.14242851705631052, CAST(N'2021-05-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (493, 0.14253093740292572, CAST(N'2021-05-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (494, 0.14263343140001217, CAST(N'2021-05-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (495, 0.14273599910053192, CAST(N'2021-05-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (496, 0.1428386405574851, CAST(N'2021-05-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (497, 0.14294135582391, CAST(N'2021-05-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (498, 0.14304414495288295, CAST(N'2021-05-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (499, 0.14314700799751856, CAST(N'2021-05-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (500, 0.14324994501096958, CAST(N'2021-06-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (501, 0.14335295604642698, CAST(N'2021-06-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (502, 0.14345604115711996, CAST(N'2021-06-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (503, 0.14355920039631603, CAST(N'2021-06-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (504, 0.14366243381732102, CAST(N'2021-06-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (505, 0.14376574147347906, CAST(N'2021-06-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (506, 0.14386912341817265, CAST(N'2021-06-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (507, 0.14397257970482266, CAST(N'2021-06-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (508, 0.14407611038688839, CAST(N'2021-06-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (509, 0.1441797155178676, CAST(N'2021-06-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (510, 0.14428339515129648, CAST(N'2021-06-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (511, 0.14438714934074978, CAST(N'2021-06-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (512, 0.14449097813984071, CAST(N'2021-06-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (513, 0.14459488160222109, CAST(N'2021-06-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (514, 0.14469885978158126, CAST(N'2021-06-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (515, 0.14480291273165019, CAST(N'2021-06-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (516, 0.14490704050619552, CAST(N'2021-06-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (517, 0.14501124315902353, CAST(N'2021-06-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (518, 0.14511552074397918, CAST(N'2021-06-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (519, 0.14521987331494618, CAST(N'2021-06-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (520, 0.14532430092584694, CAST(N'2021-06-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (521, 0.14542880363064273, CAST(N'2021-06-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (522, 0.14553338148333353, CAST(N'2021-06-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (523, 0.14563803453795821, CAST(N'2021-06-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (524, 0.14574276284859444, CAST(N'2021-06-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (525, 0.14584756646935887, CAST(N'2021-06-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (526, 0.145952445454407, CAST(N'2021-06-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (527, 0.14605739985793326, CAST(N'2021-06-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (528, 0.1461624297341711, CAST(N'2021-06-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (529, 0.14626753513739291, CAST(N'2021-06-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (530, 0.14637271612191025, CAST(N'2021-07-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (531, 0.1464779727420735, CAST(N'2021-07-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (532, 0.14658330505227232, CAST(N'2021-07-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (533, 0.1466887131069354, CAST(N'2021-07-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (534, 0.14679419696053059, CAST(N'2021-07-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (535, 0.14689975666756491, CAST(N'2021-07-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (536, 0.14700539228258455, CAST(N'2021-07-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (537, 0.14711110386017495, CAST(N'2021-07-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (538, 0.14721689145496081, CAST(N'2021-07-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (539, 0.14732275512160606, CAST(N'2021-07-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (540, 0.147428694914814, CAST(N'2021-07-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (541, 0.14753471088932724, CAST(N'2021-07-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (542, 0.14764080309992775, CAST(N'2021-07-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (543, 0.14774697160143693, CAST(N'2021-07-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (544, 0.14785321644871549, CAST(N'2021-07-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (545, 0.14795953769666376, CAST(N'2021-07-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (546, 0.14806593540022142, CAST(N'2021-07-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (547, 0.14817240961436773, CAST(N'2021-07-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (548, 0.14827896039412142, CAST(N'2021-07-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (549, 0.14838558779454084, CAST(N'2021-07-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (550, 0.14849229187072388, CAST(N'2021-07-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (551, 0.14859907267780811, CAST(N'2021-07-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (552, 0.14870593027097073, CAST(N'2021-07-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (553, 0.14881286470542859, CAST(N'2021-07-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (554, 0.14891987603643828, CAST(N'2021-07-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (555, 0.14902696431929607, CAST(N'2021-07-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (556, 0.14913412960933808, CAST(N'2021-07-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (557, 0.14924137196194015, CAST(N'2021-07-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (558, 0.14934869143251797, CAST(N'2021-07-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (559, 0.14945608807652713, CAST(N'2021-07-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (560, 0.14956356194946294, CAST(N'2021-07-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (561, 0.14967111310686079, CAST(N'2021-08-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (562, 0.14977874160429594, CAST(N'2021-08-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (563, 0.14988644749738361, CAST(N'2021-08-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (564, 0.14999423084177896, CAST(N'2021-08-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (565, 0.15010209169317729, CAST(N'2021-08-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (566, 0.15021003010731385, CAST(N'2021-08-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (567, 0.15031804613996402, CAST(N'2021-08-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (568, 0.15042613984694328, CAST(N'2021-08-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (569, 0.15053431128410719, CAST(N'2021-08-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (570, 0.15064256050735161, CAST(N'2021-08-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (571, 0.15075088757261246, CAST(N'2021-08-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (572, 0.15085929253586591, CAST(N'2021-08-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (573, 0.15096777545312845, CAST(N'2021-08-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (574, 0.15107633638045678, CAST(N'2021-08-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (575, 0.15118497537394798, CAST(N'2021-08-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (576, 0.1512936924897394, CAST(N'2021-08-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (577, 0.15140248778400878, CAST(N'2021-08-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (578, 0.15151136131297427, CAST(N'2021-08-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (579, 0.15162031313289442, CAST(N'2021-08-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (580, 0.15172934330006829, CAST(N'2021-08-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (581, 0.15183845187083536, CAST(N'2021-08-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (582, 0.15194763890157567, CAST(N'2021-08-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (583, 0.15205690444870978, CAST(N'2021-08-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (584, 0.15216624856869884, CAST(N'2021-08-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (585, 0.15227567131804459, CAST(N'2021-08-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (586, 0.15238517275328939, CAST(N'2021-08-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (587, 0.15249475293101628, CAST(N'2021-08-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (588, 0.15260441190784896, CAST(N'2021-08-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (589, 0.15271414974045189, CAST(N'2021-08-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (590, 0.15282396648553026, CAST(N'2021-08-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (591, 0.15293386219983002, CAST(N'2021-08-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (592, 0.15304383694013793, CAST(N'2021-09-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (593, 0.15315389076328159, CAST(N'2021-09-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (594, 0.15326402372612946, CAST(N'2021-09-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (595, 0.15337423588559093, CAST(N'2021-09-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (596, 0.15348452729861625, CAST(N'2021-09-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (597, 0.1535948980221967, CAST(N'2021-09-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (598, 0.15370534811336445, CAST(N'2021-09-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (599, 0.15381587762919277, CAST(N'2021-09-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (600, 0.15392648662679592, CAST(N'2021-09-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (601, 0.15403717516332924, CAST(N'2021-09-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (602, 0.15414794329598919, CAST(N'2021-09-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (603, 0.15425879108201335, CAST(N'2021-09-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (604, 0.15436971857868045, CAST(N'2021-09-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (605, 0.15448072584331035, CAST(N'2021-09-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (606, 0.15459181293326427, CAST(N'2021-09-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (607, 0.15470297990594459, CAST(N'2021-09-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (608, 0.15481422681879495, CAST(N'2021-09-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (609, 0.15492555372930034, CAST(N'2021-09-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (610, 0.15503696069498707, CAST(N'2021-09-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (611, 0.15514844777342282, CAST(N'2021-09-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (612, 0.1552600150222167, CAST(N'2021-09-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (613, 0.15537166249901918, CAST(N'2021-09-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (614, 0.15548339026152222, CAST(N'2021-09-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (615, 0.15559519836745928, CAST(N'2021-09-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (616, 0.15570708687460533, CAST(N'2021-09-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (617, 0.15581905584077685, CAST(N'2021-09-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (618, 0.15593110532383195, CAST(N'2021-09-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (619, 0.15604323538167031, CAST(N'2021-09-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (620, 0.15615544607223328, CAST(N'2021-09-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (621, 0.15626773745350381, CAST(N'2021-09-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (622, 0.15638010958350662, CAST(N'2021-10-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (623, 0.15649256252030813, CAST(N'2021-10-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (624, 0.1566050963220165, CAST(N'2021-10-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (625, 0.15671771104678167, CAST(N'2021-10-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (626, 0.15683040675279542, CAST(N'2021-10-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (627, 0.15694318349829134, CAST(N'2021-10-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (628, 0.15705604134154497, CAST(N'2021-10-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (629, 0.15716898034087368, CAST(N'2021-10-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (630, 0.15728200055463681, CAST(N'2021-10-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (631, 0.15739510204123564, CAST(N'2021-10-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (632, 0.1575082848591135, CAST(N'2021-10-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (633, 0.15762154906675568, CAST(N'2021-10-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (634, 0.15773489472268959, CAST(N'2021-10-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (635, 0.15784832188548467, CAST(N'2021-10-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (636, 0.15796183061375252, CAST(N'2021-10-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (637, 0.15807542096614688, CAST(N'2021-10-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (638, 0.15818909300136363, CAST(N'2021-10-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (639, 0.15830284677814091, CAST(N'2021-10-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (640, 0.15841668235525908, CAST(N'2021-10-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (641, 0.15853059979154074, CAST(N'2021-10-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (642, 0.15864459914585083, CAST(N'2021-10-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (643, 0.1587586804770966, CAST(N'2021-10-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (644, 0.15887284384422767, CAST(N'2021-10-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (645, 0.15898708930623606, CAST(N'2021-10-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (646, 0.15910141692215618, CAST(N'2021-10-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (647, 0.15921582675106491, CAST(N'2021-10-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (648, 0.1593303188520816, CAST(N'2021-10-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (649, 0.15944489328436812, CAST(N'2021-10-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (650, 0.15955955010712891, CAST(N'2021-10-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (651, 0.15967428937961095, CAST(N'2021-10-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (652, 0.15978911116110384, CAST(N'2021-10-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (653, 0.15990401551093977, CAST(N'2021-11-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (654, 0.16001900248849368, CAST(N'2021-11-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (655, 0.16013407215318315, CAST(N'2021-11-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (656, 0.1602492245644685, CAST(N'2021-11-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (657, 0.16036445978185279, CAST(N'2021-11-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (658, 0.16047977786488191, CAST(N'2021-11-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (659, 0.16059517887314456, CAST(N'2021-11-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (660, 0.16071066286627225, CAST(N'2021-11-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (661, 0.16082622990393938, CAST(N'2021-11-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (662, 0.1609418800458633, CAST(N'2021-11-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (663, 0.16105761335180427, CAST(N'2021-11-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (664, 0.16117342988156555, CAST(N'2021-11-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (665, 0.16128932969499338, CAST(N'2021-11-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (666, 0.16140531285197704, CAST(N'2021-11-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (667, 0.1615213794124489, CAST(N'2021-11-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (668, 0.1616375294363844, CAST(N'2021-11-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (669, 0.16175376298380212, CAST(N'2021-11-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (670, 0.16187008011476378, CAST(N'2021-11-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (671, 0.16198648088937431, CAST(N'2021-11-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (672, 0.16210296536778185, CAST(N'2021-11-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (673, 0.16221953361017782, CAST(N'2021-11-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (674, 0.16233618567679689, CAST(N'2021-11-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (675, 0.16245292162791708, CAST(N'2021-11-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (676, 0.16256974152385972, CAST(N'2021-11-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (677, 0.16268664542498951, CAST(N'2021-11-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (678, 0.16280363339171464, CAST(N'2021-11-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (679, 0.16292070548448662, CAST(N'2021-11-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (680, 0.1630378617638005, CAST(N'2021-11-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (681, 0.16315510229019484, CAST(N'2021-11-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (682, 0.16327242712425172, CAST(N'2021-11-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (683, 0.16338983632659676, CAST(N'2021-12-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (684, 0.16350732995789921, CAST(N'2021-12-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (685, 0.16362490807887195, CAST(N'2021-12-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (686, 0.16374257075027146, CAST(N'2021-12-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (687, 0.16386031803289797, CAST(N'2021-12-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (688, 0.16397814998759541, CAST(N'2021-12-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (689, 0.16409606667525148, CAST(N'2021-12-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (690, 0.16421406815679765, CAST(N'2021-12-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (691, 0.1643321544932092, CAST(N'2021-12-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (692, 0.16445032574550528, CAST(N'2021-12-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (693, 0.16456858197474886, CAST(N'2021-12-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (694, 0.1646869232420469, CAST(N'2021-12-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (695, 0.16480534960855026, CAST(N'2021-12-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (696, 0.16492386113545376, CAST(N'2021-12-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (697, 0.16504245788399627, CAST(N'2021-12-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (698, 0.16516113991546066, CAST(N'2021-12-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (699, 0.16527990729117387, CAST(N'2021-12-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (700, 0.16539876007250695, CAST(N'2021-12-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (701, 0.1655176983208751, CAST(N'2021-12-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (702, 0.16563672209773764, CAST(N'2021-12-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (703, 0.16575583146459813, CAST(N'2021-12-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (704, 0.16587502648300431, CAST(N'2021-12-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (705, 0.16599430721454825, CAST(N'2021-12-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (706, 0.16611367372086622, CAST(N'2021-12-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (707, 0.16623312606363888, CAST(N'2021-12-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (708, 0.16635266430459125, CAST(N'2021-12-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (709, 0.16647228850549267, CAST(N'2021-12-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (710, 0.16659199872815697, CAST(N'2021-12-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (711, 0.16671179503444239, CAST(N'2021-12-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (712, 0.16683167748625166, CAST(N'2021-12-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (713, 0.166951646145532, CAST(N'2021-12-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (714, 0.16707170107427527, CAST(N'2022-01-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (715, 0.16719184233451778, CAST(N'2022-01-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (716, 0.16731206998834053, CAST(N'2022-01-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (717, 0.16743238409786915, CAST(N'2022-01-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (718, 0.16755278472527391, CAST(N'2022-01-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (719, 0.16767327193276987, CAST(N'2022-01-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (720, 0.16779384578261672, CAST(N'2022-01-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (721, 0.167914506337119, CAST(N'2022-01-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (722, 0.168035253658626, CAST(N'2022-01-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (723, 0.16815608780953192, CAST(N'2022-01-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (724, 0.16827700885227576, CAST(N'2022-01-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (725, 0.16839801684934139, CAST(N'2022-01-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (726, 0.16851911186325777, CAST(N'2022-01-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (727, 0.16864029395659863, CAST(N'2022-01-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (728, 0.16876156319198282, CAST(N'2022-01-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (729, 0.16888291963207416, CAST(N'2022-01-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (730, 0.16900436333958158, CAST(N'2022-01-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (731, 0.16912589437725906, CAST(N'2022-01-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (732, 0.16924751280790573, CAST(N'2022-01-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (733, 0.16936921869436589, CAST(N'2022-01-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (734, 0.169491012099529, CAST(N'2022-01-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (735, 0.16961289308632976, CAST(N'2022-01-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (736, 0.16973486171774815, CAST(N'2022-01-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (737, 0.16985691805680939, CAST(N'2022-01-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (738, 0.16997906216658404, CAST(N'2022-01-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (739, 0.17010129411018804, CAST(N'2022-01-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (740, 0.17022361395078267, CAST(N'2022-01-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (741, 0.17034602175157468, CAST(N'2022-01-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (742, 0.17046851757581624, CAST(N'2022-01-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (743, 0.170591101486805, CAST(N'2022-01-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (744, 0.17071377354788417, CAST(N'2022-01-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (745, 0.17083653382244246, CAST(N'2022-02-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (746, 0.17095938237391417, CAST(N'2022-02-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (747, 0.17108231926577924, CAST(N'2022-02-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (748, 0.17120534456156328, CAST(N'2022-02-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (749, 0.17132845832483751, CAST(N'2022-02-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (750, 0.1714516606192189, CAST(N'2022-02-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (751, 0.17157495150837018, CAST(N'2022-02-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (752, 0.17169833105599985, CAST(N'2022-02-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (753, 0.17182179932586222, CAST(N'2022-02-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (754, 0.17194535638175745, CAST(N'2022-02-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (755, 0.17206900228753158, CAST(N'2022-02-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (756, 0.17219273710707655, CAST(N'2022-02-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (757, 0.17231656090433026, CAST(N'2022-02-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (758, 0.17244047374327656, CAST(N'2022-02-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (759, 0.17256447568794536, CAST(N'2022-02-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (760, 0.17268856680241257, CAST(N'2022-02-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (761, 0.17281274715080019, CAST(N'2022-02-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (762, 0.17293701679727633, CAST(N'2022-02-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (763, 0.17306137580605524, CAST(N'2022-02-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (764, 0.17318582424139736, CAST(N'2022-02-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (765, 0.17331036216760934, CAST(N'2022-02-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (766, 0.17343498964904408, CAST(N'2022-02-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (767, 0.17355970675010071, CAST(N'2022-02-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (768, 0.17368451353522471, CAST(N'2022-02-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (769, 0.17380941006890788, CAST(N'2022-02-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (770, 0.17393439641568842, CAST(N'2022-02-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (771, 0.17405947264015095, CAST(N'2022-02-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (772, 0.17418463880692647, CAST(N'2022-02-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (773, 0.17430989498069252, CAST(N'2022-03-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (774, 0.17443524122617313, CAST(N'2022-03-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (775, 0.17456067760813887, CAST(N'2022-03-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (776, 0.17468620419140687, CAST(N'2022-03-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (777, 0.17481182104084092, CAST(N'2022-03-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (778, 0.17493752822135139, CAST(N'2022-03-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (779, 0.17506332579789535, CAST(N'2022-03-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (780, 0.17518921383547662, CAST(N'2022-03-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (781, 0.1753151923991457, CAST(N'2022-03-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (782, 0.17544126155399992, CAST(N'2022-03-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (783, 0.17556742136518341, CAST(N'2022-03-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (784, 0.17569367189788709, CAST(N'2022-03-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (785, 0.17582001321734886, CAST(N'2022-03-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (786, 0.17594644538885346, CAST(N'2022-03-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (787, 0.17607296847773257, CAST(N'2022-03-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (788, 0.17619958254936491, CAST(N'2022-03-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (789, 0.17632628766917616, CAST(N'2022-03-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (790, 0.17645308390263906, CAST(N'2022-03-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (791, 0.17657997131527345, CAST(N'2022-03-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (792, 0.17670694997264627, CAST(N'2022-03-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (793, 0.1768340199403716, CAST(N'2022-03-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (794, 0.17696118128411073, CAST(N'2022-03-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (795, 0.17708843406957214, CAST(N'2022-03-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (796, 0.17721577836251157, CAST(N'2022-03-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (797, 0.17734321422873206, CAST(N'2022-03-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (798, 0.17747074173408395, CAST(N'2022-03-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (799, 0.17759836094446493, CAST(N'2022-03-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (800, 0.1777260719258201, CAST(N'2022-03-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (801, 0.17785387474414197, CAST(N'2022-03-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (802, 0.17798176946547048, CAST(N'2022-03-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (803, 0.17810975615589311, CAST(N'2022-03-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (804, 0.17823783488154482, CAST(N'2022-04-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (805, 0.17836600570860814, CAST(N'2022-04-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (806, 0.1784942687033132, CAST(N'2022-04-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (807, 0.17862262393193776, CAST(N'2022-04-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (808, 0.17875107146080721, CAST(N'2022-04-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (809, 0.17887961135629468, CAST(N'2022-04-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (810, 0.179008243684821, CAST(N'2022-04-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (811, 0.17913696851285474, CAST(N'2022-04-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (812, 0.17926578590691233, CAST(N'2022-04-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (813, 0.179394695933558, CAST(N'2022-04-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (814, 0.17952369865940382, CAST(N'2022-04-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (815, 0.1796527941511098, CAST(N'2022-04-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (816, 0.17978198247538385, CAST(N'2022-04-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (817, 0.17991126369898189, CAST(N'2022-04-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (818, 0.18004063788870783, CAST(N'2022-04-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (819, 0.1801701051114136, CAST(N'2022-04-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (820, 0.1802996654339992, CAST(N'2022-04-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (821, 0.1804293189234128, CAST(N'2022-04-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (822, 0.18055906564665064, CAST(N'2022-04-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (823, 0.18068890567075716, CAST(N'2022-04-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (824, 0.180818839062825, CAST(N'2022-04-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (825, 0.18094886588999509, CAST(N'2022-04-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (826, 0.18107898621945659, CAST(N'2022-04-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (827, 0.181209200118447, CAST(N'2022-04-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (828, 0.18133950765425216, CAST(N'2022-04-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (829, 0.18146990889420633, CAST(N'2022-04-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (830, 0.18160040390569215, CAST(N'2022-04-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (831, 0.18173099275614071, CAST(N'2022-04-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (832, 0.18186167551303167, CAST(N'2022-04-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (833, 0.1819924522438931, CAST(N'2022-04-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (834, 0.18212332301630169, CAST(N'2022-05-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (835, 0.1822542878978827, CAST(N'2022-05-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (836, 0.18238534695631009, CAST(N'2022-05-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (837, 0.18251650025930635, CAST(N'2022-05-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (838, 0.18264774787464283, CAST(N'2022-05-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (839, 0.18277908987013947, CAST(N'2022-05-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (840, 0.18291052631366511, CAST(N'2022-05-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (841, 0.18304205727313727, CAST(N'2022-05-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (842, 0.18317368281652241, CAST(N'2022-05-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (843, 0.18330540301183573, CAST(N'2022-05-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (844, 0.18343721792714152, CAST(N'2022-05-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (845, 0.18356912763055297, CAST(N'2022-05-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (846, 0.18370113219023207, CAST(N'2022-05-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (847, 0.18383323167439009, CAST(N'2022-05-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (848, 0.18396542615128711, CAST(N'2022-05-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (849, 0.1840977156892325, CAST(N'2022-05-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (850, 0.18423010035658463, CAST(N'2022-05-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (851, 0.18436258022175103, CAST(N'2022-05-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (852, 0.18449515535318853, CAST(N'2022-05-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (853, 0.184627825819403, CAST(N'2022-05-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (854, 0.18476059168894973, CAST(N'2022-05-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (855, 0.18489345303043325, CAST(N'2022-05-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (856, 0.18502640991250743, CAST(N'2022-05-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (857, 0.18515946240387551, CAST(N'2022-05-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (858, 0.18529261057329011, CAST(N'2022-05-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (859, 0.1854258544895534, CAST(N'2022-05-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (860, 0.18555919422151684, CAST(N'2022-05-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (861, 0.18569262983808155, CAST(N'2022-05-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (862, 0.1858261614081981, CAST(N'2022-05-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (863, 0.18595978900086671, CAST(N'2022-05-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (864, 0.18609351268513727, CAST(N'2022-05-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (865, 0.18622733253010915, CAST(N'2022-06-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (866, 0.18636124860493156, CAST(N'2022-06-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (867, 0.18649526097880337, CAST(N'2022-06-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (868, 0.18662936972097319, CAST(N'2022-06-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (869, 0.18676357490073955, CAST(N'2022-06-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (870, 0.18689787658745063, CAST(N'2022-06-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (871, 0.18703227485050469, CAST(N'2022-06-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (872, 0.18716676975934968, CAST(N'2022-06-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (873, 0.18730136138348363, CAST(N'2022-06-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (874, 0.18743604979245448, CAST(N'2022-06-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (875, 0.18757083505586025, CAST(N'2022-06-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (876, 0.18770571724334892, CAST(N'2022-06-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (877, 0.18784069642461865, CAST(N'2022-06-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (878, 0.18797577266941756, CAST(N'2022-06-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (879, 0.18811094604754416, CAST(N'2022-06-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (880, 0.18824621662884691, CAST(N'2022-06-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (881, 0.18838158448322473, CAST(N'2022-06-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (882, 0.1885170496806266, CAST(N'2022-06-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (883, 0.18865261229105193, CAST(N'2022-06-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (884, 0.18878827238455043, CAST(N'2022-06-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (885, 0.18892403003122216, CAST(N'2022-06-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (886, 0.18905988530121759, CAST(N'2022-06-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (887, 0.18919583826473771, CAST(N'2022-06-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (888, 0.18933188899203388, CAST(N'2022-06-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (889, 0.18946803755340805, CAST(N'2022-06-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (890, 0.1896042840192127, CAST(N'2022-06-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (891, 0.1897406284598509, CAST(N'2022-06-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (892, 0.18987707094577641, CAST(N'2022-06-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (893, 0.19001361154749347, CAST(N'2022-06-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (894, 0.1901502503355573, CAST(N'2022-06-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (895, 0.19028698738057359, CAST(N'2022-07-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (896, 0.19042382275319897, CAST(N'2022-07-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (897, 0.19056075652414081, CAST(N'2022-07-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (898, 0.1906977887641573, CAST(N'2022-07-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (899, 0.1908349195440576, CAST(N'2022-07-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (900, 0.19097214893470177, CAST(N'2022-07-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (901, 0.19110947700700068, CAST(N'2022-07-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (902, 0.19124690383191639, CAST(N'2022-07-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (903, 0.19138442948046192, CAST(N'2022-07-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (904, 0.19152205402370137, CAST(N'2022-07-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (905, 0.19165977753274979, CAST(N'2022-07-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (906, 0.19179760007877361, CAST(N'2022-07-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (907, 0.19193552173299025, CAST(N'2022-07-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (908, 0.19207354256666839, CAST(N'2022-07-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (909, 0.1922116626511281, CAST(N'2022-07-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (910, 0.19234988205774051, CAST(N'2022-07-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (911, 0.19248820085792823, CAST(N'2022-07-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (912, 0.1926266191231652, CAST(N'2022-07-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (913, 0.19276513692497663, CAST(N'2022-07-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (914, 0.19290375433493939, CAST(N'2022-07-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (915, 0.19304247142468164, CAST(N'2022-07-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (916, 0.19318128826588313, CAST(N'2022-07-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (917, 0.19332020493027513, CAST(N'2022-07-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (918, 0.19345922148964048, CAST(N'2022-07-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (919, 0.19359833801581369, CAST(N'2022-07-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (920, 0.19373755458068087, CAST(N'2022-07-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (921, 0.19387687125617983, CAST(N'2022-07-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (922, 0.19401628811430016, CAST(N'2022-07-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (923, 0.19415580522708317, CAST(N'2022-07-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (924, 0.19429542266662195, CAST(N'2022-07-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (925, 0.19443514050506153, CAST(N'2022-07-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (926, 0.19457495881459871, CAST(N'2022-08-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (927, 0.1947148776674823, CAST(N'2022-08-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (928, 0.19485489713601295, CAST(N'2022-08-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (929, 0.19499501729254348, CAST(N'2022-08-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (930, 0.19513523820947856, CAST(N'2022-08-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (931, 0.195275559959275, CAST(N'2022-08-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (932, 0.19541598261444176, CAST(N'2022-08-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (933, 0.19555650624753981, CAST(N'2022-08-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (934, 0.19569713093118241, CAST(N'2022-08-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (935, 0.195837856738035, CAST(N'2022-08-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (936, 0.19597868374081531, CAST(N'2022-08-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (937, 0.19611961201229333, CAST(N'2022-08-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (938, 0.19626064162529136, CAST(N'2022-08-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (939, 0.1964017726526841, CAST(N'2022-08-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (940, 0.19654300516739864, CAST(N'2022-08-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (941, 0.19668433924241452, CAST(N'2022-08-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (942, 0.19682577495076373, CAST(N'2022-08-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (943, 0.19696731236553083, CAST(N'2022-08-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (944, 0.19710895155985289, CAST(N'2022-08-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (945, 0.1972506926069196, CAST(N'2022-08-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (946, 0.19739253557997319, CAST(N'2022-08-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (947, 0.19753448055230877, CAST(N'2022-08-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (948, 0.19767652759727392, CAST(N'2022-08-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (949, 0.19781867678826912, CAST(N'2022-08-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (950, 0.19796092819874761, CAST(N'2022-08-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (951, 0.1981032819022153, CAST(N'2022-08-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (952, 0.19824573797223119, CAST(N'2022-08-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (953, 0.19838829648240705, CAST(N'2022-08-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (954, 0.19853095750640751, CAST(N'2022-08-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (955, 0.1986737211179504, CAST(N'2022-08-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (956, 0.19881658739080632, CAST(N'2022-08-31T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (957, 0.19895955639879903, CAST(N'2022-09-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (958, 0.19910262821580543, CAST(N'2022-09-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (959, 0.19924580291575544, CAST(N'2022-09-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (960, 0.19938908057263213, CAST(N'2022-09-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (961, 0.19953246126047192, CAST(N'2022-09-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (962, 0.19967594505336431, CAST(N'2022-09-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (963, 0.19981953202545225, CAST(N'2022-09-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (964, 0.19996322225093172, CAST(N'2022-09-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (965, 0.20010701580405235, CAST(N'2022-09-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (966, 0.20025091275911705, CAST(N'2022-09-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (967, 0.20039491319048217, CAST(N'2022-09-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (968, 0.20053901717255743, CAST(N'2022-09-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (969, 0.20068322477980621, CAST(N'2022-09-13T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (970, 0.20082753608674536, CAST(N'2022-09-14T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (971, 0.20097195116794531, CAST(N'2022-09-15T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (972, 0.20111647009803019, CAST(N'2022-09-16T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (973, 0.20126109295167771, CAST(N'2022-09-17T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (974, 0.20140581980361927, CAST(N'2022-09-18T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (975, 0.20155065072864009, CAST(N'2022-09-19T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (976, 0.20169558580157904, CAST(N'2022-09-20T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (977, 0.20184062509732895, CAST(N'2022-09-21T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (978, 0.20198576869083645, CAST(N'2022-09-22T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (979, 0.202131016657102, CAST(N'2022-09-23T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (980, 0.20227636907118013, CAST(N'2022-09-24T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (981, 0.20242182600817921, CAST(N'2022-09-25T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (982, 0.2025673875432617, CAST(N'2022-09-26T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (983, 0.20271305375164408, CAST(N'2022-09-27T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (984, 0.20285882470859687, CAST(N'2022-09-28T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (985, 0.20300470048944483, CAST(N'2022-09-29T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (986, 0.20315068116956681, CAST(N'2022-09-30T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (987, 0.20329676682439585, CAST(N'2022-10-01T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (988, 0.20344295752941924, CAST(N'2022-10-02T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (989, 0.20358925336017864, CAST(N'2022-10-03T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (990, 0.20373565439226993, CAST(N'2022-10-04T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (991, 0.20388216070134341, CAST(N'2022-10-05T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (992, 0.20402877236310377, CAST(N'2022-10-06T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (993, 0.20417548945331004, CAST(N'2022-10-07T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (994, 0.20432231204777593, CAST(N'2022-10-08T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (995, 0.20446924022236948, CAST(N'2022-10-09T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (996, 0.20461627405301341, CAST(N'2022-10-10T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (997, 0.2047634136156849, CAST(N'2022-10-11T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (998, 0.20491065898641592, CAST(N'2022-10-12T01:00:01.667' AS DateTime))
GO
INSERT [dbo].[TokensCost] ([Id], [Value], [Date]) VALUES (999, 0.20505801024129308, CAST(N'2022-10-13T01:00:01.667' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TokensCost] OFF
GO
SET IDENTITY_INSERT [dbo].[TokensSelling] ON 
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1, 10, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 1, CAST(N'2019-10-28T05:11:50.973' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (2, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:11:56.857' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (3, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-10-28T05:12:04.343' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1002, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-11-16T16:47:52.043' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1003, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 10, CAST(N'2019-11-16T16:47:57.440' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1004, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-11-16T16:48:02.697' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1005, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2019-12-29T01:07:44.110' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1006, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 100, CAST(N'2020-01-08T02:34:11.297' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1007, 50, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1, 5, CAST(N'2020-01-08T02:34:17.660' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1008, 1000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1003835903199823, 100.3835903199823, CAST(N'2020-01-23T08:05:17.807' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1009, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10038360001571074, 10.038360001571077, CAST(N'2020-01-23T08:05:36.167' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1010, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054117204175812, 199.97639119105688, CAST(N'2020-01-25T12:36:18.587' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1011, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.100541395390234, 199.97683543117543, CAST(N'2020-01-25T12:40:54.473' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1012, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054140833797172, 199.97686118422575, CAST(N'2020-01-25T12:41:10.183' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1013, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.1005414253318775, 199.97689498510431, CAST(N'2020-01-25T12:41:31.930' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1014, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.1005414358519144, 199.97691590945777, CAST(N'2020-01-25T12:41:44.940' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1015, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.1005414447534841, 199.97693361467989, CAST(N'2020-01-25T12:41:55.533' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1016, 1989, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 0.10054145689198824, 199.97695775816459, CAST(N'2020-01-25T12:42:10.930' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1017, 4946, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.10107930342091472, 499.93823471984416, CAST(N'2020-02-01T23:10:19.850' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1018, 100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1016070904429132, 10.16070904429132, CAST(N'2020-02-09T04:26:20.730' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1019, 10000, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 0.1087826043908928, 1087.8260439089281, CAST(N'2020-05-14T02:39:00.740' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1020, 24024, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 0.1122584369374917, 2696.8966889863004, CAST(N'2020-06-26T21:21:27.973' AS DateTime))
GO
INSERT [dbo].[TokensSelling] ([Id], [Count], [UserId], [CostOneToken], [FullCost], [WhenDate]) VALUES (1021, 23978, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 0.11339146847960956, 2718.9006312040779, CAST(N'2020-07-10T20:37:19.387' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TokensSelling] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (56, N'234ee901-21d6-4952-b871-b815b148fe46', N'92cfb222-e607-4103-8d48-02826604aa12', N'ODMEN', 0, CAST(N'2020-11-15T11:41:45.383' AS DateTime), NULL, 344347, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (1, N'234ee901-21d6-4952-b871-b815b148fe46', N'd605cfec-b531-4b21-a58c-074b035402af', N'Yaexcluziv', 0, CAST(N'2020-07-26T23:50:40.643' AS DateTime), NULL, 797184, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (2, N'234ee901-21d6-4952-b871-b815b148fe46', N'b98b7ebc-4d5e-405b-88d8-087421c50b8e', N'hhh', 0, CAST(N'2019-06-01T16:02:48.657' AS DateTime), N'', 704037, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (3, N'234ee901-21d6-4952-b871-b815b148fe46', N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', N'Маким', 0, CAST(N'2020-07-26T13:29:17.657' AS DateTime), NULL, 751789, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (4, N'234ee901-21d6-4952-b871-b815b148fe46', N'f42ba606-48bf-45ef-9ea4-1ee8c44add71', N'kkkr', 0, CAST(N'2019-08-23T23:32:27.873' AS DateTime), N'', 906826, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (5, N'234ee901-21d6-4952-b871-b815b148fe46', N'90553147-77ee-4561-b0f7-1f239afac377', N'Hhhgg', 0, CAST(N'2019-07-09T20:09:44.703' AS DateTime), N'', 441934, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (55, N'234ee901-21d6-4952-b871-b815b148fe46', N'bd4551af-fc28-4b85-b147-20a051676b21', N'admin', 0, CAST(N'2021-01-16T16:23:18.067' AS DateTime), NULL, 86709, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'@', NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (6, N'234ee901-21d6-4952-b871-b815b148fe46', N'69c917b6-c2a7-4fc6-9b13-310ce4b09d33', N'mmmkkk', 0, CAST(N'2020-01-14T05:31:31.833' AS DateTime), NULL, 39543, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (59, N'234ee901-21d6-4952-b871-b815b148fe46', N'bf6840b7-dc4d-4c1e-8ab5-32c86bb084c5', N'Vlad', 0, CAST(N'2020-12-03T07:41:02.027' AS DateTime), NULL, 787598, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (7, N'234ee901-21d6-4952-b871-b815b148fe46', N'497b82eb-2f1f-410d-a71c-36b45111b74b', N'alex', 0, CAST(N'2020-03-31T09:56:46.117' AS DateTime), NULL, 236952, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (8, N'234ee901-21d6-4952-b871-b815b148fe46', N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', N'qqq', 0, CAST(N'2020-11-22T20:34:38.430' AS DateTime), NULL, 591821, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (9, N'234ee901-21d6-4952-b871-b815b148fe46', N'2e416d84-4e86-468a-8088-4d9a70ffb0de', N'kkkkkk', 0, CAST(N'2020-01-15T19:53:43.910' AS DateTime), NULL, 900746, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (10, N'234ee901-21d6-4952-b871-b815b148fe46', N'53446782-b6e0-43cf-a718-4e445e853160', N'Necromant', 0, CAST(N'2020-09-11T18:01:25.340' AS DateTime), NULL, 840105, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (11, N'234ee901-21d6-4952-b871-b815b148fe46', N'e407837f-efe8-4ac8-bf50-4fcf3674c9c6', N'Intelligent', 0, CAST(N'2020-01-25T09:11:32.127' AS DateTime), NULL, 948032, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (12, N'234ee901-21d6-4952-b871-b815b148fe46', N'eb192af4-6fa7-4f34-ac02-5058cc5d424b', N'www', 0, CAST(N'2020-10-08T20:19:12.347' AS DateTime), NULL, 419340, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (13, N'234ee901-21d6-4952-b871-b815b148fe46', N'3b767454-13e2-4213-a8d4-51d5b07b5fb1', N'ashfaq', 0, CAST(N'2019-09-16T07:48:58.157' AS DateTime), NULL, 926928, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (14, N'234ee901-21d6-4952-b871-b815b148fe46', N'f95dea8f-3fae-4c54-be1d-572e5dfe9116', N'mmm422t', 0, CAST(N'2019-10-02T21:34:45.233' AS DateTime), NULL, 994016, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (15, N'234ee901-21d6-4952-b871-b815b148fe46', N'b1e3c30f-91b1-48c1-a2e4-5c8cc7b75dc7', N'nnn', 0, CAST(N'2019-08-24T12:49:22.433' AS DateTime), N'', 911744, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (16, N'234ee901-21d6-4952-b871-b815b148fe46', N'31c4e8bb-9c5b-45d7-8fa0-65c75f87e121', N'Crax', 0, CAST(N'2020-11-21T11:48:46.193' AS DateTime), NULL, 738646, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (17, N'234ee901-21d6-4952-b871-b815b148fe46', N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', N'Antares', 0, CAST(N'2020-11-21T11:47:48.350' AS DateTime), NULL, 861572, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (18, N'234ee901-21d6-4952-b871-b815b148fe46', N'ee678bfb-bf49-4050-aad3-6c5025d3f0e5', N'brsk', 0, CAST(N'2020-07-09T06:59:51.217' AS DateTime), NULL, 547539, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (19, N'234ee901-21d6-4952-b871-b815b148fe46', N'c11636fe-d0d9-4a60-8647-6f00f6154c29', N'dddddd', 0, CAST(N'2019-05-29T23:30:27.900' AS DateTime), N'', 826476, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (20, N'234ee901-21d6-4952-b871-b815b148fe46', N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', N'Николай', 0, CAST(N'2020-01-26T20:08:41.400' AS DateTime), NULL, 774826, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (21, N'234ee901-21d6-4952-b871-b815b148fe46', N'4d54d89b-7e4c-40a6-8638-739bdd618947', N'lll', 0, CAST(N'2020-03-08T11:21:14.627' AS DateTime), NULL, 354503, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (22, N'234ee901-21d6-4952-b871-b815b148fe46', N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'mmm', 0, CAST(N'2020-08-16T11:17:18.843' AS DateTime), N'', 452288, N'8-999-321-55-55', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (23, N'234ee901-21d6-4952-b871-b815b148fe46', N'5ff870c8-71e7-4738-b7c0-81a3162a3cb0', N'dennismen', 0, CAST(N'2020-01-25T17:53:37.020' AS DateTime), NULL, 996548, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (24, N'234ee901-21d6-4952-b871-b815b148fe46', N'037bc9a7-a702-4f15-9695-830d47fc9197', N'Ranetka', 0, CAST(N'2020-01-30T03:03:45.433' AS DateTime), NULL, 423959, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (25, N'234ee901-21d6-4952-b871-b815b148fe46', N'a4dbb6d6-0937-49ca-a2dc-83c522007c61', N'nnnnkkk', 0, CAST(N'2019-10-04T14:02:15.637' AS DateTime), NULL, 94750, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (26, N'234ee901-21d6-4952-b871-b815b148fe46', N'26edc365-d524-48d2-b456-88abff129efd', N'Gromi2k', 0, CAST(N'2020-01-25T20:14:14.483' AS DateTime), NULL, 887299, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (27, N'234ee901-21d6-4952-b871-b815b148fe46', N'17dd7a4a-66e6-47a2-ad13-89dba1ccadb7', N'Dmitrii', 0, CAST(N'2020-01-25T08:06:22.300' AS DateTime), NULL, 974693, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (28, N'234ee901-21d6-4952-b871-b815b148fe46', N'd0672d7a-632f-4901-a9d1-8b72e6c35869', N'maps', 0, CAST(N'2020-04-17T08:28:06.240' AS DateTime), NULL, 782276, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (29, N'234ee901-21d6-4952-b871-b815b148fe46', N'cad96d26-bfd4-48a3-8999-8e18a4d02357', N'Dmitriy', 0, CAST(N'2019-08-24T19:38:46.787' AS DateTime), NULL, 614324, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (30, N'234ee901-21d6-4952-b871-b815b148fe46', N'1e256f7a-97fc-453a-9f0b-957c99c75b06', N'Sm1le', 0, CAST(N'2018-12-17T17:29:28.063' AS DateTime), N'', 962296, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (31, N'234ee901-21d6-4952-b871-b815b148fe46', N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', N'Onward', 0, CAST(N'2020-01-24T16:48:13.300' AS DateTime), NULL, 866724, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (32, N'234ee901-21d6-4952-b871-b815b148fe46', N'9350b6bd-62dc-4e69-86fc-abd4fdfed066', N'kkke', 0, CAST(N'2019-08-24T12:50:19.637' AS DateTime), NULL, 715388, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (33, N'234ee901-21d6-4952-b871-b815b148fe46', N'8c335406-4e98-462f-90ca-ac158cdd1142', N'Kantemir', 0, CAST(N'2020-01-25T17:53:52.323' AS DateTime), NULL, 803187, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (34, N'234ee901-21d6-4952-b871-b815b148fe46', N'd9112c68-192f-40f5-b678-ad25e61d092e', N'kkk', 0, CAST(N'2019-08-23T23:28:22.187' AS DateTime), N'', 719017, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (35, N'234ee901-21d6-4952-b871-b815b148fe46', N'4f8e9d04-5c62-405a-8011-b207702f3b54', N'qwer', 0, CAST(N'2019-07-09T19:52:43.577' AS DateTime), N'', 688961, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (36, N'234ee901-21d6-4952-b871-b815b148fe46', N'709c2b20-4bb0-4369-bd80-b53ed855eb19', N'mmrrr', 0, CAST(N'2019-12-28T21:52:00.770' AS DateTime), NULL, 613952, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (37, N'234ee901-21d6-4952-b871-b815b148fe46', N'ff342ff7-3798-4f20-8c15-bb16ad9e3100', N'Макстм', 0, CAST(N'2020-03-19T14:41:49.413' AS DateTime), NULL, 231639, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (57, N'234ee901-21d6-4952-b871-b815b148fe46', N'e7bc0057-d3b9-4791-a9ea-c4589500ace9', N'Matthew Rentoolo', 0, CAST(N'2020-11-20T20:59:40.820' AS DateTime), N'qwerty123', 659468, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'@', NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (38, N'234ee901-21d6-4952-b871-b815b148fe46', N'0677b5f2-2ec7-4bbe-89f7-c6ed48cb9dca', N'freebar4ik', 0, CAST(N'2020-01-24T19:05:33.550' AS DateTime), NULL, 132866, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (39, N'234ee901-21d6-4952-b871-b815b148fe46', N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', N'Павел Суворов', 0, CAST(N'2020-01-23T19:29:33.030' AS DateTime), NULL, 123043, N' 79286664808', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (40, N'234ee901-21d6-4952-b871-b815b148fe46', N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', N'Maksimrentoolo', 0, CAST(N'2020-01-14T19:30:06.837' AS DateTime), NULL, 529238, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (41, N'234ee901-21d6-4952-b871-b815b148fe46', N'f7db8012-d9f1-4cfd-b8c3-ce067edd6d19', N'lol1212', 0, CAST(N'2020-01-26T12:26:57.047' AS DateTime), NULL, 551658, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (42, N'234ee901-21d6-4952-b871-b815b148fe46', N'a52f6fd5-0b77-4345-b7e1-ce1ede063d64', N'mmmm', 0, CAST(N'2019-06-02T02:11:44.807' AS DateTime), N'', 968299, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (43, N'234ee901-21d6-4952-b871-b815b148fe46', N'61066082-72b4-477f-92dc-d1af87de7de9', N'rrr', 0, CAST(N'2020-04-29T14:25:03.680' AS DateTime), NULL, 575586, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (44, N'234ee901-21d6-4952-b871-b815b148fe46', N'cddd0879-5144-4527-a449-d39c7642aac5', N'kkkk', 0, CAST(N'2019-10-02T18:28:42.643' AS DateTime), NULL, 179591, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (45, N'234ee901-21d6-4952-b871-b815b148fe46', N'f574ce33-7829-4678-81cb-d7daa7fe550b', N'mmm22', 0, CAST(N'2019-09-27T14:08:42.763' AS DateTime), NULL, 402868, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (46, N'234ee901-21d6-4952-b871-b815b148fe46', N'f4b751df-6328-4553-8f4c-db280ef332d3', N'qwerqwer', 0, CAST(N'2018-12-17T14:43:57.383' AS DateTime), N'', 200842, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (47, N'234ee901-21d6-4952-b871-b815b148fe46', N'314bd290-5fc5-4a93-8131-db644b83aaed', N'kkkuuu', 0, CAST(N'2019-10-30T17:01:54.853' AS DateTime), NULL, 559633, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (48, N'234ee901-21d6-4952-b871-b815b148fe46', N'91dc9014-911a-43cf-b55f-dd4ace944035', N'bbb', 0, CAST(N'2019-10-04T09:54:08.947' AS DateTime), NULL, 468866, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (58, N'234ee901-21d6-4952-b871-b815b148fe46', N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', N'alexpigalyov', 0, CAST(N'2020-11-30T21:42:20.957' AS DateTime), NULL, 303118, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (49, N'234ee901-21d6-4952-b871-b815b148fe46', N'023461b1-28b3-4e5b-b5bc-e2a179b1b032', N'Nadinaleksandr1', 0, CAST(N'2020-01-25T07:05:55.580' AS DateTime), NULL, 882380, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (50, N'234ee901-21d6-4952-b871-b815b148fe46', N'996da0e7-d189-47a3-8436-e54b1572872d', N'EgorIgorevich', 0, CAST(N'2020-01-27T14:21:37.730' AS DateTime), NULL, 402420, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (51, N'234ee901-21d6-4952-b871-b815b148fe46', N'20a94868-76d0-456d-8268-e7c1318f03d3', N'mmmyyy', 0, CAST(N'2019-07-26T14:15:04.167' AS DateTime), N'', 132536, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (52, N'234ee901-21d6-4952-b871-b815b148fe46', N'dc40c4f1-f346-48fe-b4b3-fc629df690ff', N'Yyy', 0, CAST(N'2019-10-03T06:09:23.130' AS DateTime), NULL, 304252, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (53, N'234ee901-21d6-4952-b871-b815b148fe46', N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', N'Lanasimones', 0, CAST(N'2020-01-22T10:37:37.560' AS DateTime), NULL, 886373, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate], [Pwd], [PublicId], [Communication], [ReffAdd], [LastGeoposition], [Language], [Sex], [Interests], [WorkPlace], [AboutUser], [BirthDay], [UniqueUserName], [SelectedCity]) VALUES (54, N'234ee901-21d6-4952-b871-b815b148fe46', N'9891d3d6-e7eb-4911-98f5-fdde0c32b9cf', N'Mary', 0, CAST(N'2020-02-07T02:52:07.017' AS DateTime), NULL, 802380, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'92cfb222-e607-4103-8d48-02826604aa12', N'211ee111-19d6-4951-b87c-b215b542fe11')
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'8b6f8834-7b96-43e1-9dec-16115fd48554')
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'211ee111-19d6-4951-b87c-b215b542fe11')
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', N'234ee951-11d6-2151-b87c-b815b542fe41')
GO
INSERT [dbo].[UsersOpenAuthAccounts] ([ApplicationName], [ProviderName], [ProviderUserId], [ProviderUserName], [MembershipUserName], [LastUsedUtc]) VALUES (N'/', N'google', N'107715615617129476587', N'Matthew Rentoolo', N'Matthew Rentoolo', NULL)
GO
INSERT [dbo].[UsersOpenAuthData] ([ApplicationName], [MembershipUserName], [HasLocalPassword]) VALUES (N'/', N'Matthew Rentoolo', 1)
GO
SET IDENTITY_INSERT [dbo].[UserViews] ON 
GO
INSERT [dbo].[UserViews] ([Id], [ObjectId], [Type], [UserId], [Date]) VALUES (1, 20041, 1, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', CAST(N'2020-09-18T19:41:39.783' AS DateTime))
GO
INSERT [dbo].[UserViews] ([Id], [ObjectId], [Type], [UserId], [Date]) VALUES (2, 20041, 1, N'eb192af4-6fa7-4f34-ac02-5058cc5d424b', CAST(N'2020-10-08T23:19:40.247' AS DateTime))
GO
INSERT [dbo].[UserViews] ([Id], [ObjectId], [Type], [UserId], [Date]) VALUES (3, 20041, 1, N'92cfb222-e607-4103-8d48-02826604aa12', CAST(N'2020-11-15T13:39:42.870' AS DateTime))
GO
INSERT [dbo].[UserViews] ([Id], [ObjectId], [Type], [UserId], [Date]) VALUES (4, 20042, 1, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', CAST(N'2020-11-28T01:23:11.873' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserViews] OFF
GO
SET IDENTITY_INSERT [dbo].[Wallets] ON 
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 1, 19805.082951233384, CAST(N'2018-12-13T18:25:08.420' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (2, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 2, 515, CAST(N'2018-12-18T11:42:46.400' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (3, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 3, 212, CAST(N'2018-12-18T11:43:00.200' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (4, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 4, 10024, CAST(N'2018-12-18T11:43:22.290' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (5, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 5, 22, CAST(N'2018-12-18T11:43:37.243' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (6, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 6, 700, CAST(N'2018-12-18T11:43:52.710' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (7, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 7, 28, CAST(N'2018-12-18T11:44:13.077' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (9, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 8, 1976941, CAST(N'2019-10-28T05:10:59.307' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1008, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 1, 0, CAST(N'2020-01-14T01:14:07.293' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1009, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 1, 0, CAST(N'2020-01-14T01:14:27.770' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1010, N'c94e32bb-d742-4f1e-b4b4-cddf599472b8', 8, 1000, CAST(N'2020-01-14T01:39:34.627' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1011, N'7849bd5d-c3e5-4aed-9248-cd9ad30284ef', 8, 2000, CAST(N'2020-01-16T00:13:25.857' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1012, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 1, 0.13902826915824562, CAST(N'2020-01-21T13:04:09.333' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1013, N'd605cfec-b531-4b21-a58c-074b035402af', 1, 0.1132013899938471, CAST(N'2020-01-22T11:27:44.597' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1014, N'd605cfec-b531-4b21-a58c-074b035402af', 8, 996, CAST(N'2020-01-22T11:32:56.970' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1015, N'16b1177f-e2c5-494d-bc58-fc6646a4b17f', 8, 2990, CAST(N'2020-01-22T13:38:11.897' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1016, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 1, 0.012498512345928248, CAST(N'2020-01-24T17:53:43.390' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1017, N'5b976a52-96f6-4645-95ac-a77abb4c3a5a', 8, 995, CAST(N'2020-01-24T19:49:37.447' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1018, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 1, 10.020077259151025, CAST(N'2020-01-25T12:33:28.300' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1019, N'e103ddb4-eae3-47d4-8db2-65cafa82fe07', 8, 0, CAST(N'2020-01-25T12:36:05.280' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1020, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 1, 0.0611394369568643, CAST(N'2020-01-26T18:31:14.810' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1021, N'78642b4e-de5a-4b81-9cf4-723cae3ff5eb', 8, 19874, CAST(N'2020-01-26T18:35:20.417' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1022, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 1, 0.0013308665561453379, CAST(N'2020-03-18T23:04:28.950' AS DateTime))
GO
INSERT [dbo].[Wallets] ([Id], [UserId], [CurrencyId], [Value], [CreateDate]) VALUES (1023, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 8, 0, CAST(N'2020-03-18T23:05:35.203' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Wallets] OFF
GO
SET IDENTITY_INSERT [dbo].[Watched] ON 
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (1, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-01-15T20:09:33.500' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (2, N'5ff870c8-71e7-4738-b7c0-81a3162a3cb0', 30, CAST(N'2020-01-25T20:55:41.363' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (3, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 30, CAST(N'2020-01-28T04:40:41.597' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (4, N'd0672d7a-632f-4901-a9d1-8b72e6c35869', 27, CAST(N'2020-04-17T11:28:59.150' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (5, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-04-27T14:40:53.357' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (6, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-04-27T14:40:59.633' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (7, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-04-27T14:41:58.487' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (8, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 28, CAST(N'2020-04-27T14:42:12.313' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (9, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-04-29T00:47:26.497' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T05:50:58.623' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (11, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:03:18.157' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (12, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:03:23.243' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (13, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:04:10.033' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (14, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:04:36.667' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (15, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:04:44.420' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (16, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:07:41.353' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (17, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:07:46.353' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (18, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:08:44.273' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (19, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:14:54.720' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:14:57.140' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (21, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:15:15.673' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (22, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:16:27.150' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (23, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-05T06:16:32.877' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (24, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-07T16:53:07.633' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (25, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-07T16:53:13.040' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (26, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-07T16:55:23.897' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (27, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-10T23:28:39.580' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (28, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-10T23:29:04.730' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (29, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:32:40.937' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:47:15.623' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (31, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:47:19.833' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (32, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-10T23:47:48.703' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (33, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-10T23:48:36.350' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (34, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-10T23:56:48.570' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (35, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:59:14.707' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (36, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:59:20.440' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (37, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:59:25.490' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (38, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:59:30.167' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (39, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-10T23:59:43.817' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (40, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:01:21.263' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (41, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:01:25.180' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (42, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:01:52.007' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (43, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:03:27.983' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (44, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:03:33.900' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (45, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-11T00:04:21.207' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (46, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:16:17.677' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (47, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T00:16:24.683' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (48, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T03:10:52.130' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (49, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T03:10:59.190' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (50, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T03:11:51.940' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (51, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T03:12:05.190' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (52, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10030, CAST(N'2020-05-11T03:12:08.530' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (53, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-05-11T03:12:30.407' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (54, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-05-11T03:12:39.930' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (55, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-05-11T03:13:46.350' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (56, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-05-11T03:13:51.780' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (57, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-05-11T03:14:01.533' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (58, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 32, CAST(N'2020-05-11T03:15:03.890' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (59, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:22:34.233' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (60, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:22:39.357' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (61, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:22:50.197' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (62, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:26:31.713' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (63, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:26:36.713' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (64, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:28:29.820' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (65, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:28:34.153' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (66, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:30:40.373' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (67, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:30:44.867' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (68, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:31:30.170' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (69, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:42:29.400' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (70, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:43:21.527' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (71, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:43:26.233' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (72, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:44:58.500' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (73, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:56:37.747' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (74, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:56:53.467' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (75, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:59:22.420' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (76, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:59:26.990' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (77, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:59:34.607' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (78, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T03:59:47.567' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (79, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:04:48.740' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (80, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:04:54.393' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (81, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:05:19.820' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (82, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:06:19.737' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (83, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:06:24.913' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (84, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:06:44.927' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (85, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:06:58.603' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (86, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:07:52.343' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (87, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:07:57.060' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (88, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:08:29.317' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (89, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:08:33.123' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (90, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:08:57.047' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (91, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:09:37.937' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (92, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:09:42.867' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (93, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:09:56.803' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (94, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:09:58.847' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (95, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:10:05.780' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (96, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:11:29.770' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (97, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:11:35.407' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (98, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:13:40.243' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (99, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:13:48.790' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (100, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:15:29.460' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (101, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:15:34.560' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (102, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:16:18.113' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (103, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:16:21.967' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (104, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:18:19.263' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (105, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:18:22.857' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (106, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-11T04:20:16.460' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (107, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 31, CAST(N'2020-05-12T20:27:54.843' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (108, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10031, CAST(N'2020-05-30T20:04:58.223' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (109, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10032, CAST(N'2020-06-17T16:50:34.803' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (110, N'4bb6fe84-b80e-4b7a-a62e-1d2cb44a014e', 10034, CAST(N'2020-06-26T23:49:29.570' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (111, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10035, CAST(N'2020-07-16T01:22:09.903' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (112, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 10035, CAST(N'2020-07-16T01:45:22.183' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10111, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20036, CAST(N'2020-08-16T12:14:18.200' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10112, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20036, CAST(N'2020-08-16T12:15:25.847' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10113, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20036, CAST(N'2020-08-16T12:15:29.147' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10114, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20036, CAST(N'2020-08-16T12:15:31.693' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10115, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20036, CAST(N'2020-08-16T12:15:34.080' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10116, N'8b79ff6c-f4a8-452d-b5ac-756ddf0d6c59', 20039, CAST(N'2020-08-16T14:06:01.230' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10117, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-18T19:42:25.227' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (10118, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-18T20:32:28.377' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20117, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:06:27.170' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20118, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:19:02.420' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20119, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:25:41.993' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20120, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:28:33.110' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20121, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:28:55.140' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20122, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:29:54.167' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20123, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:33:39.713' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20124, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:36:06.420' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20125, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-23T16:45:10.720' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20126, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:09:18.657' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20127, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:13:15.887' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20128, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:14:40.127' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20129, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:16:05.910' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20130, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:19:54.977' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20131, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:23:56.730' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20132, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:26:00.980' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20133, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:26:40.303' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20134, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:43:31.180' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20135, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T14:49:56.737' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20136, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:18:05.153' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20137, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:24:15.617' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20138, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:28:18.570' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20139, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:30:39.450' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20140, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:33:39.083' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20141, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:37:31.117' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20142, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:39:54.673' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20143, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:40:07.520' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20144, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T15:40:15.317' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20145, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:41:12.270' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20146, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:41:12.283' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20147, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:42:24.420' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20148, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:43:51.047' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20149, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:44:23.500' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20150, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:44:45.380' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20151, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:45:47.927' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20152, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:48:42.257' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20153, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:50:09.800' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20154, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T16:52:06.780' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20155, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T17:02:03.630' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20156, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T17:06:19.117' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20157, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T17:06:22.180' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20158, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T17:09:40.883' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (20159, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-09-24T17:10:19.910' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30117, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20035, CAST(N'2020-09-28T20:34:07.403' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30118, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20035, CAST(N'2020-09-28T20:34:31.240' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30119, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20035, CAST(N'2020-09-28T20:34:45.543' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30120, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-07T22:51:03.280' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30121, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-08T17:32:06.183' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30122, N'eb192af4-6fa7-4f34-ac02-5058cc5d424b', 20041, CAST(N'2020-10-08T23:19:41.603' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30123, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-13T20:08:47.823' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30124, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-14T18:41:27.430' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30125, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-14T18:42:21.513' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30126, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-14T19:35:01.760' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30127, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-14T19:41:30.640' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30128, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-14T19:52:57.677' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30129, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-27T23:27:36.190' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30130, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T15:23:50.260' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30131, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T15:32:02.060' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30132, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T15:47:33.940' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30133, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T18:07:12.950' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30134, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T18:07:27.360' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30135, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T18:17:00.370' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30136, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T19:49:50.147' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30137, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T19:50:16.750' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30138, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T19:55:55.637' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30139, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T19:58:03.573' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30140, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-10-28T20:00:07.303' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30141, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:08:20.960' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30142, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:10:49.410' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30143, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:12:34.777' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30144, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20035, CAST(N'2020-10-28T20:31:48.450' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30145, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 10035, CAST(N'2020-10-28T20:32:08.533' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30146, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:32:15.793' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30147, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:32:35.530' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30148, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:35:26.567' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30149, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:35:39.370' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30150, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:35:48.720' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30151, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:35:56.247' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30152, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:36:44.870' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30153, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:45:50.957' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30154, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T20:46:04.623' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30155, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-10-28T22:36:40.520' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30156, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T01:21:05.557' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30157, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T02:16:50.907' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30158, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-11-04T02:18:21.177' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30159, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 20041, CAST(N'2020-11-04T16:26:20.530' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30160, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:17:20.317' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30161, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:21:07.990' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30162, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:21:33.863' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30163, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:24:00.440' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30164, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:24:16.483' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30165, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:25:26.770' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30166, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:30:49.973' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30167, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:33:58.633' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30168, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T17:48:14.250' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30169, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T18:20:35.753' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30170, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T18:24:20.240' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30171, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T18:38:42.507' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30172, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T18:45:21.463' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30173, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T18:46:00.893' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30174, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T18:57:35.137' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30175, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:24:40.757' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30176, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:25:17.917' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30177, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:25:23.300' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30178, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:25:30.137' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30179, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:25:32.770' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30180, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:25:38.660' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30181, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:29:36.633' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30182, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:29:44.880' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30183, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:29:48.840' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30184, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:29:53.147' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30185, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:29:56.620' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30186, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:30:00.930' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30187, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:30:03.927' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30188, N'a55a7415-80e3-4dfd-93a1-3ea9d8d88329', 27, CAST(N'2020-11-04T20:30:06.943' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30189, N'92cfb222-e607-4103-8d48-02826604aa12', 20041, CAST(N'2020-11-15T13:39:42.930' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30190, N'92cfb222-e607-4103-8d48-02826604aa12', 30, CAST(N'2020-11-15T14:26:01.430' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30191, N'92cfb222-e607-4103-8d48-02826604aa12', 20041, CAST(N'2020-11-15T14:41:45.990' AS DateTime))
GO
INSERT [dbo].[Watched] ([Id], [UserId], [AdvertId], [Created]) VALUES (30192, N'eb8da0bb-1d3b-4324-a4cd-e0387266fe8e', 20042, CAST(N'2020-11-28T01:23:11.900' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Watched] OFF
GO
SET IDENTITY_INSERT [dbo].[WatchedByCookies] ON 
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (1, N'8cd18f88-a672-460b-95bd-2e65d90f0278', 32, CAST(N'2020-01-09T00:46:07.083' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (2, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 32, CAST(N'2020-01-09T00:49:10.143' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (3, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 31, CAST(N'2020-01-09T00:49:23.230' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (4, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 32, CAST(N'2020-01-09T00:49:29.170' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (5, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 30, CAST(N'2020-01-09T00:51:58.653' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (6, N'8cd18f88-a672-460b-95bd-2e65d90f0278', 32, CAST(N'2020-01-09T07:43:55.817' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (7, N'7ebbfbe9-a099-4678-81e5-cad55b5f095e', 32, CAST(N'2020-01-11T05:41:22.387' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (8, N'248fcbde-175e-4d76-b5d2-fa134d99217b', 28, CAST(N'2020-01-12T11:22:43.103' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (9, N'862ae3cb-6002-4d13-b133-a594d7e07a22', 27, CAST(N'2020-01-12T13:31:28.133' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10, N'a15f3a03-4f09-4f74-82b2-bfc07c26bdd0', 29, CAST(N'2020-01-14T14:56:46.730' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (11, N'861ae609-5e06-4716-aed5-ba26ce7b8f39', 31, CAST(N'2020-01-16T11:16:00.153' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (12, N'38b4989c-04c8-4a3f-a6b4-1b3bf218d548', 32, CAST(N'2020-01-19T18:53:16.500' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (13, N'38b4989c-04c8-4a3f-a6b4-1b3bf218d548', 29, CAST(N'2020-01-19T18:53:29.920' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (14, N'38b4989c-04c8-4a3f-a6b4-1b3bf218d548', 27, CAST(N'2020-01-19T18:53:36.943' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (15, N'a682c79c-a663-48dc-b1d7-84d7bdd60bbc', 32, CAST(N'2020-01-23T21:48:42.017' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (16, N'a682c79c-a663-48dc-b1d7-84d7bdd60bbc', 30, CAST(N'2020-01-23T21:55:25.423' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (17, N'86162b70-ced2-4d9f-bfad-e31839189bbd', 31, CAST(N'2020-01-23T22:10:45.337' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (18, N'8f26777a-7bfd-469b-905e-b7d8cd8aff90', 30, CAST(N'2020-01-23T23:02:32.803' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (19, N'6a4f9947-0f73-4ee8-99ae-c155a72656fa', 32, CAST(N'2020-01-23T23:53:30.573' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20, N'9e454bd7-8d28-47a8-af11-6f9eebace138', 27, CAST(N'2020-01-24T00:24:49.720' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (21, N'9e454bd7-8d28-47a8-af11-6f9eebace138', 28, CAST(N'2020-01-24T00:25:18.547' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (22, N'63c2ca22-5df6-4f48-bc2a-284aab9169ea', 31, CAST(N'2020-01-24T01:55:16.680' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (23, N'1153522a-34a8-419c-aef8-0815e0624f8b', 32, CAST(N'2020-01-24T08:21:42.850' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (24, N'd7c1d6c9-58af-4a82-a765-e3bf0d236070', 32, CAST(N'2020-01-24T15:14:40.103' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (25, N'c59f07cf-a8f3-4d27-88d9-953f5b6f9d49', 32, CAST(N'2020-01-24T16:19:04.760' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (26, N'7294f340-7e53-402c-a188-35c850206ebb', 28, CAST(N'2020-01-24T16:51:07.530' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (27, N'7294f340-7e53-402c-a188-35c850206ebb', 31, CAST(N'2020-01-24T16:51:25.683' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (28, N'1153522a-34a8-419c-aef8-0815e0624f8b', 28, CAST(N'2020-01-25T11:37:30.917' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (29, N'1153522a-34a8-419c-aef8-0815e0624f8b', 29, CAST(N'2020-01-25T11:51:20.757' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (30, N'fc2a62bd-52e9-485c-9ec0-9e932cc01b6c', 28, CAST(N'2020-01-25T20:50:19.420' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (31, N'fc2a62bd-52e9-485c-9ec0-9e932cc01b6c', 31, CAST(N'2020-01-25T20:50:36.633' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (32, N'8186bff9-73f5-47ba-9c69-18df4ce60504', 29, CAST(N'2020-01-25T20:56:47.300' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (33, N'c9ba5e72-f7fc-4e1b-acd0-a81244d3dc24', 28, CAST(N'2020-01-25T21:46:22.640' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (34, N'9e2e0637-4d13-473f-b71c-10ea0ca531cf', 29, CAST(N'2020-01-25T23:19:31.760' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (35, N'1e0c7926-cfc0-44eb-bf32-1d53a5c31720', 31, CAST(N'2020-01-26T14:27:27.037' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (36, N'ad799891-5189-43b4-8fe8-07ab238bcf7f', 31, CAST(N'2020-01-26T17:45:44.087' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (37, N'6ff64927-e553-4b6c-90d4-8e615e47dbea', 27, CAST(N'2020-01-26T22:08:15.150' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (38, N'6adc9028-3481-48a5-9a57-01ff1c293334', 27, CAST(N'2020-01-28T17:58:32.077' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (39, N'6adc9028-3481-48a5-9a57-01ff1c293334', 32, CAST(N'2020-01-28T21:07:03.153' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (40, N'6adc9028-3481-48a5-9a57-01ff1c293334', 30, CAST(N'2020-01-28T21:08:33.007' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (41, N'6adc9028-3481-48a5-9a57-01ff1c293334', 29, CAST(N'2020-01-28T21:08:50.667' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (42, N'1f3e7181-7f28-44c5-9349-fbf669c59a9e', 31, CAST(N'2020-01-30T00:16:11.107' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (43, N'1f3e7181-7f28-44c5-9349-fbf669c59a9e', 28, CAST(N'2020-01-30T00:16:48.550' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (44, N'6ff64927-e553-4b6c-90d4-8e615e47dbea', 29, CAST(N'2020-01-31T01:12:46.553' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (45, N'6ff64927-e553-4b6c-90d4-8e615e47dbea', 28, CAST(N'2020-01-31T01:12:59.607' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (46, N'6ff64927-e553-4b6c-90d4-8e615e47dbea', 27, CAST(N'2020-01-31T01:13:06.923' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (47, N'6ff64927-e553-4b6c-90d4-8e615e47dbea', 30, CAST(N'2020-01-31T01:13:48.020' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (48, N'5e36151b-ac2c-4276-b14e-7f938e25c31e', 31, CAST(N'2020-02-01T10:37:29.470' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (49, N'5e36151b-ac2c-4276-b14e-7f938e25c31e', 27, CAST(N'2020-02-01T10:38:15.637' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (50, N'3b531f88-84c4-4f93-8e83-010e35b1dc0a', 32, CAST(N'2020-02-03T13:45:46.243' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (51, N'a2e3e8a8-f5bd-4e81-8b67-c081aabe174b', 31, CAST(N'2020-02-07T13:00:03.733' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (52, N'a2e3e8a8-f5bd-4e81-8b67-c081aabe174b', 27, CAST(N'2020-02-07T14:18:21.927' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (53, N'a2e3e8a8-f5bd-4e81-8b67-c081aabe174b', 32, CAST(N'2020-02-07T14:18:32.120' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (54, N'15c7cfb6-7192-4975-94eb-0a98c2146c44', 28, CAST(N'2020-02-08T20:29:30.657' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (55, N'15c7cfb6-7192-4975-94eb-0a98c2146c44', 29, CAST(N'2020-02-08T20:31:21.280' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (56, N'15c7cfb6-7192-4975-94eb-0a98c2146c44', 31, CAST(N'2020-02-08T20:33:35.017' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (57, N'82aba1b2-62ea-488b-afe6-bf3ba5a3ef78', 28, CAST(N'2020-02-09T20:40:18.860' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (58, N'41c187cc-b6f7-4a91-8ebe-aa8c0033f935', 31, CAST(N'2020-02-11T09:52:04.713' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (59, N'72df31cc-796a-400c-925a-37954db8a991', 32, CAST(N'2020-02-11T14:17:30.257' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (60, N'934afeaa-7da9-4fa1-a789-553de2cfc494', 29, CAST(N'2020-02-11T20:34:38.390' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (61, N'934afeaa-7da9-4fa1-a789-553de2cfc494', 31, CAST(N'2020-02-11T20:37:15.000' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (62, N'ae5cc512-5617-4a68-ada0-21a23e7e7f3d', 31, CAST(N'2020-02-12T12:43:11.777' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (63, N'a27ac37a-51db-4a37-a9f0-9982cee127ac', 30, CAST(N'2020-02-12T14:53:12.827' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (64, N'749080c2-241a-4f25-979c-0c6dee6fcfe5', 27, CAST(N'2020-02-13T12:01:11.603' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (65, N'4d93a822-b0d3-4716-b72b-ba24ea4b36b3', 31, CAST(N'2020-02-14T14:25:03.680' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (66, N'bb9fd306-4e70-4cbb-8614-e5d1a9d21cb5', 30, CAST(N'2020-02-17T10:52:21.160' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (67, N'da74744c-a933-4459-b31c-db18b6c44dc0', 30, CAST(N'2020-02-18T00:56:59.883' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (68, N'945578db-fd59-4f9e-864f-b95367d198c6', 27, CAST(N'2020-02-19T00:41:35.103' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (69, N'71bef644-6166-43b6-a128-991b6e2d222e', 32, CAST(N'2020-02-19T00:41:40.160' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (70, N'945578db-fd59-4f9e-864f-b95367d198c6', 31, CAST(N'2020-02-19T00:41:55.500' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (71, N'71bef644-6166-43b6-a128-991b6e2d222e', 31, CAST(N'2020-02-19T00:42:10.510' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (72, N'945578db-fd59-4f9e-864f-b95367d198c6', 30, CAST(N'2020-02-19T00:42:31.793' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (73, N'71bef644-6166-43b6-a128-991b6e2d222e', 29, CAST(N'2020-02-19T00:42:32.020' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (74, N'945578db-fd59-4f9e-864f-b95367d198c6', 29, CAST(N'2020-02-19T00:42:42.130' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (75, N'945578db-fd59-4f9e-864f-b95367d198c6', 28, CAST(N'2020-02-19T00:44:06.007' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (76, N'945578db-fd59-4f9e-864f-b95367d198c6', 30, CAST(N'2020-02-19T00:44:30.430' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (77, N'945578db-fd59-4f9e-864f-b95367d198c6', 32, CAST(N'2020-02-19T00:44:41.653' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (78, N'945578db-fd59-4f9e-864f-b95367d198c6', 31, CAST(N'2020-02-19T00:46:25.600' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (79, N'388f4128-c358-4bbd-beb1-26b9537817e6', 31, CAST(N'2020-02-19T12:27:44.367' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (80, N'0d72262c-e9eb-4ae7-b039-80657665170b', 31, CAST(N'2020-02-24T13:01:41.177' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (81, N'0d72262c-e9eb-4ae7-b039-80657665170b', 32, CAST(N'2020-02-24T13:01:52.740' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (82, N'63214585-454c-494e-8585-2543e2544ab5', 28, CAST(N'2020-03-02T09:05:47.510' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (83, N'7109f9ed-f328-4c07-8d00-c2391f2b6ab4', 32, CAST(N'2020-03-05T21:26:15.373' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (84, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 32, CAST(N'2020-03-07T17:46:18.320' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (85, N'ac7f424f-0fc5-4a88-aaef-d3c5218c165b', 32, CAST(N'2020-03-07T17:46:26.883' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (86, N'35cf483b-cba1-4978-a1b0-281765aff53a', 30, CAST(N'2020-03-15T19:35:42.110' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (87, N'35cf483b-cba1-4978-a1b0-281765aff53a', 29, CAST(N'2020-03-15T19:38:01.640' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (88, N'd6395bf7-7d93-43c8-b0cb-389c3faedfc0', 31, CAST(N'2020-03-24T16:08:48.590' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (89, N'8631dd0f-cc50-409e-99bd-6f174362d969', 28, CAST(N'2020-04-04T21:26:49.537' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (90, N'52673ccf-6d7b-416f-b237-959a94dc9fb8', 31, CAST(N'2020-04-05T10:12:45.350' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (91, N'67c03e96-4060-4888-b8f5-ab7b95430d45', 29, CAST(N'2020-04-06T10:32:29.533' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (92, N'7d1ba263-1502-47da-aa59-e738c35a6ab3', 30, CAST(N'2020-04-07T13:09:25.113' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (93, N'aeab8464-f6f1-494e-9139-05fa83b03cc5', 28, CAST(N'2020-04-07T13:13:16.173' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (94, N'6cf59270-e686-4c44-9ed0-77a216da7c16', 31, CAST(N'2020-04-07T23:51:49.670' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (95, N'48e8fafd-82e5-4b33-9a4e-4db215b42b8e', 31, CAST(N'2020-04-15T20:18:59.777' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (96, N'1a1f294e-91c5-46b8-a9ef-6a0afa6ca6a5', 31, CAST(N'2020-04-15T20:26:51.960' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (97, N'6ca0be55-af49-41e8-b9de-bb4b4265bed3', 32, CAST(N'2020-04-17T11:26:53.100' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (98, N'6ca0be55-af49-41e8-b9de-bb4b4265bed3', 28, CAST(N'2020-04-17T11:27:50.393' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (99, N'635577a6-ebad-4f13-b6c3-372e3cd3337e', 29, CAST(N'2020-04-19T16:08:16.050' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (100, N'87c993a9-9413-4cbd-9dd6-0c87a86e55ee', 32, CAST(N'2020-04-28T17:11:52.377' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (101, N'87c993a9-9413-4cbd-9dd6-0c87a86e55ee', 29, CAST(N'2020-04-28T17:12:22.843' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (102, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 27, CAST(N'2020-05-05T13:42:25.580' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (103, N'b183a97a-4064-4c84-b8b4-86f64beb48e9', 27, CAST(N'2020-05-05T13:43:02.190' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (104, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10031, CAST(N'2020-05-10T23:03:10.353' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (105, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10031, CAST(N'2020-05-10T23:03:22.070' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (106, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10031, CAST(N'2020-05-10T23:15:39.980' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (107, N'8cd18f88-a672-460b-95bd-2e65d90f0278', 10030, CAST(N'2020-05-11T00:17:23.597' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (108, N'8cd18f88-a672-460b-95bd-2e65d90f0278', 10030, CAST(N'2020-05-11T00:17:26.217' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (109, N'8cd18f88-a672-460b-95bd-2e65d90f0278', 10030, CAST(N'2020-05-11T00:17:27.697' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (110, N'8cd18f88-a672-460b-95bd-2e65d90f0278', 10030, CAST(N'2020-05-11T00:17:33.660' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (111, N'd3abd7b6-60d2-418c-add7-6fd2eede0377', 31, CAST(N'2020-05-14T21:22:20.553' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (112, N'3d1485e1-2422-4f86-ad8f-fad52449bd42', 10031, CAST(N'2020-05-24T17:46:14.717' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (113, N'52ee03c9-df93-4981-bd2d-cd123d9aab9d', 10031, CAST(N'2020-05-30T11:39:52.187' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (114, N'ed5c09cc-61f0-4172-8c03-c267e728c1e8', 31, CAST(N'2020-06-13T22:26:57.473' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (115, N'bcfc664c-75d6-4280-bf0f-356857205a54', 28, CAST(N'2020-06-18T17:24:11.450' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (116, N'bcfc664c-75d6-4280-bf0f-356857205a54', 10032, CAST(N'2020-06-18T17:24:19.703' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (117, N'217b748c-6af5-4f0f-a1e4-1f658fa27e3f', 10034, CAST(N'2020-06-27T01:01:50.150' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (118, N'33b43fed-ab30-4664-a42a-6ad363109cf5', 10034, CAST(N'2020-07-02T12:12:20.127' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (119, N'33b43fed-ab30-4664-a42a-6ad363109cf5', 10032, CAST(N'2020-07-02T12:12:30.473' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (120, N'33b43fed-ab30-4664-a42a-6ad363109cf5', 10031, CAST(N'2020-07-02T12:12:45.287' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10118, N'106db481-f3f9-46c9-b73c-d694bd8cac88', 10032, CAST(N'2020-07-08T11:32:54.067' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10119, N'106db481-f3f9-46c9-b73c-d694bd8cac88', 10034, CAST(N'2020-07-08T11:33:09.720' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10120, N'd05b58b5-23b4-4b94-8837-1964d581ab39', 10035, CAST(N'2020-07-16T07:03:23.410' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (10121, N'fa1204de-9658-4158-b12d-19f2f623d982', 10033, CAST(N'2020-07-16T21:13:18.097' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20120, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10035, CAST(N'2020-07-21T01:36:06.213' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20121, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10034, CAST(N'2020-07-25T20:36:30.907' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20122, N'5f9e1206-aca2-4c8c-b4e8-1c7d5d7194e6', 10034, CAST(N'2020-07-26T23:34:45.547' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20123, N'5f9e1206-aca2-4c8c-b4e8-1c7d5d7194e6', 31, CAST(N'2020-07-26T23:35:40.943' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20124, N'24374cb3-c562-477c-adca-0c63b94425f0', 10035, CAST(N'2020-07-27T11:24:50.313' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20125, N'aae7daa5-92c7-4176-a261-54ceb05c5b8d', 20035, CAST(N'2020-08-02T12:02:39.843' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20126, N'aae7daa5-92c7-4176-a261-54ceb05c5b8d', 20035, CAST(N'2020-08-02T18:05:48.447' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20127, N'6aa6a5dd-342e-4b15-99ea-86b996689b09', 10035, CAST(N'2020-08-06T20:26:18.250' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20128, N'ed2dc2ff-1dfc-4f68-b9b7-d4d10b57270b', 10035, CAST(N'2020-08-09T11:54:53.200' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20129, N'e5361c44-d4a9-41a1-98ad-8b84eb5133bc', 10032, CAST(N'2020-08-12T02:55:40.250' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20130, N'476c783e-524e-451b-88d7-54e09eb88ba3', 20035, CAST(N'2020-08-18T16:48:34.937' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20131, N'3d001016-c7d1-4d42-8179-f33a93953e8f', 28, CAST(N'2020-08-19T09:55:26.167' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20132, N'fb1cb0cc-bba5-4216-a22b-35cbeac843e6', 10035, CAST(N'2020-08-21T13:52:24.547' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20133, N'5c3e65dd-5d26-4316-9276-21582d380b30', 10027, CAST(N'2020-08-21T21:34:36.027' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20134, N'44cb7f45-ab51-4e0a-9334-ac5fb56fe7a0', 20041, CAST(N'2020-08-22T00:52:37.850' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20135, N'44cb7f45-ab51-4e0a-9334-ac5fb56fe7a0', 20041, CAST(N'2020-08-22T01:31:15.220' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20136, N'44cb7f45-ab51-4e0a-9334-ac5fb56fe7a0', 20041, CAST(N'2020-08-22T01:31:25.483' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20137, N'44cb7f45-ab51-4e0a-9334-ac5fb56fe7a0', 20041, CAST(N'2020-08-22T01:36:00.090' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20138, N'c21d4f86-5374-4255-885c-59f82f5bb0e3', 32, CAST(N'2020-08-22T17:49:28.720' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20139, N'27ded994-d35d-4a79-b362-6aca4af6b4f9', 20041, CAST(N'2020-08-23T01:25:16.687' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20140, N'27ded994-d35d-4a79-b362-6aca4af6b4f9', 20041, CAST(N'2020-08-23T01:25:17.180' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20141, N'27ded994-d35d-4a79-b362-6aca4af6b4f9', 20041, CAST(N'2020-08-23T01:26:11.640' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20142, N'37a8cfa9-238a-4bba-b7e5-a1bef615c6db', 10034, CAST(N'2020-08-23T16:16:23.017' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20143, N'5fce6c4c-31e1-4ee2-a2a7-58f8112f5417', 20035, CAST(N'2020-08-24T10:24:08.397' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20144, N'7924fdcf-d476-43b0-b96a-be25dbc23ad7', 10034, CAST(N'2020-08-24T20:23:41.437' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20145, N'fd33cb75-e3b1-4a89-8da6-4fab284d5c21', 28, CAST(N'2020-08-24T20:24:28.830' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20146, N'cc321b95-27eb-4e27-978a-1a522f37b557', 10031, CAST(N'2020-09-01T14:47:34.917' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20147, N'cc321b95-27eb-4e27-978a-1a522f37b557', 31, CAST(N'2020-09-01T14:47:50.563' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20148, N'91154f26-92ee-47b2-81c1-ea6376792110', 27, CAST(N'2020-09-03T15:24:17.823' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20149, N'f31e2c02-fc5a-4de2-b972-e9a222213aab', 20035, CAST(N'2020-09-05T07:19:24.020' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20150, N'b4eafb54-a7c4-42fc-bd32-297d83f9cc72', 20041, CAST(N'2020-09-05T08:58:47.163' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20151, N'816931f1-99c6-435e-bb16-07365ab308f0', 20041, CAST(N'2020-09-05T10:02:09.083' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20152, N'656ece53-e312-4282-845e-1ce52bead072', 20035, CAST(N'2020-09-05T21:44:58.517' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20153, N'e01f625d-d294-48ce-af4e-bdbacd3b4524', 20041, CAST(N'2020-09-08T21:07:19.750' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20154, N'53201c0a-b86f-473f-a6c1-f381d3495be0', 10032, CAST(N'2020-09-08T22:33:07.443' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20155, N'a678e715-5987-4b59-8007-cd8b1a5186a8', 10032, CAST(N'2020-09-09T10:27:51.380' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (20156, N'e66611e5-b628-4ae4-a4df-e82cfec5dc64', 20041, CAST(N'2020-09-17T22:00:39.473' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (30156, N'745e93d6-a2b3-4f65-9bac-79040420725f', 20041, CAST(N'2020-10-14T19:33:23.107' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (30157, N'59860016-61a7-491a-994b-b2c84a1731ae', 20041, CAST(N'2020-10-27T23:14:53.207' AS DateTime))
GO
INSERT [dbo].[WatchedByCookies] ([Id], [UserCookiesId], [AdvertId], [Created]) VALUES (30158, N'59860016-61a7-491a-994b-b2c84a1731ae', 20041, CAST(N'2020-10-27T23:15:45.680' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[WatchedByCookies] OFF
GO
/****** Object:  Index [IX_Referrals]    Script Date: 2/27/2021 8:43:56 AM ******/
ALTER TABLE [dbo].[Referrals] ADD  CONSTRAINT [IX_Referrals] UNIQUE NONCLUSTERED 
(
	[ReferralUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
ALTER TABLE [dbo].[NewsGodnebeles] ADD  CONSTRAINT [DF_NewsGodnebeles_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[NewsGodnebeles] ADD  CONSTRAINT [DF_NewsGodnebeles_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[NewsGodnebeles] ADD  CONSTRAINT [DF_NewsGodnebeles_Active]  DEFAULT ((1)) FOR [Active]
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
/****** Object:  StoredProcedure [dbo].[spAddAdvert]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spAddFavorites]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spAddFavoritesByCookies]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spAddWatched]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spAddWatchedByCookies]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetChats]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetChatsForUser]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetComments]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetCommentsForUser]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetComplaintsByRecipier]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetComplaintsBySender]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetExchangeItemRequests]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetExchangeProducts]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetFavorites]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetFavoritesByCookies]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetLast200TokensOperations]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastDayActive]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetLoginStatisticLastHourActive]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetTokenCostToday]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetUserAdverts]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetWatched]    Script Date: 2/27/2021 8:43:56 AM ******/
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
/****** Object:  StoredProcedure [dbo].[spGetWatchedByCookies]    Script Date: 2/27/2021 8:43:56 AM ******/
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
