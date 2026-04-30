CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Email VARCHAR(100)
);


CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    Balance DECIMAL(12,2),
    AccountType VARCHAR(50),

    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    FromAccountID INT,
    ToAccountID INT,
    Amount DECIMAL(12,2),
    TransactionDate DATETIME DEFAULT GETDATE(),
    TransactionType VARCHAR(50),

    FOREIGN KEY (FromAccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (ToAccountID) REFERENCES Accounts(AccountID)
);

