-- =============================================
-- Fix Database Tables - Update Script
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- Drop and recreate the projects sync trigger with correct column names
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
                location AS projectLocation,
                customerID,
                customerName,
                createDate,
                'Active' AS projectStatus
            FROM inserted
        ) AS source
        ON CAST(target.projectID AS varchar(50)) = source.projectID
        WHEN MATCHED THEN
            UPDATE SET 
                projectName = source.projectName,
                projectType = source.projectTypeName,
                projectLocation = source.projectLocation,
                customerID = CAST(source.customerID AS INT),
                customerName = source.customerName,
                createDate = source.createDate,
                projectStatus = source.projectStatus
        WHEN NOT MATCHED THEN
            INSERT (projectID, projectName, projectType, projectLocation, customerID, customerName, createDate, projectStatus)
            VALUES (CAST(source.projectID AS INT), source.projectName, source.projectTypeName, source.projectLocation, CAST(source.customerID AS INT), source.customerName, source.createDate, source.projectStatus);
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DELETE FROM projectTable 
        WHERE CAST(projectID AS varchar(50)) IN (SELECT projectID FROM deleted);
    END
END;
GO

-- Fix ITEMS data migration with IDENTITY_INSERT
IF EXISTS (SELECT TOP 1 * FROM itemTable WHERE itemID NOT IN (SELECT itemID FROM ITEMS))
BEGIN
    SET IDENTITY_INSERT ITEMS ON;
    INSERT INTO ITEMS (itemID, modelNO, discription, supplierID, brand, category, barcode)
    SELECT itemID, modelID, details, supplier, brand, category, barcode
    FROM itemTable
    WHERE itemID NOT IN (SELECT itemID FROM ITEMS);
    SET IDENTITY_INSERT ITEMS OFF;
END
GO

-- Add missing columns to projects table if needed
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'projects' AND COLUMN_NAME = 'status')
BEGIN
    ALTER TABLE projects ADD status varchar(50) DEFAULT 'Active';
END
GO

-- Update projects table structure to match application expectations
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'projects' AND COLUMN_NAME = 'location')
BEGIN
    ALTER TABLE projects ADD location varchar(200);
END
GO

-- Ensure projects table has all required columns
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'projects' AND COLUMN_NAME = 'projectType')
BEGIN
    ALTER TABLE projects ADD projectType INT;
END
GO

PRINT 'Database tables update completed successfully!';
GO

