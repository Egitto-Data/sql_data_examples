/*CREAT A STORED PROCEDURE CALLED OES.TRANSFERFUNDS TAHT TRANSFER MONEY FROM BANK ACCOUNT TO ANOTHER BANK
ACCOUNT BY UPDATING THE BALANCE COLUMN IN THE OES.BANK_ACCOUNT TABLE .ALSO INSERT THE BANK TRANSACTION INTO 
OES.BANK_TRANSACTION .*/
CREATE PROCEDURE oes.transferFunds
( 
	@withdraw_accountId INT,
	@deposit_accountId INT,
	@transfer_amount DECIMAL (30,2)
)     
AS

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN

BEGIN TRANSACTION;

UPDATE [oes].[bank_accounts]
	SET balance = balance - @transfer_amount
	WHERE account_id = @withdraw_accountId

UPDATE [oes].[bank_accounts]
	SET balance = balance + @transfer_amount
	WHERE account_id = @deposit_accountId

INSERT INTO [oes].[bank_transactions] ([from_account_id],[to_account_id],[amount])
VALUES      (@withdraw_accountId,@deposit_accountId,@transfer_amount)

COMMIT TRANSACTION

END

SELECT*
FROM [oes].[bank_accounts]

EXEC oes.transferFunds @withdraw_accountId = 1, @deposit_accountId = 2, @transfer_amount = 3300

SELECT*
FROM [oes].[bank_transactions]