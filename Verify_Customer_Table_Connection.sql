-- =============================================
-- Verify Customer Table Connection
-- This script verifies that customer and customerTable are properly connected
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. CHECK IF TABLES EXIST
-- =============================================

PRINT '========================================';
PRINT '1. Checking if tables exist...';
PRINT '========================================';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'customer')
    PRINT '✓ customer table exists';
ELSE
    PRINT '✗ customer table DOES NOT exist';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'customerTable')
    PRINT '✓ customerTable exists';
ELSE
    PRINT '✗ customerTable DOES NOT exist';

GO

-- =============================================
-- 2. CHECK IF SYNC TRIGGERS EXIST
-- =============================================

PRINT '';
PRINT '========================================';
PRINT '2. Checking if sync triggers exist...';
PRINT '========================================';

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_customer_Sync_customerTable')
    PRINT '✓ TR_customer_Sync_customerTable trigger exists';
ELSE
    PRINT '✗ TR_customer_Sync_customerTable trigger DOES NOT exist - NEEDS TO BE CREATED';

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_customerTable_Sync_customer')
    PRINT '✓ TR_customerTable_Sync_customer trigger exists';
ELSE
    PRINT '✗ TR_customerTable_Sync_customer trigger DOES NOT exist - NEEDS TO BE CREATED';

GO

-- =============================================
-- 3. CREATE SYNC TRIGGERS IF THEY DON'T EXIST
-- =============================================

PRINT '';
PRINT '========================================';
PRINT '3. Creating sync triggers if needed...';
PRINT '========================================';

-- Trigger: Sync customer -> customerTable
IF OBJECT_ID('TR_customer_Sync_customerTable', 'TR') IS NULL
BEGIN
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
    
    PRINT '✓ Created TR_customer_Sync_customerTable trigger';
END
ELSE
    PRINT '✓ TR_customer_Sync_customerTable trigger already exists';

GO

-- Trigger: Sync customerTable -> customer
IF OBJECT_ID('TR_customerTable_Sync_customer', 'TR') IS NULL
BEGIN
    CREATE TRIGGER TR_customerTable_Sync_customer
    ON customerTable
    AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
        SET NOCOUNT ON;
        
        -- Handle INSERT and UPDATE
        IF EXISTS (SELECT * FROM inserted)
        BEGIN
            MERGE customer AS target
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
            DELETE FROM customer 
            WHERE customerID IN (SELECT customerID FROM deleted);
        END
    END;
    
    PRINT '✓ Created TR_customerTable_Sync_customer trigger';
END
ELSE
    PRINT '✓ TR_customerTable_Sync_customer trigger already exists';

GO

-- =============================================
-- 4. VERIFY DATA SYNC
-- =============================================

PRINT '';
PRINT '========================================';
PRINT '4. Verifying data synchronization...';
PRINT '========================================';

DECLARE @customerCount INT = (SELECT COUNT(*) FROM customer);
DECLARE @customerTableCount INT = (SELECT COUNT(*) FROM customerTable);

PRINT 'Records in customer table: ' + CAST(@customerCount AS VARCHAR(10));
PRINT 'Records in customerTable: ' + CAST(@customerTableCount AS VARCHAR(10));

IF @customerCount = @customerTableCount
    PRINT '✓ Record counts match - tables are synchronized';
ELSE
    PRINT '⚠ Record counts DO NOT match - tables may need synchronization';

-- Check for mismatched records
IF EXISTS (
    SELECT c.customerID 
    FROM customer c 
    LEFT JOIN customerTable ct ON c.customerID = ct.customerID 
    WHERE ct.customerID IS NULL
)
    PRINT '⚠ Some records in customer table are not in customerTable';
ELSE
    PRINT '✓ All customer records exist in customerTable';

IF EXISTS (
    SELECT ct.customerID 
    FROM customerTable ct 
    LEFT JOIN customer c ON ct.customerID = c.customerID 
    WHERE c.customerID IS NULL
)
    PRINT '⚠ Some records in customerTable are not in customer table';
ELSE
    PRINT '✓ All customerTable records exist in customer table';

GO

-- =============================================
-- 5. TEST INSERT (Optional - Comment out if not needed)
-- =============================================

/*
PRINT '';
PRINT '========================================';
PRINT '5. Testing insert synchronization...';
PRINT '========================================';

-- Test insert into customer table
INSERT INTO customer (customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, gender, status)
VALUES ('Test', 'Test', 'Customer', 'test@test.com', 123456789, 'Test City', 'TEST123V', 'Test Address', 'Test Location', '2000-01-01', 'Male', 'Active');

-- Check if it synced to customerTable
IF EXISTS (SELECT * FROM customerTable WHERE firstName = 'Test' AND lastName = 'Customer')
BEGIN
    PRINT '✓ Test insert successful - data synced to customerTable';
    -- Clean up test data
    DELETE FROM customer WHERE firstName = 'Test' AND lastName = 'Customer';
    DELETE FROM customerTable WHERE firstName = 'Test' AND lastName = 'Customer';
    PRINT '✓ Test data cleaned up';
END
ELSE
    PRINT '✗ Test insert FAILED - data did not sync to customerTable';
*/

GO

PRINT '';
PRINT '========================================';
PRINT 'Verification Complete!';
PRINT '========================================';
PRINT '';
PRINT 'The customer registration form inserts into the "customer" table.';
PRINT 'The trigger automatically syncs data to "customerTable".';
PRINT 'Both tables should always have the same data.';
GO

