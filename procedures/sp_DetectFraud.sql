-- Create Fraud Detection Procedure
CREATE PROCEDURE sp_DetectFraud
AS
BEGIN
    SELECT 
        TransactionID,
        FromAccountID,
        Amount,
        CASE 
            WHEN Amount > 50000 THEN 'High Risk'
            WHEN Amount > 30000 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS RiskLevel
    FROM Transactions;
END;

EXEC sp_DetectFraud;