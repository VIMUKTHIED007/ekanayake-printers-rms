-- =============================================
-- Fix Customer Table Trigger Recursion Issue
-- Prevents infinite loop between customer and customerTable triggers
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
-- 2. CREATE FIXED TRIGGER: customer -> customerTable
-- Uses CONTEXT_INFO to prevent recursion
-- =============================================

CREATE TRIGGER TR_customer_Sync_customerTable
ON customer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if we're already in a sync operation (prevent recursion)
    IF CONTEXT_INFO() = 0x01
        RETURN;
    
    -- Set flag to prevent reverse trigger from firing
    SET CONTEXT_INFO 0x01;
    
    BEGIN TRY
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
    END TRY
    BEGIN CATCH
        -- Reset flag on error
        SET CONTEXT_INFO 0x00;
        THROW;
    END CATCH
    
    -- Reset flag
    SET CONTEXT_INFO 0x00;
END;
GO

-- =============================================
-- 3. CREATE FIXED TRIGGER: customerTable -> customer
-- Uses CONTEXT_INFO to prevent recursion
-- =============================================

CREATE TRIGGER TR_customerTable_Sync_customer
ON customerTable
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if we're already in a sync operation (prevent recursion)
    IF CONTEXT_INFO() = 0x01
        RETURN;
    
    -- Set flag to prevent reverse trigger from firing
    SET CONTEXT_INFO 0x01;
    
    BEGIN TRY
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
    END TRY
    BEGIN CATCH
        -- Reset flag on error
        SET CONTEXT_INFO 0x00;
        THROW;
    END CATCH
    
    -- Reset flag
    SET CONTEXT_INFO 0x00;
END;
GO

PRINT '========================================';
PRINT 'Customer triggers fixed - recursion prevented!';
PRINT '========================================';
GO

