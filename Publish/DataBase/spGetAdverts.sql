CREATE PROCEDURE  [dbo].[spGetAdverts]
@search nvarchar(100)
AS
BEGIN
SELECT
[Id]
,[Category]
,[Name]
,[Description]
,[Created]
,[CreatedUserId]
,[Price]
,[Address]
,[Phone]
,[MessageType]
,[Position]
,[ImgUrls]
,[YouTubeUrl]
from [Adverts] a
WHERE CONTAINS([Name], @search) or CONTAINS([Description], @search)
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetAdverts] TO PUBLIC
    AS [dbo];