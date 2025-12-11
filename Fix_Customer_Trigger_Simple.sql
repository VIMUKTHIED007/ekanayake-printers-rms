-- =============================================
-- Simple Fix: One-Way Sync Only
-- Prevents infinite loop by only syncing customer -> customerTable
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. DROP EXISTING TRIGGERS
-- =============================================

IF OBJECT_ID('TR_customer_Sync_customerTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_customer_Sync_customerTable;
GO

IF OBJECT_ID('TR_customerTable_Sync_customer', 'TR') IS NOT NULL
    DROP TRIGGER TR_customerTable_Sync_customer;
GO

-- =============================================
-- 2. CREATE ONE-WAY TRIGGER: customer -> customerTable
-- This is the only trigger needed since form inserts into customer
-- =============================================

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

PRINT '========================================';
PRINT 'Customer trigger fixed - one-way sync only!';
PRINT 'Form inserts into customer -> auto-syncs to customerTable';
PRINT 'No recursion possible!';
PRINT '========================================';
GO

