declare @i as int;
declare @val as float;
declare @datet as datetime;

SET @val = 0.1;
SET @datet = '2020-01-18T01:00:01.667';
SET @i = 1;

WHILE (@i < 1000)  
BEGIN  

set @val = @val + ((@val*0.07191/100));
SET @datet = DATEADD(day,1, @datet);
SET @i = @i + 1;

INSERT INTO TokensCost (Value, [Date])  
VALUES (@val, @datet);

END  