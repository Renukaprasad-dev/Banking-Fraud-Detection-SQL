BEGIN TRANSACTION;

-- Deduct from sender
UPDATE Accounts
SET Balance = Balance - 20000
WHERE AccountID = 1;

-- Add to receiver
UPDATE Accounts
SET Balance = Balance + 20000
WHERE AccountID = 2;

-- Record transaction
INSERT INTO Transactions (FromAccountID, ToAccountID, Amount, TransactionType)
VALUES (1, 2, 20000, 'Transfer');

COMMIT


BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Accounts
    SET Balance = Balance - 20000
    WHERE AccountID = 1;

    UPDATE Accounts
    SET Balance = Balance + 20000
    WHERE AccountID = 2;

    INSERT INTO Transactions (FromAccountID, ToAccountID, Amount, TransactionType)
    VALUES (1, 2, 20000, 'Transfer');

    COMMIT;
END TRY

BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction Failed';
END CATCH;


SELECT * FROM Accounts;
SELECT * FROM Transactions;


CREATE TRIGGER trg_FraudDetection
ON Transactions
AFTER INSERT
AS
BEGIN
    UPDATE t
    SET IsSuspicious = 1
    FROM Transactions t
    JOIN inserted i ON t.TransactionID = i.TransactionID
    WHERE i.Amount > 50000;
END;

INSERT INTO Transactions (FromAccountID, ToAccountID, Amount, TransactionType)
VALUES (1, 2, 20000, 'Transfer');

INSERT INTO Transactions (FromAccountID, ToAccountID, Amount, TransactionType)
VALUES (1, 2, 80000, 'Transfer');

SELECT * FROM Transactions;



SELECT 
    TransactionID,
    FromAccountID,
    ToAccountID,
    Amount,
    DATEDIFF(MINUTE, LAG(TransactionDate) OVER (PARTITION BY FromAccountID ORDER BY TransactionDate), TransactionDate) AS TimeDiff,
    IsSuspicious
FROM Transactions;

