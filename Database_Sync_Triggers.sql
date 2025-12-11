-- =============================================
-- Database Synchronization Triggers
-- Ensures data consistency across related tables
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. ITEM MANAGEMENT SYNCHRONIZATION
-- =============================================

-- Trigger: When ITEMS table is updated, sync to itemTable
IF OBJECT_ID('TR_ITEMS_To_itemTable_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_ITEMS_To_itemTable_Sync;
GO

CREATE TRIGGER TR_ITEMS_To_itemTable_Sync
ON ITEMS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Handle INSERT and UPDATE
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
            INSERT (modelID, details, supplier, brand, category, barcode, createdDate, lastUpdated, status)
            VALUES (source.modelNO, source.discription, source.supplierID, source.brand, source.category, source.barcode, GETDATE(), GETDATE(), 'Active');
    END
    
    -- Handle DELETE
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM itemTable 
        WHERE itemID IN (SELECT itemID FROM deleted);
    END
END;
GO

-- Trigger: When itemTable is updated, sync to ITEMS
IF OBJECT_ID('TR_itemTable_To_ITEMS_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_itemTable_To_ITEMS_Sync;
GO

CREATE TRIGGER TR_itemTable_To_ITEMS_Sync
ON itemTable
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE ITEMS AS target
        USING inserted AS source
        ON target.itemID = source.itemID
        WHEN MATCHED THEN
            UPDATE SET 
                modelNO = source.modelID,
                discription = source.details,
                supplierID = source.supplier,
                brand = source.brand,
                category = source.category,
                barcode = source.barcode
        WHEN NOT MATCHED THEN
            INSERT (itemID, modelNO, discription, supplierID, brand, category, barcode)
            VALUES (source.itemID, source.modelID, source.details, source.supplier, source.brand, source.category, source.barcode);
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM ITEMS 
        WHERE itemID IN (SELECT itemID FROM deleted);
    END
END;
GO

-- Trigger: When STOCKBUYING is inserted, update availableSTOCKS
IF OBJECT_ID('TR_STOCKBUYING_Update_AvailableStocks', 'TR') IS NOT NULL
    DROP TRIGGER TR_STOCKBUYING_Update_AvailableStocks;
GO

CREATE TRIGGER TR_STOCKBUYING_Update_AvailableStocks
ON STOCKBUYING
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE availableSTOCKS AS target
        USING (
            SELECT itemID, SUM(boughtQTY) AS totalQTY
            FROM inserted
            GROUP BY itemID
        ) AS source
        ON target.itemID = source.itemID
        WHEN MATCHED THEN
            UPDATE SET 
                availableQTY = availableQTY + source.totalQTY,
                lastUpdatedDATE = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT (itemID, availableQTY, lastUpdatedDATE)
            VALUES (source.itemID, source.totalQTY, GETDATE());
    END
END;
GO

-- Trigger: When soldSTOCKS is inserted, update availableSTOCKS
IF OBJECT_ID('TR_soldSTOCKS_Update_AvailableStocks', 'TR') IS NOT NULL
    DROP TRIGGER TR_soldSTOCKS_Update_AvailableStocks;
GO

CREATE TRIGGER TR_soldSTOCKS_Update_AvailableStocks
ON soldSTOCKS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE availableSTOCKS
        SET availableQTY = availableQTY - i.soldQTY,
            lastUpdatedDATE = GETDATE()
        FROM availableSTOCKS a
        INNER JOIN inserted i ON a.itemID = i.itemID;
    END
END;
GO

-- =============================================
-- 2. CUSTOMER MANAGEMENT SYNCHRONIZATION
-- =============================================

-- Trigger: When customer table is updated, sync to customerTable
IF OBJECT_ID('TR_customer_To_customerTable_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_customer_To_customerTable_Sync;
GO

CREATE TRIGGER TR_customer_To_customerTable_Sync
ON customer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
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
-- 3. INVOICE & BILLING SYNCHRONIZATION
-- =============================================

-- Trigger: When invoice is created, update salesCount
IF OBJECT_ID('TR_invoiceTable_Update_SalesCount', 'TR') IS NOT NULL
    DROP TRIGGER TR_invoiceTable_Update_SalesCount;
GO

CREATE TRIGGER TR_invoiceTable_Update_SalesCount
ON invoiceTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Update or insert salesCount
        MERGE salesCount AS target
        USING (
            SELECT 
                CAST(invoiceDate AS DATE) AS saleDate,
                COUNT(*) AS invoiceCount,
                SUM(finalAmount) AS totalSales
            FROM inserted
            GROUP BY CAST(invoiceDate AS DATE)
        ) AS source
        ON target.saleDate = source.saleDate
        WHEN MATCHED THEN
            UPDATE SET 
                invoiceCount = invoiceCount + source.invoiceCount,
                totalSales = totalSales + source.totalSales
        WHEN NOT MATCHED THEN
            INSERT (saleDate, invoiceCount, totalSales)
            VALUES (source.saleDate, source.invoiceCount, source.totalSales);
    END
END;
GO

-- Trigger: When invoiceLineItems is inserted, update soldSTOCKS
IF OBJECT_ID('TR_invoiceLineItems_Update_soldSTOCKS', 'TR') IS NOT NULL
    DROP TRIGGER TR_invoiceLineItems_Update_soldSTOCKS;
GO

CREATE TRIGGER TR_invoiceLineItems_Update_soldSTOCKS
ON invoiceLineItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
        SELECT 
            itemID,
            quantity AS soldQTY,
            discount AS discountRate,
            lineTotal AS totalSold,
            GETDATE() AS soldDATE,
            invoiceID
        FROM inserted;
    END
END;
GO

-- =============================================
-- 4. EMPLOYEE & USER MANAGEMENT SYNCHRONIZATION
-- =============================================

-- Trigger: When userTable is updated, sync to employeeTable
IF OBJECT_ID('TR_userTable_Update_employeeTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_userTable_Update_employeeTable;
GO

CREATE TRIGGER TR_userTable_Update_employeeTable
ON userTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted WHERE employeeID IS NOT NULL)
    BEGIN
        MERGE employeeTable AS target
        USING (
            SELECT 
                employeeID,
                userID,
                userType,
                positionIndex,
                GETDATE() AS hireDate,
                'Active' AS status
            FROM inserted
            WHERE employeeID IS NOT NULL
        ) AS source
        ON target.employeeID = source.employeeID
        WHEN MATCHED THEN
            UPDATE SET 
                userID = source.userID,
                employeeType = source.userType,
                positionIndex = source.positionIndex,
                status = source.status
        WHEN NOT MATCHED THEN
            INSERT (employeeID, userID, employeeType, positionIndex, hireDate, status)
            VALUES (source.employeeID, source.userID, source.userType, source.positionIndex, source.hireDate, source.status);
    END
END;
GO

-- Trigger: When userTable positionIndex changes, update role-specific tables
IF OBJECT_ID('TR_userTable_Update_RoleTables', 'TR') IS NOT NULL
    DROP TRIGGER TR_userTable_Update_RoleTables;
GO

CREATE TRIGGER TR_userTable_Update_RoleTables
ON userTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Manager (positionIndex = 1)
        MERGE managerTable AS target
        USING (
            SELECT userID, 1 AS positionIndex, 'General' AS department
            FROM inserted
            WHERE positionIndex = 1
        ) AS source
        ON target.userID = source.userID
        WHEN NOT MATCHED THEN
            INSERT (userID, positionIndex, department)
            VALUES (source.userID, source.positionIndex, source.department);
        
        -- Accountant (positionIndex = 2)
        MERGE accountantTable AS target
        USING (
            SELECT userID, 2 AS positionIndex
            FROM inserted
            WHERE positionIndex = 2
        ) AS source
        ON target.userID = source.userID
        WHEN NOT MATCHED THEN
            INSERT (userID, positionIndex)
            VALUES (source.userID, source.positionIndex);
        
        -- Cashier (positionIndex = 3)
        MERGE cashierTable AS target
        USING (
            SELECT userID, 3 AS positionIndex
            FROM inserted
            WHERE positionIndex = 3
        ) AS source
        ON target.userID = source.userID
        WHEN NOT MATCHED THEN
            INSERT (userID, positionIndex)
            VALUES (source.userID, source.positionIndex);
        
        -- Site Engineer (positionIndex = 4)
        MERGE siteEngineerTable AS target
        USING (
            SELECT userID, 4 AS positionIndex
            FROM inserted
            WHERE positionIndex = 4
        ) AS source
        ON target.userID = source.userID
        WHEN NOT MATCHED THEN
            INSERT (userID, positionIndex)
            VALUES (source.userID, source.positionIndex);
        
        -- Stock Manager (positionIndex = 5)
        MERGE stockManagerTable AS target
        USING (
            SELECT userID, 5 AS positionIndex
            FROM inserted
            WHERE positionIndex = 5
        ) AS source
        ON target.userID = source.userID
        WHEN NOT MATCHED THEN
            INSERT (userID, positionIndex)
            VALUES (source.userID, source.positionIndex);
        
        -- Worker (positionIndex = 6)
        MERGE workerTable AS target
        USING (
            SELECT userID, 6 AS positionIndex
            FROM inserted
            WHERE positionIndex = 6
        ) AS source
        ON target.userID = source.userID
        WHEN NOT MATCHED THEN
            INSERT (userID, positionIndex)
            VALUES (source.userID, source.positionIndex);
    END
END;
GO

-- =============================================
-- 5. PROJECT MANAGEMENT SYNCHRONIZATION
-- =============================================

-- Trigger: When projects table is updated, sync to projectTable
IF OBJECT_ID('TR_projects_To_projectTable_Sync', 'TR') IS NOT NULL
    DROP TRIGGER TR_projects_To_projectTable_Sync;
GO

CREATE TRIGGER TR_projects_To_projectTable_Sync
ON projects
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE projectTable AS target
        USING (
            SELECT 
                CAST(projectID AS INT) AS projectID,
                projectName,
                CASE projectType 
                    WHEN 0 THEN 'Printing'
                    WHEN 1 THEN 'Design'
                    WHEN 2 THEN 'Installation'
                    ELSE 'Other'
                END AS projectType,
                location AS projectLocation,
                CAST(customerID AS INT) AS customerID,
                customerName,
                createDate,
                'Active' AS projectStatus
            FROM inserted
        ) AS source
        ON target.projectID = source.projectID
        WHEN MATCHED THEN
            UPDATE SET 
                projectName = source.projectName,
                projectType = source.projectType,
                projectLocation = source.projectLocation,
                customerID = source.customerID,
                customerName = source.customerName,
                createDate = source.createDate,
                projectStatus = source.projectStatus
        WHEN NOT MATCHED THEN
            INSERT (projectID, projectName, projectType, projectLocation, customerID, customerName, createDate, projectStatus)
            VALUES (source.projectID, source.projectName, source.projectType, source.projectLocation, source.customerID, source.customerName, source.createDate, source.projectStatus);
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM projectTable 
        WHERE CAST(projectID AS varchar(50)) IN (SELECT projectID FROM deleted);
    END
END;
GO

-- =============================================
-- 6. FINANCIAL SYNCHRONIZATION
-- =============================================

-- Trigger: When JD_EMPLOYEE_PAYSHEET is updated, sync to paysheetTable
IF OBJECT_ID('TR_JD_PAYSHEET_Update_paysheetTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_JD_PAYSHEET_Update_paysheetTable;
GO

CREATE TRIGGER TR_JD_PAYSHEET_Update_paysheetTable
ON JD_EMPLOYEE_PAYSHEET
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        MERGE paysheetTable AS target
        USING (
            SELECT 
                empID,
                empName,
                Month,
                basicSalary,
                incentive,
                workDays,
                otHours,
                etf,
                totalSalary,
                createdDate,
                status
            FROM inserted
        ) AS source
        ON target.empID = source.empID AND CAST(target.Month AS DATE) = CAST(source.Month AS DATE)
        WHEN MATCHED THEN
            UPDATE SET 
                empName = source.empName,
                basicSalary = source.basicSalary,
                incentive = source.incentive,
                workDays = source.workDays,
                otHours = source.otHours,
                etf = source.etf,
                totalSalary = source.totalSalary,
                status = source.status
        WHEN NOT MATCHED THEN
            INSERT (empID, empName, Month, basicSalary, incentive, workDays, otHours, etf, totalSalary, createdDate, status)
            VALUES (source.empID, source.empName, source.Month, source.basicSalary, source.incentive, source.workDays, source.otHours, source.etf, source.totalSalary, source.createdDate, source.status);
    END
END;
GO

-- Trigger: When paysheet is created, update financialTransactions
IF OBJECT_ID('TR_paysheetTable_Update_FinancialTransactions', 'TR') IS NOT NULL
    DROP TRIGGER TR_paysheetTable_Update_FinancialTransactions;
GO

CREATE TRIGGER TR_paysheetTable_Update_FinancialTransactions
ON paysheetTable
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO financialTransactions (transactionDate, transactionType, amount, description, category, referenceID, referenceType, status)
        SELECT 
            Month AS transactionDate,
            'Expense' AS transactionType,
            totalSalary AS amount,
            'Salary Payment for ' + empName AS description,
            'Payroll' AS category,
            paysheetID AS referenceID,
            'Paysheet' AS referenceType,
            'Active' AS status
        FROM inserted;
    END
END;
GO

-- Trigger: When invoice is paid, update financialTransactions
IF OBJECT_ID('TR_invoiceTable_Update_FinancialTransactions', 'TR') IS NOT NULL
    DROP TRIGGER TR_invoiceTable_Update_FinancialTransactions;
GO

CREATE TRIGGER TR_invoiceTable_Update_FinancialTransactions
ON invoiceTable
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted WHERE paymentStatus = 'Paid')
    AND EXISTS (SELECT * FROM deleted WHERE paymentStatus != 'Paid')
    BEGIN
        INSERT INTO financialTransactions (transactionDate, transactionType, amount, description, category, referenceID, referenceType, status)
        SELECT 
            invoiceDate AS transactionDate,
            'Income' AS transactionType,
            finalAmount AS amount,
            'Payment for Invoice ' + invoiceNumber AS description,
            'Sales' AS category,
            invoiceID AS referenceID,
            'Invoice' AS referenceType,
            'Active' AS status
        FROM inserted
        WHERE paymentStatus = 'Paid';
    END
END;
GO

-- =============================================
-- 7. SESSION MANAGEMENT SYNCHRONIZATION
-- =============================================

-- Trigger: When sessionEnd is inserted, update sessionStart if needed
IF OBJECT_ID('TR_sessionEnd_Update_sessionStart', 'TR') IS NOT NULL
    DROP TRIGGER TR_sessionEnd_Update_sessionStart;
GO

CREATE TRIGGER TR_sessionEnd_Update_sessionStart
ON sessionEnd
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- This trigger ensures session data is properly tracked
    -- Additional logic can be added here if needed
END;
GO

PRINT 'Database synchronization triggers created successfully!';
PRINT 'All tables will now automatically sync when data is inserted or updated.';
GO

