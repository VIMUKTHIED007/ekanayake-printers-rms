-- =============================================
-- Fix Database Tables for Application Compatibility
-- This script creates missing tables and views
-- to match what the application expects
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. Create ITEMS table (alias for itemTable)
-- =============================================
IF OBJECT_ID('ITEMS', 'U') IS NULL
BEGIN
    CREATE TABLE ITEMS(
        itemID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        modelNO varchar(50),
        discription varchar(200),
        supplierID varchar(100),
        brand varchar(100),
        category varchar(100),
        barcode bigint
    );
END
GO

-- =============================================
-- 2. Create STOCKBUYING table
-- =============================================
IF OBJECT_ID('STOCKBUYING', 'U') IS NULL
BEGIN
    CREATE TABLE STOCKBUYING(
        stockBuyingID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        itemID INT NOT NULL,
        boughtQTY INT DEFAULT 0,
        unitPrice FLOAT,
        sellingPricePerUnit FLOAT,
        purchaseDate DATETIME DEFAULT GETDATE(),
        supplierID varchar(100)
    );
END
GO

-- =============================================
-- 3. Create JD_EMPLOYEE_PAYSHEET table
-- =============================================
IF OBJECT_ID('JD_EMPLOYEE_PAYSHEET', 'U') IS NULL
BEGIN
    CREATE TABLE JD_EMPLOYEE_PAYSHEET(
        paysheetID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        empID varchar(50) NOT NULL,
        empName varchar(100),
        userType INT,
        Month DATETIME,
        basicSalary FLOAT DEFAULT 0,
        incentive FLOAT DEFAULT 0,
        workDays INT DEFAULT 0,
        otHours FLOAT DEFAULT 0,
        etf FLOAT DEFAULT 0,
        totalSalary FLOAT DEFAULT 0,
        createdDate DATETIME DEFAULT GETDATE(),
        status varchar(50) DEFAULT 'Active'
    );
END
GO

-- =============================================
-- 4. Create projects table (alias for projectTable)
-- =============================================
IF OBJECT_ID('projects', 'U') IS NULL
BEGIN
    CREATE TABLE projects(
        projectID varchar(50) PRIMARY KEY,
        projectName varchar(200),
        projectType INT,
        location varchar(200),
        customerID varchar(50),
        customerName varchar(100),
        createDate DATETIME DEFAULT GETDATE(),
        status varchar(50) DEFAULT 'Active'
    );
END
GO

-- =============================================
-- 5. Create workingProcedure table
-- =============================================
IF OBJECT_ID('workingProcedure', 'U') IS NULL
BEGIN
    CREATE TABLE workingProcedure(
        procedureID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        projectID varchar(50),
        projectName varchar(200),
        projectType INT,
        location varchar(200),
        createDate DATETIME DEFAULT GETDATE(),
        cartID varchar(50),
        description varchar(500),
        status varchar(50) DEFAULT 'Active'
    );
END
GO

-- =============================================
-- 6. Create customer table (alias for customerTable)
-- =============================================
IF OBJECT_ID('customer', 'U') IS NULL
BEGIN
    CREATE TABLE customer(
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
END
GO

-- =============================================
-- 7. Sync data between itemTable and ITEMS
-- =============================================
-- Create trigger to sync ITEMS with itemTable
IF OBJECT_ID('TR_ITEMS_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_ITEMS_Sync;
GO

CREATE TRIGGER TR_ITEMS_Sync
ON ITEMS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Sync to itemTable on insert/update
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE itemTable AS target
        USING inserted AS source
        ON target.itemID = source.itemID
        WHEN MATCHED THEN
            UPDATE SET 
                modelID = source.modelNO,
                details = source.discription,
                supplier = source.supplierID,
                brand = source.brand,
                category = source.category,
                barcode = source.barcode,
                lastUpdated = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT (modelID, details, supplier, brand, category, barcode, createdDate, lastUpdated)
            VALUES (source.modelNO, source.discription, source.supplierID, source.brand, source.category, source.barcode, GETDATE(), GETDATE());
    END
    
    -- Handle deletes
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM itemTable 
        WHERE itemID IN (SELECT itemID FROM deleted);
    END
END;
GO

-- =============================================
-- 8. Sync data between customerTable and customer
-- =============================================
IF OBJECT_ID('TR_customer_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_customer_Sync;
GO

CREATE TRIGGER TR_customer_Sync
ON customer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE customerTable AS target
        USING inserted AS source
        ON target.customerID = source.customerID
        WHEN MATCHED THEN
            UPDATE SET 
                customerType = source.customerType,
                firstName = source.firstName,
                lastName = source.lastName,
                email = source.email,
                tel = source.tel,
                city = source.city,
                nic = source.nic,
                customerAddress = source.customerAddress,
                customerLocation = source.customerLocation,
                dob = source.dob,
                regDate = source.regDate,
                gender = source.gender,
                status = source.status
        WHEN NOT MATCHED THEN
            INSERT (customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status)
            VALUES (source.customerType, source.firstName, source.lastName, source.email, source.tel, source.city, source.nic, source.customerAddress, source.customerLocation, source.dob, source.regDate, source.gender, source.status);
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM customerTable 
        WHERE customerID IN (SELECT customerID FROM deleted);
    END
END;
GO

-- =============================================
-- 9. Sync data between projectTable and projects
-- =============================================
IF OBJECT_ID('TR_projects_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_projects_Sync;
GO

CREATE TRIGGER TR_projects_Sync
ON projects
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE projectTable AS target
        USING (
            SELECT 
                projectID,
                projectName,
                CASE projectType 
                    WHEN 0 THEN 'Printing'
                    WHEN 1 THEN 'Design'
                    WHEN 2 THEN 'Installation'
                    ELSE 'Other'
                END AS projectTypeName,
                location,
                customerID,
                customerName,
                createDate,
                status
            FROM inserted
        ) AS source
        ON target.projectID = source.projectID
        WHEN MATCHED THEN
            UPDATE SET 
                projectName = source.projectName,
                projectType = source.projectTypeName,
                location = source.location,
                customerID = source.customerID,
                customerName = source.customerName,
                createDate = source.createDate,
                status = source.status
        WHEN NOT MATCHED THEN
            INSERT (projectID, projectName, projectType, location, customerID, customerName, createDate, status)
            VALUES (source.projectID, source.projectName, source.projectTypeName, source.location, source.customerID, source.customerName, source.createDate, source.status);
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM projectTable 
        WHERE projectID IN (SELECT projectID FROM deleted);
    END
END;
GO

-- =============================================
-- 10. Create indexes for performance
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ITEMS_itemID' AND object_id = OBJECT_ID('ITEMS'))
    CREATE INDEX IX_ITEMS_itemID ON ITEMS(itemID);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ITEMS_barcode' AND object_id = OBJECT_ID('ITEMS'))
    CREATE INDEX IX_ITEMS_barcode ON ITEMS(barcode);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_STOCKBUYING_itemID' AND object_id = OBJECT_ID('STOCKBUYING'))
    CREATE INDEX IX_STOCKBUYING_itemID ON STOCKBUYING(itemID);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_JD_EMPLOYEE_PAYSHEET_empID' AND object_id = OBJECT_ID('JD_EMPLOYEE_PAYSHEET'))
    CREATE INDEX IX_JD_EMPLOYEE_PAYSHEET_empID ON JD_EMPLOYEE_PAYSHEET(empID);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_customer_nic' AND object_id = OBJECT_ID('customer'))
    CREATE INDEX IX_customer_nic ON customer(nic);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_customer_tel' AND object_id = OBJECT_ID('customer'))
    CREATE INDEX IX_customer_tel ON customer(tel);
GO

-- =============================================
-- 11. Migrate existing data if needed
-- =============================================
-- Copy data from itemTable to ITEMS if ITEMS is empty
IF NOT EXISTS (SELECT TOP 1 * FROM ITEMS)
BEGIN
    INSERT INTO ITEMS (itemID, modelNO, discription, supplierID, brand, category, barcode)
    SELECT itemID, modelID, details, supplier, brand, category, barcode
    FROM itemTable;
END
GO

-- Copy data from customerTable to customer if customer is empty
IF NOT EXISTS (SELECT TOP 1 * FROM customer)
BEGIN
    SET IDENTITY_INSERT customer ON;
    INSERT INTO customer (customerID, customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status)
    SELECT customerID, customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status
    FROM customerTable;
    SET IDENTITY_INSERT customer OFF;
END
GO

-- Copy data from projectTable to projects if projects is empty
IF NOT EXISTS (SELECT TOP 1 * FROM projects)
BEGIN
    INSERT INTO projects (projectID, projectName, projectType, location, customerID, customerName, createDate, status)
    SELECT 
        projectID,
        projectName,
        CASE projectType
            WHEN 'Printing' THEN 0
            WHEN 'Design' THEN 1
            WHEN 'Installation' THEN 2
            ELSE 3
        END AS projectType,
        location,
        customerID,
        customerName,
        createDate,
        status
    FROM projectTable;
END
GO

PRINT 'Database tables compatibility fix completed successfully!';
PRINT 'Created tables: ITEMS, STOCKBUYING, JD_EMPLOYEE_PAYSHEET, projects, workingProcedure, customer';
PRINT 'Created sync triggers to keep data synchronized';
GO

