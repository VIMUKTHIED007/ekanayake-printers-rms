-- =============================================
-- Sample Stock Data for Ekanayake Printers RMS
-- Inserts sample data into stock-related tables
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. STOCK BUYING DATA (STOCKBUYING table)
-- =============================================

-- Clear existing stock buying data (optional - comment out if you want to keep existing data)
-- DELETE FROM STOCKBUYING;
-- GO

-- Get itemIDs from itemTable (assuming items already exist)
DECLARE @Item1 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'BK001' OR modelID LIKE '%BK001%' ORDER BY itemID);
DECLARE @Item2 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'BK002' OR modelID LIKE '%BK002%' ORDER BY itemID);
DECLARE @Item3 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'BK003' OR modelID LIKE '%BK003%' ORDER BY itemID);
DECLARE @Item4 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'BK004' OR modelID LIKE '%BK004%' ORDER BY itemID);
DECLARE @Item5 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'ST001' OR modelID LIKE '%ST001%' ORDER BY itemID);
DECLARE @Item6 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'ST002' OR modelID LIKE '%ST002%' ORDER BY itemID);
DECLARE @Item7 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'PR001' OR modelID LIKE '%PR001%' ORDER BY itemID);

-- If items don't exist, create sample items first
IF @Item1 IS NULL OR @Item2 IS NULL OR @Item3 IS NULL
BEGIN
    PRINT 'Creating sample items first...';
    
    -- Insert sample items if they don't exist
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'BK001')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('BK001', 'Penguin Classics', 'Books', 'Pride and Prejudice', 0, 9780141439518, 'Colombo Book Distributors', 1200.00, 800.00, 'Active');
    
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'BK002')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('BK002', 'HarperCollins', 'Books', 'To Kill a Mockingbird', 0, 9780061120084, 'Colombo Book Distributors', 1500.00, 1000.00, 'Active');
    
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'BK003')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('BK003', 'Oxford University Press', 'Books', 'Oxford English Dictionary', 0, 9780198611868, 'Education Publishers', 3500.00, 2500.00, 'Active');
    
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'BK004')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('BK004', 'Scholastic', 'Books', 'Harry Potter and the Philosophers Stone', 0, 9780439708180, 'Colombo Book Distributors', 1800.00, 1200.00, 'Active');
    
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'ST001')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('ST001', 'Butterfly', 'Stationery', 'A4 Ruled Notebook 200 pages', 0, 1234567890123, 'Office Supplies Co', 250.00, 150.00, 'Active');
    
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'ST002')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('ST002', 'Butterfly', 'Stationery', 'Blue Ballpoint Pen Pack of 10', 0, 1234567890124, 'Office Supplies Co', 180.00, 100.00, 'Active');
    
    IF NOT EXISTS (SELECT * FROM itemTable WHERE modelID = 'PR001')
        INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
        VALUES ('PR001', 'Canon', 'Printing', 'Canon PG-810 Black Ink Cartridge', 0, 1234567890201, 'Print Solutions Lanka', 2500.00, 1800.00, 'Active');
    
    -- Refresh itemIDs
    SET @Item1 = (SELECT itemID FROM itemTable WHERE modelID = 'BK001');
    SET @Item2 = (SELECT itemID FROM itemTable WHERE modelID = 'BK002');
    SET @Item3 = (SELECT itemID FROM itemTable WHERE modelID = 'BK003');
    SET @Item4 = (SELECT itemID FROM itemTable WHERE modelID = 'BK004');
    SET @Item5 = (SELECT itemID FROM itemTable WHERE modelID = 'ST001');
    SET @Item6 = (SELECT itemID FROM itemTable WHERE modelID = 'ST002');
    SET @Item7 = (SELECT itemID FROM itemTable WHERE modelID = 'PR001');
END

-- Insert Stock Buying Records
-- Check if totalAmount column exists
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('STOCKBUYING') AND name = 'totalAmount')
BEGIN
    -- If totalAmount column exists
    IF @Item1 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item1 AND purchaseDate = '2024-01-15')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item1, 50, 800.00, 1200.00, '2024-01-15', '1', 40000.00);
    
    IF @Item2 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item2 AND purchaseDate = '2024-01-15')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item2, 45, 1000.00, 1500.00, '2024-01-15', '1', 45000.00);
    
    IF @Item3 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item3 AND purchaseDate = '2024-01-20')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item3, 30, 2500.00, 3500.00, '2024-01-20', '4', 75000.00);
    
    IF @Item4 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item4 AND purchaseDate = '2024-01-20')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item4, 60, 1200.00, 1800.00, '2024-01-20', '1', 72000.00);
    
    IF @Item5 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item5 AND purchaseDate = '2024-02-10')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item5, 200, 150.00, 250.00, '2024-02-10', '2', 30000.00);
    
    IF @Item6 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item6 AND purchaseDate = '2024-02-10')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item6, 150, 100.00, 180.00, '2024-02-10', '2', 15000.00);
    
    IF @Item7 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item7 AND purchaseDate = '2024-02-25')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
        VALUES (@Item7, 80, 1800.00, 2500.00, '2024-02-25', '3', 144000.00);
END
ELSE
BEGIN
    -- If totalAmount column doesn't exist
    IF @Item1 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item1 AND purchaseDate = '2024-01-15')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item1, 50, 800.00, 1200.00, '2024-01-15', '1');
    
    IF @Item2 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item2 AND purchaseDate = '2024-01-15')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item2, 45, 1000.00, 1500.00, '2024-01-15', '1');
    
    IF @Item3 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item3 AND purchaseDate = '2024-01-20')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item3, 30, 2500.00, 3500.00, '2024-01-20', '4');
    
    IF @Item4 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item4 AND purchaseDate = '2024-01-20')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item4, 60, 1200.00, 1800.00, '2024-01-20', '1');
    
    IF @Item5 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item5 AND purchaseDate = '2024-02-10')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item5, 200, 150.00, 250.00, '2024-02-10', '2');
    
    IF @Item6 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item6 AND purchaseDate = '2024-02-10')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item6, 150, 100.00, 180.00, '2024-02-10', '2');
    
    IF @Item7 IS NOT NULL AND NOT EXISTS (SELECT * FROM STOCKBUYING WHERE itemID = @Item7 AND purchaseDate = '2024-02-25')
        INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
        VALUES (@Item7, 80, 1800.00, 2500.00, '2024-02-25', '3');
END
GO

-- =============================================
-- 2. AVAILABLE STOCKS DATA
-- =============================================

-- Update available stocks based on stock buying (trigger should handle this, but we'll ensure data exists)
-- This will sync availableSTOCKS with itemTable quantities
MERGE availableSTOCKS AS target
USING (
    SELECT 
        i.itemID,
        ISNULL(SUM(sb.boughtQTY), i.quantity) AS totalQTY
    FROM itemTable i
    LEFT JOIN STOCKBUYING sb ON i.itemID = sb.itemID
    GROUP BY i.itemID, i.quantity
) AS source
ON target.itemID = source.itemID
WHEN MATCHED THEN
    UPDATE SET 
        availableQTY = source.totalQTY,
        lastUpdatedDATE = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (itemID, availableQTY, lastUpdatedDATE)
    VALUES (source.itemID, source.totalQTY, GETDATE());
GO

-- =============================================
-- 3. SOLD STOCKS DATA
-- =============================================

-- Get itemIDs and sample invoice IDs
DECLARE @SoldItem1 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'BK001' ORDER BY itemID);
DECLARE @SoldItem2 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'BK002' ORDER BY itemID);
DECLARE @SoldItem3 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'ST001' ORDER BY itemID);
DECLARE @SoldItem4 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'ST002' ORDER BY itemID);
DECLARE @SoldItem5 INT = (SELECT TOP 1 itemID FROM itemTable WHERE modelID = 'PR001' ORDER BY itemID);

-- Get sample invoice IDs (if invoices exist)
DECLARE @Invoice1 INT = (SELECT TOP 1 invoiceID FROM invoiceTable ORDER BY invoiceID);
DECLARE @Invoice2 INT = (SELECT TOP 1 invoiceID FROM invoiceTable ORDER BY invoiceID DESC);

-- If no invoices exist, set to NULL
IF @Invoice1 IS NULL SET @Invoice1 = NULL;
IF @Invoice2 IS NULL SET @Invoice2 = NULL;

-- Insert Sold Stocks Records
IF @SoldItem1 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem1 AND soldDATE = '2024-02-05')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem1, 5, 0.00, 6000.00, '2024-02-05', @Invoice1);

IF @SoldItem2 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem2 AND soldDATE = '2024-02-05')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem2, 3, 5.00, 4275.00, '2024-02-05', @Invoice1);

IF @SoldItem3 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem3 AND soldDATE = '2024-02-10')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem3, 20, 0.00, 5000.00, '2024-02-10', @Invoice2);

IF @SoldItem4 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem4 AND soldDATE = '2024-02-12')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem4, 15, 10.00, 2430.00, '2024-02-12', @Invoice2);

IF @SoldItem5 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem5 AND soldDATE = '2024-02-15')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem5, 2, 0.00, 5000.00, '2024-02-15', @Invoice2);

-- Add more sold stock records
IF @SoldItem1 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem1 AND soldDATE = '2024-02-20')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem1, 8, 0.00, 9600.00, '2024-02-20', NULL);

IF @SoldItem3 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem3 AND soldDATE = '2024-02-25')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem3, 30, 5.00, 7125.00, '2024-02-25', NULL);

IF @SoldItem2 IS NOT NULL AND NOT EXISTS (SELECT * FROM soldSTOCKS WHERE itemID = @SoldItem2 AND soldDATE = '2024-03-01')
    INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
    VALUES (@SoldItem2, 4, 0.00, 6000.00, '2024-03-01', NULL);
GO

-- =============================================
-- 4. UPDATE AVAILABLE STOCKS AFTER SALES
-- =============================================

-- Recalculate available stocks (subtract sold quantities)
UPDATE availableSTOCKS
SET availableQTY = (
    SELECT 
        ISNULL(SUM(sb.boughtQTY), 0) - ISNULL(SUM(ss.soldQTY), 0)
    FROM itemTable i
    LEFT JOIN STOCKBUYING sb ON i.itemID = sb.itemID
    LEFT JOIN soldSTOCKS ss ON i.itemID = ss.itemID
    WHERE i.itemID = availableSTOCKS.itemID
    GROUP BY i.itemID
),
lastUpdatedDATE = GETDATE()
WHERE itemID IN (SELECT itemID FROM itemTable);
GO

-- =============================================
-- 5. UPDATE ITEMTABLE QUANTITIES
-- =============================================

-- Sync itemTable quantities with available stocks
UPDATE itemTable
SET quantity = (
    SELECT ISNULL(availableQTY, 0)
    FROM availableSTOCKS
    WHERE availableSTOCKS.itemID = itemTable.itemID
),
lastUpdated = GETDATE()
WHERE itemID IN (SELECT itemID FROM availableSTOCKS);
GO

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

PRINT '========================================';
PRINT 'Stock Data Inserted Successfully!';
PRINT '========================================';
PRINT '';

-- Show summary
SELECT 
    'STOCKBUYING' AS TableName,
    COUNT(*) AS RecordCount,
    SUM(boughtQTY) AS TotalQuantityBought,
    SUM(unitPrice * boughtQTY) AS TotalPurchaseValue
FROM STOCKBUYING;

SELECT 
    'availableSTOCKS' AS TableName,
    COUNT(*) AS RecordCount,
    SUM(availableQTY) AS TotalAvailableQuantity
FROM availableSTOCKS;

SELECT 
    'soldSTOCKS' AS TableName,
    COUNT(*) AS RecordCount,
    SUM(soldQTY) AS TotalQuantitySold,
    SUM(totalSold) AS TotalSalesValue
FROM soldSTOCKS;

PRINT '';
PRINT 'Sample Stock Data Insertion Complete!';
PRINT 'Check the tables to verify the data.';
GO

