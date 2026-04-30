--1. Detect Suspicious Transactions (Basic Rule)

SELECT 
    TransactionID,
    FromAccountID,
    ToAccountID,
    Amount,
    CASE 
        WHEN Amount > 50000 THEN 'Suspicious'
        ELSE 'Normal'
    END AS Status
FROM Transactions;

-- 2. (a) Add Suspicious Flag Column (Better Design)

ALTER TABLE Transactions
ADD IsSuspicious BIT DEFAULT 0;

--(b) Update Suspicious Records

UPDATE Transactions
SET IsSuspicious = 1
WHERE Amount > 50000;

-- 3. Find Top Transactions (Window Function)

SELECT 
    TransactionID,
    Amount,
    RANK() OVER (ORDER BY Amount DESC) AS RankByAmount
FROM Transactions;


-- 4. Detect Frequent Transactions (Fraud Pattern)

SELECT 
    FromAccountID,
    COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY FromAccountID
HAVING COUNT(*) > 3;

-- 5. Daily Transaction Summary

SELECT 
    CAST(TransactionDate AS DATE) AS Date,
    SUM(Amount) AS TotalAmount
FROM Transactions
GROUP BY CAST(TransactionDate AS DATE);

--6. Balance Check

SELECT *
FROM Accounts
WHERE Balance < 10000;

-- Advance Quieries

-- 1. Multiple Transactions in Short Time

SELECT 
    FromAccountID,
    COUNT(*) AS TransactionCount
FROM Transactions
WHERE TransactionDate >= DATEADD(MINUTE, -10, GETDATE())
GROUP BY FromAccountID
HAVING COUNT(*) > 3;

-- 2. Sudden Large Transaction (Behavior Change)

SELECT 
    FromAccountID,
    AVG(Amount) AS AvgAmount,
    MAX(Amount) AS MaxAmount
FROM Transactions
GROUP BY FromAccountID
HAVING MAX(Amount) > AVG(Amount) * 3;

--3. Repeated Transfers to Same Account

SELECT 
    FromAccountID,
    ToAccountID,
    COUNT(*) AS TransferCount
FROM Transactions
GROUP BY FromAccountID, ToAccountID
HAVING COUNT(*) > 5;

--4. Low Balance + High Transfer

SELECT 
    a.AccountID,
    a.Balance,
    t.Amount
FROM Accounts a
JOIN Transactions t ON a.AccountID = t.FromAccountID
WHERE a.Balance < 10000 AND t.Amount > 20000;

-- 5. Create Fraud Score

SELECT 
    TransactionID,
    Amount,
    CASE 
        WHEN Amount > 50000 THEN 2
        ELSE 0
    END +
    CASE 
        WHEN Amount > 30000 THEN 1
        ELSE 0
    END AS FraudScore
FROM Transactions;
