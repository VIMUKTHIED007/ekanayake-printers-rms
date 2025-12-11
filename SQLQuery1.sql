-- =============================================
-- Ekanayake Printers RMS - Complete Database Schema
-- Database: EKANAYAKE_PRINTERS_001
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'EKANAYAKE_PRINTERS_001')
BEGIN
    CREATE DATABASE EKANAYAKE_PRINTERS_001;
END
GO

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. ITEM MANAGEMENT TABLES
-- =============================================

-- Main Items Table
IF OBJECT_ID('itemTable', 'U') IS NOT NULL DROP TABLE itemTable;
CREATE TABLE itemTable(
    itemID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    modelID varchar(50) NOT NULL,
    brand varchar(100),
    category varchar(100),
    details varchar(200),
    quantity int DEFAULT 0,
    barcode bigint,
    supplier varchar(100),
    sellingPricePerUnit float,
    boughtPrice float,
    status varchar(50) DEFAULT 'Active',
    createdDate DATETIME DEFAULT GETDATE(),
    lastUpdated DATETIME DEFAULT GETDATE()
);
GO

-- Available Stocks Table
IF OBJECT_ID('availableSTOCKS', 'U') IS NOT NULL DROP TABLE availableSTOCKS;
CREATE TABLE availableSTOCKS(
    stockID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    itemID INT NOT NULL,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID) ON DELETE CASCADE,
    availableQTY int DEFAULT 0,
    lastUpdatedDATE DATE DEFAULT GETDATE()
);
GO

-- Sold Stocks Table
IF OBJECT_ID('soldSTOCKS', 'U') IS NOT NULL DROP TABLE soldSTOCKS;
CREATE TABLE soldSTOCKS(
    soldStockID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    itemID INT NOT NULL,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    soldQTY INT,
    discountRate FLOAT DEFAULT 0,
    totalSold FLOAT,
    soldDATE DATE DEFAULT GETDATE(),
    invoiceID INT
);
GO

-- =============================================
-- 2. CUSTOMER MANAGEMENT TABLES
-- =============================================

-- Customer Table
IF OBJECT_ID('customerTable', 'U') IS NOT NULL DROP TABLE customerTable;
CREATE TABLE customerTable(
    customerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    customerType varchar(100),
    firstName varchar(100),
    lastName varchar(100),
    email varchar(100),
    tel bigint,
    city varchar(100),
    nic varchar(20),
    customerAddress varchar(200),
    customerLocation varchar(100),
    dob date,
    regDate date DEFAULT GETDATE(),
    gender varchar(20),
    status varchar(50) DEFAULT 'Active'
);
GO

-- =============================================
-- 3. INVOICE & BILLING TABLES
-- =============================================

-- Invoice Header Table
IF OBJECT_ID('invoiceTable', 'U') IS NOT NULL DROP TABLE invoiceTable;
CREATE TABLE invoiceTable(
    invoiceID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    invoiceNumber varchar(50) UNIQUE,
    customerID INT,
    FOREIGN KEY (customerID) REFERENCES customerTable(customerID),
    customerName varchar(100),
    customerType varchar(100),
    invoiceDate DATETIME DEFAULT GETDATE(),
    totalBillAmount float,
    discountAmount float DEFAULT 0,
    taxAmount float DEFAULT 0,
    finalAmount float,
    paymentStatus varchar(50) DEFAULT 'Pending',
    paymentMethod varchar(50),
    createdBy INT,
    notes varchar(500)
);
GO

-- Invoice Line Items Table
IF OBJECT_ID('invoiceLineItems', 'U') IS NOT NULL DROP TABLE invoiceLineItems;
CREATE TABLE invoiceLineItems(
    lineItemID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    invoiceID INT NOT NULL,
    FOREIGN KEY (invoiceID) REFERENCES invoiceTable(invoiceID) ON DELETE CASCADE,
    itemID INT NOT NULL,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    itemName varchar(200),
    quantity int,
    unitPrice float,
    discount float DEFAULT 0,
    lineTotal float,
    itemDetails varchar(500)
);
GO

-- Bill Estimate Table
IF OBJECT_ID('BillESIMATE', 'U') IS NOT NULL DROP TABLE BillESIMATE;
CREATE TABLE BillESIMATE(
    estimateID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    estimateNumber varchar(50) UNIQUE,
    customerID INT,
    FOREIGN KEY (customerID) REFERENCES customerTable(customerID),
    customerName varchar(100),
    estimateDate DATETIME DEFAULT GETDATE(),
    totalAmount float,
    validUntil date,
    status varchar(50) DEFAULT 'Pending',
    notes varchar(500),
    createdBy INT
);
GO

-- Bill Estimate Line Items
IF OBJECT_ID('BillEstimateLineItems', 'U') IS NOT NULL DROP TABLE BillEstimateLineItems;
CREATE TABLE BillEstimateLineItems(
    lineItemID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    estimateID INT NOT NULL,
    FOREIGN KEY (estimateID) REFERENCES BillESIMATE(estimateID) ON DELETE CASCADE,
    itemID INT,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    itemName varchar(200),
    quantity int,
    unitPrice float,
    lineTotal float,
    description varchar(500)
);
GO

-- Return Items Table
IF OBJECT_ID('returnTable', 'U') IS NOT NULL DROP TABLE returnTable;
CREATE TABLE returnTable(
    returnID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    invoiceID INT,
    FOREIGN KEY (invoiceID) REFERENCES invoiceTable(invoiceID),
    itemID INT NOT NULL,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    itemDetails varchar(200),
    quantity int,
    price float,
    returnReason varchar(200),
    issuedDate date DEFAULT GETDATE(),
    validPeriod int,
    returnStatus varchar(50) DEFAULT 'Pending',
    approvedBy INT,
    refundAmount float
);
GO

-- =============================================
-- 4. USER & EMPLOYEE MANAGEMENT TABLES
-- =============================================

-- User Table
IF OBJECT_ID('userTable', 'U') IS NOT NULL DROP TABLE userTable;
CREATE TABLE userTable(
    userID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    employeeID INT,
    userType varchar(200),
    fullName varchar(100) NOT NULL,
    nic varchar(15),
    tel bigint,
    email varchar(50),
    userAddress varchar(200),
    dob date,
    username varchar(50) UNIQUE,
    details varchar(200),
    userPassword varchar(50) NOT NULL,
    positionIndex int NOT NULL,
    status varchar(50) DEFAULT 'Active',
    createdDate DATETIME DEFAULT GETDATE(),
    lastLogin DATETIME
);
GO

-- Employee Table
IF OBJECT_ID('employeeTable', 'U') IS NOT NULL DROP TABLE employeeTable;
CREATE TABLE employeeTable(
    employeeID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    employeeType varchar(200),
    positionIndex int,
    hireDate date DEFAULT GETDATE(),
    department varchar(100),
    status varchar(50) DEFAULT 'Active'
);
GO

-- Position/Role Tables
IF OBJECT_ID('managerTable', 'U') IS NOT NULL DROP TABLE managerTable;
CREATE TABLE managerTable(
    managerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    positionIndex int DEFAULT 1,
    department varchar(100)
);
GO

IF OBJECT_ID('accountantTable', 'U') IS NOT NULL DROP TABLE accountantTable;
CREATE TABLE accountantTable(
    accountantID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    positionIndex int DEFAULT 2
);
GO

IF OBJECT_ID('cashierTable', 'U') IS NOT NULL DROP TABLE cashierTable;
CREATE TABLE cashierTable(
    cashierID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    positionIndex int DEFAULT 3
);
GO

IF OBJECT_ID('siteEngineerTable', 'U') IS NOT NULL DROP TABLE siteEngineerTable;
CREATE TABLE siteEngineerTable(
    siteEngineerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    positionIndex int DEFAULT 4
);
GO

IF OBJECT_ID('stockManagerTable', 'U') IS NOT NULL DROP TABLE stockManagerTable;
CREATE TABLE stockManagerTable(
    stockmanagerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    positionIndex int DEFAULT 5
);
GO

IF OBJECT_ID('workerTable', 'U') IS NOT NULL DROP TABLE workerTable;
CREATE TABLE workerTable(
    workerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID) ON DELETE CASCADE,
    positionIndex int DEFAULT 6
);
GO

-- =============================================
-- 5. PAYROLL & SALARY TABLES
-- =============================================

-- Paysheet Table
IF OBJECT_ID('paysheetTable', 'U') IS NOT NULL DROP TABLE paysheetTable;
CREATE TABLE paysheetTable(
    paysheetID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    employeeID INT NOT NULL,
    FOREIGN KEY (employeeID) REFERENCES employeeTable(employeeID),
    employeeName varchar(100),
    employeeType varchar(100),
    payMonth varchar(50),
    payYear int,
    basicSalary float,
    incentive float DEFAULT 0,
    workingDays int,
    otHours int DEFAULT 0,
    hourRate float,
    otAmount float,
    etf float,
    epf float,
    deductions float DEFAULT 0,
    totalSalary float,
    paymentDate date,
    paymentStatus varchar(50) DEFAULT 'Pending',
    createdDate DATETIME DEFAULT GETDATE()
);
GO

-- Salary History Table
IF OBJECT_ID('salaryHistory', 'U') IS NOT NULL DROP TABLE salaryHistory;
CREATE TABLE salaryHistory(
    salaryHistoryID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    employeeID INT NOT NULL,
    FOREIGN KEY (employeeID) REFERENCES employeeTable(employeeID),
    paysheetID INT,
    FOREIGN KEY (paysheetID) REFERENCES paysheetTable(paysheetID),
    salaryAmount float,
    payMonth varchar(50),
    payYear int,
    paymentDate date,
    notes varchar(500)
);
GO

-- =============================================
-- 6. SCHEDULE & PROJECT MANAGEMENT
-- =============================================

-- Schedule Table
IF OBJECT_ID('schedule', 'U') IS NOT NULL DROP TABLE schedule;
CREATE TABLE schedule(
    scheduleID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    employeeID INT NOT NULL,
    FOREIGN KEY (employeeID) REFERENCES employeeTable(employeeID),
    employeeName varchar(100),
    scheduleDate date NOT NULL,
    scheduleTime time,
    scheduleLocation varchar(200),
    scheduleType varchar(100),
    description varchar(500),
    status varchar(50) DEFAULT 'Scheduled',
    createdBy INT,
    createdDate DATETIME DEFAULT GETDATE()
);
GO

-- Project Table
IF OBJECT_ID('projectTable', 'U') IS NOT NULL DROP TABLE projectTable;
CREATE TABLE projectTable(
    projectID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    projectName varchar(100) NOT NULL,
    projectType varchar(100),
    projectLocation varchar(200),
    customerID INT,
    FOREIGN KEY (customerID) REFERENCES customerTable(customerID),
    customerName varchar(100),
    createDate date DEFAULT GETDATE(),
    startDate date,
    endDate date,
    workingProcedure varchar(500),
    projectStatus varchar(50) DEFAULT 'Active',
    assignedEngineerID INT,
    FOREIGN KEY (assignedEngineerID) REFERENCES employeeTable(employeeID),
    budget float,
    actualCost float,
    progressPercentage int DEFAULT 0
);
GO

-- Project Progress Table
IF OBJECT_ID('projectProgress', 'U') IS NOT NULL DROP TABLE projectProgress;
CREATE TABLE projectProgress(
    progressID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    projectID INT NOT NULL,
    FOREIGN KEY (projectID) REFERENCES projectTable(projectID) ON DELETE CASCADE,
    progressDate date DEFAULT GETDATE(),
    progressPercentage int,
    description varchar(500),
    updatedBy INT,
    notes varchar(1000)
);
GO

-- =============================================
-- 7. SUPPLIER MANAGEMENT
-- =============================================

-- Supplier Table
IF OBJECT_ID('supplier', 'U') IS NOT NULL DROP TABLE supplier;
CREATE TABLE supplier(
    supplierID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    supplierType varchar(200),
    supplierName varchar(100) NOT NULL,
    supplierAddress varchar(200),
    email varchar(50),
    tel bigint,
    company varchar(100),
    contactPerson varchar(100),
    status varchar(50) DEFAULT 'Active',
    createdDate DATETIME DEFAULT GETDATE()
);
GO

-- Alternative Supplier Table (as referenced in code)
IF OBJECT_ID('SUPPLIERS', 'U') IS NOT NULL DROP TABLE SUPPLIERS;
CREATE TABLE SUPPLIERS(
    supID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    supName varchar(100) NOT NULL,
    email varchar(50),
    tel bigint,
    company varchar(100),
    userAddress varchar(200),
    supplierType varchar(200),
    nic varchar(20),
    product varchar(100),
    status varchar(50) DEFAULT 'Active'
);
GO

-- Supplier Sales Table
IF OBJECT_ID('supplierSales', 'U') IS NOT NULL DROP TABLE supplierSales;
CREATE TABLE supplierSales(
    salesID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    supplierID INT,
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID),
    SupplierNIC varchar(20),
    itemID INT,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    SalesQTY int,
    salesDate date DEFAULT GETDATE(),
    unitPrice float,
    totalAmount float
);
GO

-- =============================================
-- 8. REPORTS & ANALYTICS
-- =============================================

-- Report Table
IF OBJECT_ID('report', 'U') IS NOT NULL DROP TABLE report;
CREATE TABLE report(
    reportID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    reportType varchar(100),
    reportName varchar(200),
    generatedDate DATETIME DEFAULT GETDATE(),
    generatedBy INT,
    reportData varchar(MAX),
    filePath varchar(500)
);
GO

-- Sales Report Count Table
IF OBJECT_ID('salesReportCount', 'U') IS NOT NULL DROP TABLE salesReportCount;
CREATE TABLE salesReportCount(
    salesReportID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    itemID INT,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    salesMonth varchar(100),
    salesYear int,
    saleType varchar(100),
    itemSold int,
    serviceCharge float,
    materialCost float,
    equipmentCost float,
    totalSalary float,
    transportCost float,
    totalSales float,
    serviceIncome float,
    totalCost float,
    profit float,
    reportDate DATETIME DEFAULT GETDATE()
);
GO

-- Sales Count Table
IF OBJECT_ID('salesCount', 'U') IS NOT NULL DROP TABLE salesCount;
CREATE TABLE salesCount(
    salesReportID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    itemID INT,
    FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
    modelID varchar(50),
    brand varchar(100),
    category varchar(100),
    supplier varchar(100),
    qty int,
    stockUpdateDate date DEFAULT GETDATE(),
    qtyAvailable int,
    qtySold int
);
GO

-- =============================================
-- 9. SESSION & AUDIT TABLES
-- =============================================

-- Session Start Table
IF OBJECT_ID('sessionStart', 'U') IS NOT NULL DROP TABLE sessionStart;
CREATE TABLE sessionStart(
    sessionID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID),
    sessionStartTime DATETIME DEFAULT GETDATE(),
    ipAddress varchar(50),
    machineName varchar(100)
);
GO

-- Session End Table
IF OBJECT_ID('sessionEnd', 'U') IS NOT NULL DROP TABLE sessionEnd;
CREATE TABLE sessionEnd(
    sessionID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTable(userID),
    sessionEndTime DATETIME DEFAULT GETDATE(),
    sessionDuration int -- in minutes
);
GO

-- =============================================
-- 10. FINANCIAL TABLES
-- =============================================

-- Financial Transactions Table
IF OBJECT_ID('financialTransactions', 'U') IS NOT NULL DROP TABLE financialTransactions;
CREATE TABLE financialTransactions(
    transactionID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    transactionDate DATETIME DEFAULT GETDATE(),
    transactionType varchar(50), -- Income, Expense, Payment, Receipt
    amount float NOT NULL,
    description varchar(500),
    category varchar(100),
    referenceID INT, -- Can reference invoiceID, paysheetID, etc.
    referenceType varchar(50),
    createdBy INT,
    status varchar(50) DEFAULT 'Active'
);
GO

-- =============================================
-- CREATE INDEXES FOR PERFORMANCE
-- =============================================

-- Indexes on frequently queried columns
CREATE INDEX IX_userTable_username ON userTable(username);
CREATE INDEX IX_userTable_positionIndex ON userTable(positionIndex);
CREATE INDEX IX_itemTable_modelID ON itemTable(modelID);
CREATE INDEX IX_itemTable_barcode ON itemTable(barcode);
CREATE INDEX IX_invoiceTable_customerID ON invoiceTable(customerID);
CREATE INDEX IX_invoiceTable_invoiceDate ON invoiceTable(invoiceDate);
CREATE INDEX IX_customerTable_nic ON customerTable(nic);
CREATE INDEX IX_customerTable_tel ON customerTable(tel);
CREATE INDEX IX_employeeTable_userID ON employeeTable(userID);
CREATE INDEX IX_schedule_employeeID ON schedule(employeeID);
CREATE INDEX IX_schedule_scheduleDate ON schedule(scheduleDate);
CREATE INDEX IX_projectTable_customerID ON projectTable(customerID);
CREATE INDEX IX_paysheetTable_employeeID ON paysheetTable(employeeID);
CREATE INDEX IX_sessionStart_userID ON sessionStart(userID);

GO

-- =============================================
-- SAMPLE DATA (Optional - for testing)
-- =============================================

-- Insert a default administrator user
-- Password: admin123 (you should change this!)
INSERT INTO userTable (fullName, username, userPassword, positionIndex, userType, email, status)
VALUES ('System Administrator', 'admin', 'admin123', 0, 'Administrator', 'admin@ekanayake.com', 'Active');

-- Insert corresponding employee record
DECLARE @adminUserID INT = SCOPE_IDENTITY();
INSERT INTO employeeTable (userID, employeeType, positionIndex)
VALUES (@adminUserID, 'Administrator', 0);

INSERT INTO managerTable (userID, positionIndex)
VALUES (@adminUserID, 0);

GO

PRINT 'Database schema created successfully!';
PRINT 'Default admin user created:';
PRINT 'Username: admin';
PRINT 'Password: admin123';
PRINT 'Please change the password after first login!';
