CREATE PROCEDURE  [dbo].[spUpdateQiwiAccountBalance]
@number nvarchar(50), @balance float
AS
BEGIN

	UPDATE Phones
	SET Balance = @balance
	WHERE Number = @number;

END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spUpdateQiwiAccountBalance] TO PUBLIC
    AS [dbo];
