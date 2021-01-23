CREATE PROCEDURE [spGeographyDPDTop10]
@text nvarchar(50)
AS
BEGIN
Select top 10 
[CityCode]
,[Abbreviation]
,[CityName]
,[RegionName]
,[CountryName]
,[Id]
from [GeographyDPD]
Where 
[CityName] like '%'+@text+'%' 
or [RegionName] like '%'+ @text + '%'
or [CountryName] like '%'+ @text + '%'
END
GO
