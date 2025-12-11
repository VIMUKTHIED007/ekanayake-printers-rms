-- =============================================
-- Table Compatibility Fix Script
-- Makes all tables compatible with dashboard queries
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. FIX sessionEnd TABLE - Add missing column
-- =============================================

-- Check if sessionStartID column exists, if not add it
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('sessionEnd') AND name = 'sessionStartID')
BEGIN
    ALTER TABLE sessionEnd
    ADD sessionStartID INT NULL;
    
    -- Update existing records to link to sessionStart
    UPDATE se
    SET se.sessionStartID = ss.sessionID
    FROM sessionEnd se
    INNER JOIN sessionStart ss ON se.userID = ss.userID
    WHERE se.sessionStartID IS NULL;
    
    PRINT 'Added sessionStartID column to sessionEnd table';
END
GO

-- =============================================
-- 2. CREATE STOCKBUYING TABLE (if missing)
-- =============================================

IF OBJECT_ID('STOCKBUYING', 'U') IS NULL
BEGIN
    CREATE TABLE STOCKBUYING(
        stockBuyingID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        itemID INT NOT NULL,
        FOREIGN KEY (itemID) REFERENCES itemTable(itemID),
        boughtQTY INT NOT NULL DEFAULT 0,
        unitPrice FLOAT NOT NULL,
        sellingPricePerUnit FLOAT,
        purchaseDate DATETIME DEFAULT GETDATE(),
        supplierID INT,
        totalAmount FLOAT,
        notes VARCHAR(500)
    );
    
    PRINT 'Created STOCKBUYING table';
END
GO

-- =============================================
-- 3. CREATE ITEMS TABLE (Legacy compatibility)
-- =============================================

IF OBJECT_ID('ITEMS', 'U') IS NULL
BEGIN
    CREATE TABLE ITEMS(
        itemID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        modelNO VARCHAR(50),
        discription VARCHAR(200),
        supplierID INT,
        brand VARCHAR(100),
        category VARCHAR(100),
        barcode BIGINT,
        status VARCHAR(50) DEFAULT 'Active',
        createdDate DATETIME DEFAULT GETDATE()
    );
    
    PRINT 'Created ITEMS table (legacy compatibility)';
END
GO

-- =============================================
-- 4. CREATE customer TABLE (Legacy compatibility)
-- =============================================

IF OBJECT_ID('customer', 'U') IS NULL
BEGIN
    CREATE TABLE customer(
        customerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        customerType VARCHAR(100),
        firstName VARCHAR(100),
        lastName VARCHAR(100),
        email VARCHAR(100),
        tel BIGINT,
        city VARCHAR(100),
        nic VARCHAR(20),
        customerAddress VARCHAR(200),
        customerLocation VARCHAR(100),
        dob DATE,
        regDate DATE DEFAULT GETDATE(),
        gender VARCHAR(20),
        status VARCHAR(50) DEFAULT 'Active'
    );
    
    PRINT 'Created customer table (legacy compatibility)';
END
GO

-- =============================================
-- 5. CREATE projects TABLE (Legacy compatibility)
-- =============================================

IF OBJECT_ID('projects', 'U') IS NULL
BEGIN
    CREATE TABLE projects(
        projectID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        projectName VARCHAR(100) NOT NULL,
        projectType VARCHAR(100),
        projectLocation VARCHAR(200),
        customerID INT,
        customerName VARCHAR(100),
        createDate DATE DEFAULT GETDATE(),
        startDate DATE,
        endDate DATE,
        workingProcedure VARCHAR(500),
        projectStatus VARCHAR(50) DEFAULT 'Active',
        assignedEngineerID INT,
        budget FLOAT,
        actualCost FLOAT,
        progressPercentage INT DEFAULT 0
    );
    
    PRINT 'Created projects table (legacy compatibility)';
END
GO

-- =============================================
-- 6. CREATE JD_EMPLOYEE_PAYSHEET TABLE (if missing)
-- =============================================

IF OBJECT_ID('JD_EMPLOYEE_PAYSHEET', 'U') IS NULL
BEGIN
    CREATE TABLE JD_EMPLOYEE_PAYSHEET(
        paysheetID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
        empID INT NOT NULL,
        empName VARCHAR(100),
        userType INT,
        Month DATE,
        basicSalary FLOAT,
        incentive FLOAT DEFAULT 0,
        workDays INT,
        otHours INT DEFAULT 0,
        etf FLOAT,
        epf FLOAT,
        deductions FLOAT DEFAULT 0,
        totalSalary FLOAT,
        paymentDate DATE,
        paymentStatus VARCHAR(50) DEFAULT 'Pending',
        createdDate DATETIME DEFAULT GETDATE()
    );
    
    PRINT 'Created JD_EMPLOYEE_PAYSHEET table';
END
GO

-- =============================================
-- 7. FIX AvailableSTOCKS table name (case sensitivity)
-- =============================================

-- Ensure availableSTOCKS exists (already in schema, but verify)
IF OBJECT_ID('AvailableSTOCKS', 'U') IS NOT NULL AND OBJECT_ID('availableSTOCKS', 'U') IS NULL
BEGIN
    -- Create synonym if needed
    EXEC sp_rename 'AvailableSTOCKS', 'availableSTOCKS';
    PRINT 'Renamed AvailableSTOCKS to availableSTOCKS';
END
GO

-- =============================================
-- 8. CREATE SYNONYMS FOR CASE-INSENSITIVE ACCESS
-- =============================================

-- Create synonyms for case variations
IF OBJECT_ID('AvailableSTOCKS', 'SN') IS NULL
BEGIN
    CREATE SYNONYM AvailableSTOCKS FOR availableSTOCKS;
    PRINT 'Created synonym AvailableSTOCKS';
END
GO

-- =============================================
-- 9. ADD MISSING COLUMNS TO EXISTING TABLES
-- =============================================

-- Add missing columns to itemTable if needed for ITEMS compatibility
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('itemTable') AND name = 'modelNO')
BEGIN
    ALTER TABLE itemTable ADD modelNO AS modelID;
    PRINT 'Added computed column modelNO to itemTable';
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('itemTable') AND name = 'discription')
BEGIN
    ALTER TABLE itemTable ADD discription AS details;
    PRINT 'Added computed column discription to itemTable';
END
GO

-- =============================================
-- 10. CREATE VIEWS FOR SEAMLESS COMPATIBILITY
-- =============================================

-- View: ITEMS as alias for itemTable
IF OBJECT_ID('VW_ITEMS', 'V') IS NOT NULL
    DROP VIEW VW_ITEMS;
GO

CREATE VIEW VW_ITEMS AS
SELECT 
    itemID,
    modelID AS modelNO,
    details AS discription,
    NULL AS supplierID,  -- Can be linked via supplier column
    brand,
    category,
    barcode,
    status,
    createdDate
FROM itemTable;
GO

-- View: customer as alias for customerTable
IF OBJECT_ID('VW_customer', 'V') IS NOT NULL
    DROP VIEW VW_customer;
GO

CREATE VIEW VW_customer AS
SELECT 
    customerID,
    customerType,
    firstName,
    lastName,
    email,
    tel,
    city,
    nic,
    customerAddress,
    customerLocation,
    dob,
    regDate,
    gender,
    status
FROM customerTable;
GO

-- View: projects as alias for projectTable
IF OBJECT_ID('VW_projects', 'V') IS NOT NULL
    DROP VIEW VW_projects;
GO

CREATE VIEW VW_projects AS
SELECT 
    projectID,
    projectName,
    projectType,
    projectLocation,
    customerID,
    customerName,
    createDate,
    startDate,
    endDate,
    workingProcedure,
    projectStatus,
    assignedEngineerID,
    budget,
    actualCost,
    progressPercentage
FROM projectTable;
GO

PRINT 'Created compatibility views';
GO

-- =============================================
-- 11. CREATE SYNCHRONIZATION TRIGGERS
-- =============================================

-- Trigger: Sync ITEMS <-> itemTable
IF OBJECT_ID('TR_ITEMS_Sync_itemTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_ITEMS_Sync_itemTable;
GO

CREATE TRIGGER TR_ITEMS_Sync_itemTable
ON ITEMS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sync to itemTable
    MERGE itemTable AS target
    USING (
        SELECT 
            itemID,
            modelNO AS modelID,
            discription AS details,
            brand,
            category,
            barcode,
            status,
            createdDate
        FROM inserted
    ) AS source
    ON target.itemID = source.itemID
    WHEN MATCHED THEN
        UPDATE SET
            modelID = source.modelID,
            details = source.details,
            brand = source.brand,
            category = source.category,
            barcode = source.barcode,
            status = source.status,
            lastUpdated = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (modelID, brand, category, details, barcode, status, createdDate)
        VALUES (source.modelID, source.brand, source.category, source.details, source.barcode, source.status, source.createdDate);
END;
GO

-- Trigger: Sync itemTable -> ITEMS
IF OBJECT_ID('TR_itemTable_Sync_ITEMS', 'TR') IS NOT NULL
    DROP TRIGGER TR_itemTable_Sync_ITEMS;
GO

CREATE TRIGGER TR_itemTable_Sync_ITEMS
ON itemTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sync to ITEMS
    MERGE ITEMS AS target
    USING (
        SELECT 
            itemID,
            modelID AS modelNO,
            details AS discription,
            brand,
            category,
            barcode,
            status,
            createdDate
        FROM inserted
    ) AS source
    ON target.itemID = source.itemID
    WHEN MATCHED THEN
        UPDATE SET
            modelNO = source.modelNO,
            discription = source.discription,
            brand = source.brand,
            category = source.category,
            barcode = source.barcode,
            status = source.status
    WHEN NOT MATCHED THEN
        INSERT (modelNO, discription, brand, category, barcode, status, createdDate)
        VALUES (source.modelNO, source.discription, source.brand, source.category, source.barcode, source.status, source.createdDate);
END;
GO

-- Trigger: Sync customer -> customerTable (ONE-WAY ONLY to prevent recursion)
-- The form inserts into customer, so we only need customer -> customerTable sync
IF OBJECT_ID('TR_customer_Sync_customerTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_customer_Sync_customerTable;
GO

CREATE TRIGGER TR_customer_Sync_customerTable
ON customer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Handle INSERT and UPDATE
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
                regDate = ISNULL(source.regDate, GETDATE()),
                gender = source.gender,
                status = ISNULL(source.status, 'Active')
        WHEN NOT MATCHED THEN
            INSERT (customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status)
            VALUES (source.customerType, source.firstName, source.lastName, source.email, source.tel, source.city, source.nic, 
                    source.customerAddress, source.customerLocation, source.dob, ISNULL(source.regDate, GETDATE()), source.gender, ISNULL(source.status, 'Active'));
    END
    
    -- Handle DELETE
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM customerTable 
        WHERE customerID IN (SELECT customerID FROM deleted);
    END
END;
GO

-- NOTE: Removed reverse trigger (customerTable -> customer) to prevent infinite recursion
-- Since the form only inserts into customer table, one-way sync is sufficient
-- If you need bidirectional sync, use CONTEXT_INFO to prevent recursion (see Fix_Customer_Trigger_Recursion.sql)
GO

-- Trigger: Sync projects <-> projectTable
IF OBJECT_ID('TR_projects_Sync_projectTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_projects_Sync_projectTable;
GO

CREATE TRIGGER TR_projects_Sync_projectTable
ON projects
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    MERGE projectTable AS target
    USING inserted AS source
    ON target.projectID = source.projectID
    WHEN MATCHED THEN
        UPDATE SET
            projectName = source.projectName,
            projectType = source.projectType,
            projectLocation = source.projectLocation,
            customerID = source.customerID,
            customerName = source.customerName,
            createDate = source.createDate,
            startDate = source.startDate,
            endDate = source.endDate,
            workingProcedure = source.workingProcedure,
            projectStatus = source.projectStatus,
            assignedEngineerID = source.assignedEngineerID,
            budget = source.budget,
            actualCost = source.actualCost,
            progressPercentage = source.progressPercentage
    WHEN NOT MATCHED THEN
        INSERT (projectName, projectType, projectLocation, customerID, customerName, createDate, startDate, endDate, 
                workingProcedure, projectStatus, assignedEngineerID, budget, actualCost, progressPercentage)
        VALUES (source.projectName, source.projectType, source.projectLocation, source.customerID, source.customerName, 
                source.createDate, source.startDate, source.endDate, source.workingProcedure, source.projectStatus, 
                source.assignedEngineerID, source.budget, source.actualCost, source.progressPercentage);
END;
GO

-- Trigger: Sync projectTable -> projects
IF OBJECT_ID('TR_projectTable_Sync_projects', 'TR') IS NOT NULL
    DROP TRIGGER TR_projectTable_Sync_projects;
GO

CREATE TRIGGER TR_projectTable_Sync_projects
ON projectTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    MERGE projects AS target
    USING inserted AS source
    ON target.projectID = source.projectID
    WHEN MATCHED THEN
        UPDATE SET
            projectName = source.projectName,
            projectType = source.projectType,
            projectLocation = source.projectLocation,
            customerID = source.customerID,
            customerName = source.customerName,
            createDate = source.createDate,
            startDate = source.startDate,
            endDate = source.endDate,
            workingProcedure = source.workingProcedure,
            projectStatus = source.projectStatus,
            assignedEngineerID = source.assignedEngineerID,
            budget = source.budget,
            actualCost = source.actualCost,
            progressPercentage = source.progressPercentage
    WHEN NOT MATCHED THEN
        INSERT (projectName, projectType, projectLocation, customerID, customerName, createDate, startDate, endDate, 
                workingProcedure, projectStatus, assignedEngineerID, budget, actualCost, progressPercentage)
        VALUES (source.projectName, source.projectType, source.projectLocation, source.customerID, source.customerName, 
                source.createDate, source.startDate, source.endDate, source.workingProcedure, source.projectStatus, 
                source.assignedEngineerID, source.budget, source.actualCost, source.progressPercentage);
END;
GO

-- Trigger: STOCKBUYING -> Update availableSTOCKS
IF OBJECT_ID('TR_STOCKBUYING_Update_AvailableStocks', 'TR') IS NOT NULL
    DROP TRIGGER TR_STOCKBUYING_Update_AvailableStocks;
GO

CREATE TRIGGER TR_STOCKBUYING_Update_AvailableStocks
ON STOCKBUYING
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update or insert into availableSTOCKS
    MERGE availableSTOCKS AS target
    USING (
        SELECT 
            itemID,
            SUM(boughtQTY) AS totalBought
        FROM inserted
        GROUP BY itemID
    ) AS source
    ON target.itemID = source.itemID
    WHEN MATCHED THEN
        UPDATE SET
            availableQTY = availableQTY + source.totalBought,
            lastUpdatedDATE = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (itemID, availableQTY, lastUpdatedDATE)
        VALUES (source.itemID, source.totalBought, GETDATE());
    
    -- Also update itemTable quantity
    UPDATE itemTable
    SET quantity = quantity + (
        SELECT SUM(boughtQTY) 
        FROM inserted 
        WHERE inserted.itemID = itemTable.itemID
    ),
    lastUpdated = GETDATE()
    WHERE itemID IN (SELECT itemID FROM inserted);
END;
GO

PRINT 'Created synchronization triggers';
GO

-- =============================================
-- 12. CREATE INDEXES FOR PERFORMANCE
-- =============================================

-- Indexes on STOCKBUYING
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_STOCKBUYING_itemID' AND object_id = OBJECT_ID('STOCKBUYING'))
    CREATE INDEX IX_STOCKBUYING_itemID ON STOCKBUYING(itemID);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_STOCKBUYING_purchaseDate' AND object_id = OBJECT_ID('STOCKBUYING'))
    CREATE INDEX IX_STOCKBUYING_purchaseDate ON STOCKBUYING(purchaseDate);
GO

-- Indexes on ITEMS
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ITEMS_modelNO' AND object_id = OBJECT_ID('ITEMS'))
    CREATE INDEX IX_ITEMS_modelNO ON ITEMS(modelNO);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ITEMS_barcode' AND object_id = OBJECT_ID('ITEMS'))
    CREATE INDEX IX_ITEMS_barcode ON ITEMS(barcode);
GO

-- Indexes on customer
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_customer_nic' AND object_id = OBJECT_ID('customer'))
    CREATE INDEX IX_customer_nic ON customer(nic);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_customer_tel' AND object_id = OBJECT_ID('customer'))
    CREATE INDEX IX_customer_tel ON customer(tel);
GO

-- Indexes on projects
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_projects_customerID' AND object_id = OBJECT_ID('projects'))
    CREATE INDEX IX_projects_customerID ON projects(customerID);
GO

PRINT 'Created performance indexes';
GO

-- =============================================
-- COMPLETION MESSAGE
-- =============================================

PRINT '';
PRINT '=============================================';
PRINT 'Table Compatibility Fix Completed!';
PRINT '=============================================';
PRINT '';
PRINT 'All tables are now compatible:';
PRINT '  - STOCKBUYING table created';
PRINT '  - ITEMS table created (legacy)';
PRINT '  - customer table created (legacy)';
PRINT '  - projects table created (legacy)';
PRINT '  - JD_EMPLOYEE_PAYSHEET table created';
PRINT '  - sessionEnd.sessionStartID column added';
PRINT '  - Compatibility views created';
PRINT '  - Synchronization triggers created';
PRINT '  - Performance indexes created';
PRINT '';
PRINT 'All dashboards should now be able to query data successfully!';
PRINT '=============================================';
GO

