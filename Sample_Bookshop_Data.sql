-- =============================================
-- Sample Bookshop Data for Ekanayake Printers RMS
-- Comprehensive sample data for all tables
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- Clear existing data (optional - comment out if you want to keep existing data)
-- DELETE FROM sessionEnd;
-- DELETE FROM sessionStart;
-- DELETE FROM returnTable;
-- DELETE FROM BillEstimateLineItems;
-- DELETE FROM BillESIMATE;
-- DELETE FROM invoiceLineItems;
-- DELETE FROM invoiceTable;
-- DELETE FROM soldSTOCKS;
-- DELETE FROM availableSTOCKS;
-- DELETE FROM STOCKBUYING;
-- DELETE FROM supplierSales;
-- DELETE FROM projectProgress;
-- DELETE FROM projectTable;
-- DELETE FROM schedule;
-- DELETE FROM salaryHistory;
-- DELETE FROM paysheetTable;
-- DELETE FROM financialTransactions;
-- DELETE FROM salesCount;
-- DELETE FROM salesReportCount;
-- DELETE FROM report;
-- DELETE FROM workerTable;
-- DELETE FROM stockManagerTable;
-- DELETE FROM siteEngineerTable;
-- DELETE FROM cashierTable;
-- DELETE FROM accountantTable;
-- DELETE FROM managerTable;
-- DELETE FROM employeeTable;
-- DELETE FROM userTable;
-- DELETE FROM customerTable;
-- DELETE FROM customer;
-- DELETE FROM supplier;
-- DELETE FROM SUPPLIERS;
-- DELETE FROM itemTable;
-- DELETE FROM ITEMS;
-- GO

-- =============================================
-- 1. SUPPLIERS DATA
-- =============================================

INSERT INTO supplier (supplierType, supplierName, supplierAddress, email, tel, company, contactPerson, status)
VALUES
('Book Distributor', 'Colombo Book Distributors', '123 Galle Road, Colombo 03', 'info@colombobooks.lk', 112345678, 'Colombo Books Ltd', 'Kamal Perera', 'Active'),
('Stationery Supplier', 'Office Supplies Co', '456 Kandy Road, Kandy', 'sales@officesupplies.lk', 812345678, 'Office Supplies Co', 'Nimal Silva', 'Active'),
('Printing Materials', 'Print Solutions Lanka', '789 Negombo Road, Negombo', 'contact@printsolutions.lk', 312345678, 'Print Solutions Lanka', 'Sunil Fernando', 'Active'),
('Educational Books', 'Education Publishers', '321 Peradeniya Road, Kandy', 'info@edupub.lk', 812345679, 'Education Publishers Ltd', 'Priya Jayawardena', 'Active'),
('Novels & Fiction', 'Fiction House', '654 Marine Drive, Galle', 'sales@fictionhouse.lk', 912345678, 'Fiction House Publishers', 'Ravi Mendis', 'Active');
GO

INSERT INTO SUPPLIERS (supName, email, tel, company, userAddress, supplierType, nic, product, status)
VALUES
('Colombo Book Distributors', 'info@colombobooks.lk', 112345678, 'Colombo Books Ltd', '123 Galle Road, Colombo 03', 'Book Distributor', '123456789V', 'Books', 'Active'),
('Office Supplies Co', 'sales@officesupplies.lk', 812345678, 'Office Supplies Co', '456 Kandy Road, Kandy', 'Stationery Supplier', '234567890V', 'Stationery', 'Active'),
('Print Solutions Lanka', 'contact@printsolutions.lk', 312345678, 'Print Solutions Lanka', '789 Negombo Road, Negombo', 'Printing Materials', '345678901V', 'Printing Supplies', 'Active');
GO

-- =============================================
-- 2. ITEMS DATA (Books, Stationery, Printing Supplies)
-- =============================================

INSERT INTO itemTable (modelID, brand, category, details, quantity, barcode, supplier, sellingPricePerUnit, boughtPrice, status)
VALUES
-- Books
('BK001', 'Penguin Classics', 'Fiction', 'Pride and Prejudice by Jane Austen', 50, 9780141439518, 'Colombo Book Distributors', 1200.00, 800.00, 'Active'),
('BK002', 'HarperCollins', 'Fiction', 'To Kill a Mockingbird by Harper Lee', 45, 9780061120084, 'Colombo Book Distributors', 1500.00, 1000.00, 'Active'),
('BK003', 'Oxford University Press', 'Education', 'Oxford English Dictionary', 30, 9780198611868, 'Education Publishers', 3500.00, 2500.00, 'Active'),
('BK004', 'Scholastic', 'Children', 'Harry Potter and the Philosophers Stone', 60, 9780439708180, 'Colombo Book Distributors', 1800.00, 1200.00, 'Active'),
('BK005', 'Cambridge University Press', 'Education', 'Cambridge Advanced Learners Dictionary', 25, 9781107619500, 'Education Publishers', 3200.00, 2200.00, 'Active'),
('BK006', 'Fiction House', 'Fiction', 'The Great Gatsby by F. Scott Fitzgerald', 40, 9780743273565, 'Fiction House', 1300.00, 900.00, 'Active'),
('BK007', 'Penguin', 'Non-Fiction', 'Sapiens by Yuval Noah Harari', 35, 9780062316097, 'Colombo Book Distributors', 2000.00, 1400.00, 'Active'),
('BK008', 'Scholastic', 'Children', 'The Chronicles of Narnia', 55, 9780007117307, 'Colombo Book Distributors', 1900.00, 1300.00, 'Active'),

-- Stationery
('ST001', 'Butterfly', 'Notebooks', 'A4 Ruled Notebook 200 pages', 200, 1234567890123, 'Office Supplies Co', 250.00, 150.00, 'Active'),
('ST002', 'Butterfly', 'Pens', 'Blue Ballpoint Pen Pack of 10', 150, 1234567890124, 'Office Supplies Co', 180.00, 100.00, 'Active'),
('ST003', 'Butterfly', 'Pencils', 'HB Pencil Pack of 12', 180, 1234567890125, 'Office Supplies Co', 120.00, 70.00, 'Active'),
('ST004', 'Butterfly', 'Erasers', 'White Eraser Pack of 5', 220, 1234567890126, 'Office Supplies Co', 80.00, 50.00, 'Active'),
('ST005', 'Butterfly', 'Rulers', '30cm Plastic Ruler', 100, 1234567890127, 'Office Supplies Co', 60.00, 35.00, 'Active'),

-- Printing Supplies
('PR001', 'Canon', 'Ink Cartridges', 'Canon PG-810 Black Ink Cartridge', 80, 1234567890201, 'Print Solutions Lanka', 2500.00, 1800.00, 'Active'),
('PR002', 'HP', 'Ink Cartridges', 'HP 301 Black Ink Cartridge', 75, 1234567890202, 'Print Solutions Lanka', 2800.00, 2000.00, 'Active'),
('PR003', 'Epson', 'Paper', 'A4 Printing Paper 500 sheets', 120, 1234567890203, 'Print Solutions Lanka', 850.00, 600.00, 'Active'),
('PR004', 'Canon', 'Toner', 'Canon 303 Toner Cartridge', 50, 1234567890204, 'Print Solutions Lanka', 4500.00, 3200.00, 'Active'),
('PR005', 'HP', 'Paper', 'A4 Photo Paper 100 sheets', 60, 1234567890205, 'Print Solutions Lanka', 1200.00, 850.00, 'Active');
GO

-- Sync to ITEMS table (disable trigger temporarily to avoid identity conflicts)
-- Note: ITEMS table may not have status and createdDate columns
IF OBJECT_ID('TR_itemTable_Sync_ITEMS', 'TR') IS NOT NULL
    ALTER TABLE itemTable DISABLE TRIGGER TR_itemTable_Sync_ITEMS;
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ITEMS') AND name = 'status')
BEGIN
    -- If ITEMS has status column
    SET IDENTITY_INSERT ITEMS ON;
    INSERT INTO ITEMS (itemID, modelNO, discription, brand, category, barcode, status)
    SELECT itemID, modelID, details, brand, category, barcode, status FROM itemTable;
    SET IDENTITY_INSERT ITEMS OFF;
END
ELSE
BEGIN
    -- If ITEMS doesn't have status column
    SET IDENTITY_INSERT ITEMS ON;
    INSERT INTO ITEMS (itemID, modelNO, discription, brand, category, barcode)
    SELECT itemID, modelID, details, brand, category, barcode FROM itemTable;
    SET IDENTITY_INSERT ITEMS OFF;
END
GO

-- Re-enable trigger
IF OBJECT_ID('TR_itemTable_Sync_ITEMS', 'TR') IS NOT NULL
    ALTER TABLE itemTable ENABLE TRIGGER TR_itemTable_Sync_ITEMS;
GO

-- =============================================
-- 3. STOCK PURCHASES (STOCKBUYING)
-- =============================================

-- STOCKBUYING (Get actual itemIDs and check if totalAmount column exists)
DECLARE @StockItem1 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK001');
DECLARE @StockItem2 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK002');
DECLARE @StockItem3 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK003');
DECLARE @StockItem4 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK004');
DECLARE @StockItem5 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK005');
DECLARE @StockItem6 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK006');
DECLARE @StockItem7 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK007');
DECLARE @StockItem8 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK008');
DECLARE @StockItem9 INT = (SELECT itemID FROM itemTable WHERE modelID = 'ST001');
DECLARE @StockItem10 INT = (SELECT itemID FROM itemTable WHERE modelID = 'ST002');
DECLARE @StockItem11 INT = (SELECT itemID FROM itemTable WHERE modelID = 'ST003');
DECLARE @StockItem12 INT = (SELECT itemID FROM itemTable WHERE modelID = 'ST004');
DECLARE @StockItem13 INT = (SELECT itemID FROM itemTable WHERE modelID = 'ST005');
DECLARE @StockItem14 INT = (SELECT itemID FROM itemTable WHERE modelID = 'PR001');
DECLARE @StockItem15 INT = (SELECT itemID FROM itemTable WHERE modelID = 'PR002');
DECLARE @StockItem16 INT = (SELECT itemID FROM itemTable WHERE modelID = 'PR003');
DECLARE @StockItem17 INT = (SELECT itemID FROM itemTable WHERE modelID = 'PR004');
DECLARE @StockItem18 INT = (SELECT itemID FROM itemTable WHERE modelID = 'PR005');

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('STOCKBUYING') AND name = 'totalAmount')
BEGIN
    INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID, totalAmount)
    VALUES
    (@StockItem1, 50, 800.00, 1200.00, '2024-01-15', 1, 40000.00),
    (@StockItem2, 45, 1000.00, 1500.00, '2024-01-15', 1, 45000.00),
    (@StockItem3, 30, 2500.00, 3500.00, '2024-01-20', 4, 75000.00),
    (@StockItem4, 60, 1200.00, 1800.00, '2024-01-20', 1, 72000.00),
    (@StockItem5, 25, 2200.00, 3200.00, '2024-01-25', 4, 55000.00),
    (@StockItem6, 40, 900.00, 1300.00, '2024-02-01', 5, 36000.00),
    (@StockItem7, 35, 1400.00, 2000.00, '2024-02-01', 1, 49000.00),
    (@StockItem8, 55, 1300.00, 1900.00, '2024-02-05', 1, 71500.00),
    (@StockItem9, 200, 150.00, 250.00, '2024-02-10', 2, 30000.00),
    (@StockItem10, 150, 100.00, 180.00, '2024-02-10', 2, 15000.00),
    (@StockItem11, 180, 70.00, 120.00, '2024-02-15', 2, 12600.00),
    (@StockItem12, 220, 50.00, 80.00, '2024-02-15', 2, 11000.00),
    (@StockItem13, 100, 35.00, 60.00, '2024-02-20', 2, 3500.00),
    (@StockItem14, 80, 1800.00, 2500.00, '2024-02-25', 3, 144000.00),
    (@StockItem15, 75, 2000.00, 2800.00, '2024-02-25', 3, 150000.00),
    (@StockItem16, 120, 600.00, 850.00, '2024-03-01', 3, 72000.00),
    (@StockItem17, 50, 3200.00, 4500.00, '2024-03-05', 3, 160000.00),
    (@StockItem18, 60, 850.00, 1200.00, '2024-03-05', 3, 51000.00);
END
ELSE
BEGIN
    INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
    VALUES
    (@StockItem1, 50, 800.00, 1200.00, '2024-01-15', 1),
    (@StockItem2, 45, 1000.00, 1500.00, '2024-01-15', 1),
    (@StockItem3, 30, 2500.00, 3500.00, '2024-01-20', 4),
    (@StockItem4, 60, 1200.00, 1800.00, '2024-01-20', 1),
    (@StockItem5, 25, 2200.00, 3200.00, '2024-01-25', 4),
    (@StockItem6, 40, 900.00, 1300.00, '2024-02-01', 5),
    (@StockItem7, 35, 1400.00, 2000.00, '2024-02-01', 1),
    (@StockItem8, 55, 1300.00, 1900.00, '2024-02-05', 1),
    (@StockItem9, 200, 150.00, 250.00, '2024-02-10', 2),
    (@StockItem10, 150, 100.00, 180.00, '2024-02-10', 2),
    (@StockItem11, 180, 70.00, 120.00, '2024-02-15', 2),
    (@StockItem12, 220, 50.00, 80.00, '2024-02-15', 2),
    (@StockItem13, 100, 35.00, 60.00, '2024-02-20', 2),
    (@StockItem14, 80, 1800.00, 2500.00, '2024-02-25', 3),
    (@StockItem15, 75, 2000.00, 2800.00, '2024-02-25', 3),
    (@StockItem16, 120, 600.00, 850.00, '2024-03-01', 3),
    (@StockItem17, 50, 3200.00, 4500.00, '2024-03-05', 3),
    (@StockItem18, 60, 850.00, 1200.00, '2024-03-05', 3);
END
GO

-- =============================================
-- 4. AVAILABLE STOCKS (Auto-updated by trigger, but adding initial data)
-- =============================================

INSERT INTO availableSTOCKS (itemID, availableQTY, lastUpdatedDATE)
SELECT itemID, quantity, GETDATE() FROM itemTable;
GO

-- =============================================
-- 5. CUSTOMERS DATA
-- =============================================

INSERT INTO customerTable (customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status)
VALUES
('Individual', 'Samantha', 'Perera', 'samantha.perera@email.com', 771234567, 'Colombo', '901234567V', '123 Main Street, Colombo 05', 'Colombo', '1990-05-15', '2024-01-10', 'Female', 'Active'),
('Individual', 'Dilshan', 'Fernando', 'dilshan.fernando@email.com', 772345678, 'Kandy', '902345678V', '456 Hill Street, Kandy', 'Kandy', '1988-08-22', '2024-01-12', 'Male', 'Active'),
('School', 'St. Marys College', NULL, 'admin@stmarys.lk', 812345678, 'Galle', '123456789X', '789 Church Road, Galle', 'Galle', NULL, '2024-01-15', NULL, 'Active'),
('Individual', 'Nadeesha', 'Wickramasinghe', 'nadeesha.w@email.com', 773456789, 'Negombo', '903456789V', '321 Beach Road, Negombo', 'Negombo', '1992-11-30', '2024-01-18', 'Female', 'Active'),
('Individual', 'Chaminda', 'Silva', 'chaminda.silva@email.com', 774567890, 'Colombo', '904567890V', '654 Park Avenue, Colombo 07', 'Colombo', '1985-03-10', '2024-01-20', 'Male', 'Active'),
('Business', 'ABC Trading Company', NULL, 'info@abctrading.lk', 112345678, 'Colombo', '987654321X', '789 Business Street, Colombo 02', 'Colombo', NULL, '2024-01-22', NULL, 'Active'),
('Individual', 'Kavindi', 'Jayawardena', 'kavindi.j@email.com', 775678901, 'Kandy', '905678901V', '147 Temple Street, Kandy', 'Kandy', '1995-07-25', '2024-01-25', 'Female', 'Active'),
('School', 'Royal College', NULL, 'admin@royalcollege.lk', 112345679, 'Colombo', '123456788X', '456 College Road, Colombo 07', 'Colombo', NULL, '2024-01-28', NULL, 'Active'),
('Individual', 'Ravindu', 'Mendis', 'ravindu.m@email.com', 776789012, 'Galle', '906789012V', '258 Fort Road, Galle', 'Galle', '1991-09-12', '2024-02-01', 'Male', 'Active'),
('Individual', 'Tharushi', 'Gunasekara', 'tharushi.g@email.com', 777890123, 'Negombo', '907890123V', '369 Sea View Road, Negombo', 'Negombo', '1993-12-05', '2024-02-05', 'Female', 'Active');
GO

-- Sync to customer table
INSERT INTO customer (customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status)
SELECT customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, regDate, gender, status FROM customerTable;
GO

-- =============================================
-- 6. USERS & EMPLOYEES DATA
-- =============================================

-- Users (Skip admin if it already exists)
IF NOT EXISTS (SELECT * FROM userTable WHERE username = 'admin')
BEGIN
    INSERT INTO userTable (fullName, username, userPassword, positionIndex, userType, email, tel, nic, userAddress, dob, status)
    VALUES
    ('Admin User', 'admin', 'admin123', 0, 'Administrator', 'admin@ekanayake.com', 771111111, '800000000V', '1 Admin Street, Colombo', '1980-01-01', 'Active');
END
GO

-- Other Users
INSERT INTO userTable (fullName, username, userPassword, positionIndex, userType, email, tel, nic, userAddress, dob, status)
VALUES
('Manager Perera', 'manager', 'manager123', 1, 'Manager', 'manager@ekanayake.com', 772222222, '800000001V', '2 Manager Road, Colombo', '1985-05-15', 'Active'),
('Accountant Silva', 'accountant', 'acc123', 2, 'Accountant', 'accountant@ekanayake.com', 773333333, '800000002V', '3 Accountant Lane, Colombo', '1988-08-20', 'Active'),
('Cashier Fernando', 'cashier', 'cash123', 3, 'Cashier', 'cashier@ekanayake.com', 774444444, '800000003V', '4 Cashier Street, Colombo', '1990-10-25', 'Active'),
('Engineer Wickramasinghe', 'engineer', 'eng123', 4, 'Site Engineer', 'engineer@ekanayake.com', 775555555, '800000004V', '5 Engineer Road, Kandy', '1987-03-12', 'Active'),
('Stock Manager Jayawardena', 'stockmgr', 'stock123', 5, 'Stock Manager', 'stock@ekanayake.com', 776666666, '800000005V', '6 Stock Avenue, Colombo', '1989-06-18', 'Active'),
('Worker Mendis', 'worker', 'work123', 6, 'Worker', 'worker@ekanayake.com', 777777777, '800000006V', '7 Worker Lane, Galle', '1992-09-30', 'Active');
GO

-- Employees (Get userIDs dynamically)
DECLARE @AdminUserID INT = (SELECT userID FROM userTable WHERE username = 'admin');
DECLARE @ManagerUserID INT = (SELECT userID FROM userTable WHERE username = 'manager');
DECLARE @AccountantUserID INT = (SELECT userID FROM userTable WHERE username = 'accountant');
DECLARE @CashierUserID INT = (SELECT userID FROM userTable WHERE username = 'cashier');
DECLARE @EngineerUserID INT = (SELECT userID FROM userTable WHERE username = 'engineer');
DECLARE @StockMgrUserID INT = (SELECT userID FROM userTable WHERE username = 'stockmgr');
DECLARE @WorkerUserID INT = (SELECT userID FROM userTable WHERE username = 'worker');

-- Only insert if user exists and employee doesn't exist
IF @AdminUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @AdminUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@AdminUserID, 'Administrator', 0, 'Administration', 'Active');

IF @ManagerUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @ManagerUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@ManagerUserID, 'Manager', 1, 'Management', 'Active');

IF @AccountantUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @AccountantUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@AccountantUserID, 'Accountant', 2, 'Finance', 'Active');

IF @CashierUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @CashierUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@CashierUserID, 'Cashier', 3, 'Sales', 'Active');

IF @EngineerUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @EngineerUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@EngineerUserID, 'Site Engineer', 4, 'Operations', 'Active');

IF @StockMgrUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @StockMgrUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@StockMgrUserID, 'Stock Manager', 5, 'Inventory', 'Active');

IF @WorkerUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM employeeTable WHERE userID = @WorkerUserID)
    INSERT INTO employeeTable (userID, employeeType, positionIndex, department, status)
    VALUES (@WorkerUserID, 'Worker', 6, 'Operations', 'Active');
GO

-- Role-specific tables (using dynamic userIDs)
DECLARE @ManagerUserID INT = (SELECT userID FROM userTable WHERE username = 'manager');
DECLARE @AccountantUserID INT = (SELECT userID FROM userTable WHERE username = 'accountant');
DECLARE @CashierUserID INT = (SELECT userID FROM userTable WHERE username = 'cashier');
DECLARE @EngineerUserID INT = (SELECT userID FROM userTable WHERE username = 'engineer');
DECLARE @StockMgrUserID INT = (SELECT userID FROM userTable WHERE username = 'stockmgr');
DECLARE @WorkerUserID INT = (SELECT userID FROM userTable WHERE username = 'worker');

IF @ManagerUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM managerTable WHERE userID = @ManagerUserID)
    INSERT INTO managerTable (userID, positionIndex, department) VALUES (@ManagerUserID, 1, 'Management');

IF @AccountantUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM accountantTable WHERE userID = @AccountantUserID)
    INSERT INTO accountantTable (userID, positionIndex) VALUES (@AccountantUserID, 2);

IF @CashierUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM cashierTable WHERE userID = @CashierUserID)
    INSERT INTO cashierTable (userID, positionIndex) VALUES (@CashierUserID, 3);

IF @EngineerUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM siteEngineerTable WHERE userID = @EngineerUserID)
    INSERT INTO siteEngineerTable (userID, positionIndex) VALUES (@EngineerUserID, 4);

IF @StockMgrUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM stockManagerTable WHERE userID = @StockMgrUserID)
    INSERT INTO stockManagerTable (userID, positionIndex) VALUES (@StockMgrUserID, 5);

IF @WorkerUserID IS NOT NULL AND NOT EXISTS (SELECT * FROM workerTable WHERE userID = @WorkerUserID)
    INSERT INTO workerTable (userID, positionIndex) VALUES (@WorkerUserID, 6);
GO

-- =============================================
-- 7. INVOICES & SALES DATA
-- =============================================

-- Invoices
INSERT INTO invoiceTable (invoiceNumber, customerID, customerName, customerType, invoiceDate, totalBillAmount, discountAmount, taxAmount, finalAmount, paymentStatus, paymentMethod, createdBy, notes)
VALUES
('INV-2024-001', 1, 'Samantha Perera', 'Individual', '2024-02-10 10:30:00', 2400.00, 0.00, 432.00, 2832.00, 'Paid', 'Cash', 4, 'Customer purchase - Books'),
('INV-2024-002', 2, 'Dilshan Fernando', 'Individual', '2024-02-12 14:15:00', 3000.00, 150.00, 513.00, 3363.00, 'Paid', 'Card', 4, 'Multiple items purchase'),
('INV-2024-003', 3, 'St. Marys College', 'School', '2024-02-15 09:00:00', 15000.00, 1500.00, 2430.00, 15930.00, 'Paid', 'Cheque', 4, 'Bulk order for school library'),
('INV-2024-004', 4, 'Nadeesha Wickramasinghe', 'Individual', '2024-02-18 11:20:00', 1800.00, 0.00, 324.00, 2124.00, 'Paid', 'Cash', 4, NULL),
('INV-2024-005', 5, 'Chaminda Silva', 'Individual', '2024-02-20 15:45:00', 2500.00, 125.00, 427.50, 2802.50, 'Pending', 'Card', 4, 'Pending payment'),
('INV-2024-006', 6, 'ABC Trading Company', 'Business', '2024-02-22 10:00:00', 12000.00, 1200.00, 1944.00, 12744.00, 'Paid', 'Bank Transfer', 4, 'Corporate order'),
('INV-2024-007', 7, 'Kavindi Jayawardena', 'Individual', '2024-02-25 13:30:00', 1900.00, 0.00, 342.00, 2242.00, 'Paid', 'Cash', 4, NULL),
('INV-2024-008', 8, 'Royal College', 'School', '2024-02-28 08:00:00', 20000.00, 2000.00, 3240.00, 21240.00, 'Paid', 'Cheque', 4, 'School library books'),
('INV-2024-009', 9, 'Ravindu Mendis', 'Individual', '2024-03-01 16:00:00', 1300.00, 0.00, 234.00, 1534.00, 'Paid', 'Card', 4, NULL),
('INV-2024-010', 10, 'Tharushi Gunasekara', 'Individual', '2024-03-05 12:15:00', 3600.00, 180.00, 615.60, 4035.60, 'Paid', 'Cash', 4, 'Multiple books purchase');
GO

-- Invoice Line Items (Get actual itemIDs from itemTable)
DECLARE @Item1 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK001');
DECLARE @Item2 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK002');
DECLARE @Item3 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK003');
DECLARE @Item4 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK004');
DECLARE @Item5 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK005');
DECLARE @Item6 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK006');
DECLARE @Item7 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK007');

INSERT INTO invoiceLineItems (invoiceID, itemID, itemName, quantity, unitPrice, discount, lineTotal, itemDetails)
VALUES
-- Invoice 1
(1, @Item1, 'Pride and Prejudice', 2, 1200.00, 0.00, 2400.00, 'Penguin Classics Edition'),
-- Invoice 2
(2, @Item2, 'To Kill a Mockingbird', 2, 1500.00, 150.00, 2850.00, 'HarperCollins Edition'),
-- Invoice 3 (School bulk order)
(3, @Item3, 'Oxford English Dictionary', 3, 3500.00, 1050.00, 9450.00, 'Oxford University Press'),
(3, @Item4, 'Harry Potter and the Philosophers Stone', 3, 1800.00, 450.00, 4950.00, 'Scholastic Edition'),
-- Invoice 4
(4, @Item4, 'Harry Potter and the Philosophers Stone', 1, 1800.00, 0.00, 1800.00, 'Scholastic Edition'),
-- Invoice 5
(5, @Item5, 'Cambridge Advanced Learners Dictionary', 1, 3200.00, 125.00, 3075.00, 'Cambridge University Press'),
-- Invoice 6 (Corporate)
(6, @Item7, 'Sapiens', 6, 2000.00, 1200.00, 10800.00, 'Non-Fiction Best Seller'),
-- Invoice 7
(7, @Item6, 'The Great Gatsby', 1, 1300.00, 0.00, 1300.00, 'Fiction House Edition'),
-- Invoice 8 (School bulk)
(8, @Item3, 'Oxford English Dictionary', 4, 3500.00, 1400.00, 12600.00, 'Oxford University Press'),
(8, @Item5, 'Cambridge Advanced Learners Dictionary', 2, 3200.00, 600.00, 5800.00, 'Cambridge University Press'),
-- Invoice 9
(9, @Item6, 'The Great Gatsby', 1, 1300.00, 0.00, 1300.00, 'Fiction House Edition'),
-- Invoice 10
(10, @Item1, 'Pride and Prejudice', 1, 1200.00, 0.00, 1200.00, 'Penguin Classics'),
(10, @Item2, 'To Kill a Mockingbird', 1, 1500.00, 0.00, 1500.00, 'HarperCollins'),
(10, @Item7, 'Sapiens', 1, 2000.00, 180.00, 1820.00, 'Non-Fiction');
GO

-- Sold Stocks (Auto-created by trigger, but adding sample)
INSERT INTO soldSTOCKS (itemID, soldQTY, discountRate, totalSold, soldDATE, invoiceID)
SELECT ili.itemID, ili.quantity, ili.discount, ili.lineTotal, i.invoiceDate, i.invoiceID
FROM invoiceLineItems ili
INNER JOIN invoiceTable i ON ili.invoiceID = i.invoiceID;
GO

-- =============================================
-- 8. BILL ESTIMATES
-- =============================================

INSERT INTO BillESIMATE (estimateNumber, customerID, customerName, estimateDate, totalAmount, validUntil, status, notes, createdBy)
VALUES
('EST-2024-001', 1, 'Samantha Perera', '2024-03-10', 5000.00, '2024-04-10', 'Pending', 'Book collection estimate', 4),
('EST-2024-002', 3, 'St. Marys College', '2024-03-12', 25000.00, '2024-04-12', 'Approved', 'School library expansion', 4),
('EST-2024-003', 6, 'ABC Trading Company', '2024-03-15', 15000.00, '2024-04-15', 'Pending', 'Corporate bulk order', 4);
GO

-- Bill Estimate Line Items (Get actual itemIDs)
DECLARE @EstItem1 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK001');
DECLARE @EstItem2 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK002');
DECLARE @EstItem3 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK003');
DECLARE @EstItem5 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK005');
DECLARE @EstItem7 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK007');
DECLARE @EstItem8 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK008');

INSERT INTO BillEstimateLineItems (estimateID, itemID, itemName, quantity, unitPrice, lineTotal, description)
VALUES
(1, @EstItem1, 'Pride and Prejudice', 3, 1200.00, 3600.00, 'Penguin Classics'),
(1, @EstItem2, 'To Kill a Mockingbird', 1, 1500.00, 1500.00, 'HarperCollins'),
(2, @EstItem3, 'Oxford English Dictionary', 5, 3500.00, 17500.00, 'Oxford University Press'),
(2, @EstItem5, 'Cambridge Advanced Learners Dictionary', 2, 3200.00, 6400.00, 'Cambridge University Press'),
(3, @EstItem7, 'Sapiens', 5, 2000.00, 10000.00, 'Non-Fiction'),
(3, @EstItem8, 'The Chronicles of Narnia', 2, 1900.00, 3800.00, 'Scholastic');
GO

-- =============================================
-- 9. PROJECTS DATA
-- =============================================

-- Projects (Get actual employeeID for engineer)
DECLARE @ProjEngEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'engineer');

IF @ProjEngEmpID IS NOT NULL
BEGIN
    INSERT INTO projectTable (projectName, projectType, projectLocation, customerID, customerName, createDate, startDate, endDate, workingProcedure, projectStatus, assignedEngineerID, budget, actualCost, progressPercentage)
    VALUES
    ('School Library Setup', 'Installation', 'St. Marys College, Galle', 3, 'St. Marys College', '2024-02-20', '2024-03-01', '2024-03-15', '1. Site survey 2. Bookshelf installation 3. Book arrangement 4. Final inspection', 'Active', @ProjEngEmpID, 50000.00, 25000.00, 50),
    ('Corporate Book Display', 'Setup', 'ABC Trading Company, Colombo', 6, 'ABC Trading Company', '2024-03-05', '2024-03-10', '2024-03-20', '1. Design display 2. Install shelves 3. Arrange books 4. Lighting setup', 'Active', @ProjEngEmpID, 30000.00, 15000.00, 50),
    ('Royal College Library Renovation', 'Renovation', 'Royal College, Colombo', 8, 'Royal College', '2024-03-01', '2024-03-15', '2024-04-30', '1. Remove old books 2. Paint and repair 3. Install new shelves 4. Arrange books 5. Final touch-up', 'Scheduled', @ProjEngEmpID, 75000.00, 0.00, 0);
END
GO

-- Sync to projects table (Check if columns exist)
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('projects') AND name = 'projectLocation')
BEGIN
    INSERT INTO projects (projectName, projectType, projectLocation, customerID, customerName, createDate, startDate, endDate, workingProcedure, projectStatus, assignedEngineerID, budget, actualCost, progressPercentage)
    SELECT projectName, projectType, projectLocation, customerID, customerName, createDate, startDate, endDate, workingProcedure, projectStatus, assignedEngineerID, budget, actualCost, progressPercentage FROM projectTable;
END
ELSE
BEGIN
    -- If projects table has different structure, insert only matching columns
    INSERT INTO projects (projectName, projectType, customerID, customerName, createDate)
    SELECT projectName, projectType, customerID, customerName, createDate FROM projectTable;
END
GO

-- Project Progress (Get actual projectIDs)
DECLARE @Proj1ID INT = (SELECT TOP 1 projectID FROM projectTable WHERE projectName = 'School Library Setup');
DECLARE @Proj2ID INT = (SELECT TOP 1 projectID FROM projectTable WHERE projectName = 'Corporate Book Display');
DECLARE @ProjEngUserID INT = (SELECT TOP 1 userID FROM userTable WHERE username = 'engineer');

IF @Proj1ID IS NOT NULL AND @ProjEngUserID IS NOT NULL
BEGIN
    INSERT INTO projectProgress (projectID, progressDate, progressPercentage, description, updatedBy, notes)
    VALUES
    (@Proj1ID, '2024-03-05', 30, 'Site survey completed, bookshelves ordered', @ProjEngUserID, 'All measurements taken'),
    (@Proj1ID, '2024-03-10', 50, 'Bookshelves installed, starting book arrangement', @ProjEngUserID, 'Installation successful');
END

IF @Proj2ID IS NOT NULL AND @ProjEngUserID IS NOT NULL
BEGIN
    INSERT INTO projectProgress (projectID, progressDate, progressPercentage, description, updatedBy, notes)
    VALUES
    (@Proj2ID, '2024-03-12', 50, 'Display design approved, shelves installed', @ProjEngUserID, 'Customer satisfied with design');
END
GO

-- =============================================
-- 10. SCHEDULES
-- =============================================

-- Schedules (Get actual employeeIDs)
DECLARE @EngineerEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'engineer');
DECLARE @WorkerEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'worker');

IF @EngineerEmpID IS NOT NULL
BEGIN
    INSERT INTO schedule (employeeID, employeeName, scheduleDate, scheduleTime, scheduleLocation, scheduleType, description, status, createdBy)
    VALUES
    (@EngineerEmpID, 'Engineer Wickramasinghe', '2024-03-15', '09:00:00', 'St. Marys College, Galle', 'Site Visit', 'Final inspection of library setup', 'Scheduled', 2),
    (@EngineerEmpID, 'Engineer Wickramasinghe', '2024-03-18', '10:00:00', 'ABC Trading Company, Colombo', 'Installation', 'Complete book display setup', 'Scheduled', 2),
    (@EngineerEmpID, 'Engineer Wickramasinghe', '2024-03-22', '14:00:00', 'Royal College, Colombo', 'Supervision', 'Supervise renovation progress', 'Scheduled', 2);
END

IF @WorkerEmpID IS NOT NULL
BEGIN
    INSERT INTO schedule (employeeID, employeeName, scheduleDate, scheduleTime, scheduleLocation, scheduleType, description, status, createdBy)
    VALUES
    (@WorkerEmpID, 'Worker Mendis', '2024-03-20', '08:00:00', 'Royal College, Colombo', 'Work', 'Start library renovation work', 'Scheduled', 2);
END
GO

-- =============================================
-- 11. PAYSHEETS
-- =============================================

-- Paysheets (Get actual employeeIDs)
DECLARE @MgrEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'manager');
DECLARE @AccEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'accountant');
DECLARE @CashEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'cashier');
DECLARE @EngEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'engineer');
DECLARE @StockEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'stockmgr');
DECLARE @WorkEmpID INT = (SELECT TOP 1 e.employeeID FROM employeeTable e INNER JOIN userTable u ON e.userID = u.userID WHERE u.username = 'worker');

IF @MgrEmpID IS NOT NULL
    INSERT INTO paysheetTable (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus)
    VALUES (@MgrEmpID, 'Manager Perera', 'Manager', 'February', 2024, 75000.00, 5000.00, 22, 8, 312.50, 2500.00, 1500.00, 6000.00, 0.00, 75000.00, '2024-03-01', 'Paid');

IF @AccEmpID IS NOT NULL
    INSERT INTO paysheetTable (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus)
    VALUES (@AccEmpID, 'Accountant Silva', 'Accountant', 'February', 2024, 60000.00, 3000.00, 22, 4, 250.00, 1000.00, 1200.00, 4800.00, 0.00, 59200.00, '2024-03-01', 'Paid');

IF @CashEmpID IS NOT NULL
    INSERT INTO paysheetTable (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus)
    VALUES (@CashEmpID, 'Cashier Fernando', 'Cashier', 'February', 2024, 45000.00, 2000.00, 22, 6, 187.50, 1125.00, 900.00, 3600.00, 0.00, 44525.00, '2024-03-01', 'Paid');

IF @EngEmpID IS NOT NULL
    INSERT INTO paysheetTable (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus)
    VALUES (@EngEmpID, 'Engineer Wickramasinghe', 'Site Engineer', 'February', 2024, 55000.00, 4000.00, 22, 12, 229.17, 2750.00, 1100.00, 4400.00, 0.00, 57250.00, '2024-03-01', 'Paid');

IF @StockEmpID IS NOT NULL
    INSERT INTO paysheetTable (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus)
    VALUES (@StockEmpID, 'Stock Manager Jayawardena', 'Stock Manager', 'February', 2024, 50000.00, 2500.00, 22, 6, 208.33, 1250.00, 1000.00, 4000.00, 0.00, 51750.00, '2024-03-01', 'Paid');

IF @WorkEmpID IS NOT NULL
    INSERT INTO paysheetTable (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus)
    VALUES (@WorkEmpID, 'Worker Mendis', 'Worker', 'February', 2024, 35000.00, 1500.00, 22, 10, 145.83, 1458.30, 700.00, 2800.00, 0.00, 35458.30, '2024-03-01', 'Paid');
GO

INSERT INTO salaryHistory (employeeID, paysheetID, salaryAmount, payMonth, payYear, paymentDate, notes)
SELECT employeeID, paysheetID, totalSalary, payMonth, payYear, paymentDate, 'Monthly salary payment' FROM paysheetTable;
GO

-- =============================================
-- 12. FINANCIAL TRANSACTIONS
-- =============================================

-- Financial Transactions (Get actual userIDs)
DECLARE @FinCashierID INT = (SELECT userID FROM userTable WHERE username = 'cashier');
DECLARE @FinAccountantID INT = (SELECT userID FROM userTable WHERE username = 'accountant');

IF @FinCashierID IS NOT NULL
BEGIN
    INSERT INTO financialTransactions (transactionDate, transactionType, amount, description, category, referenceID, referenceType, createdBy, status)
    VALUES
    -- Income from invoices
    ('2024-02-10', 'Income', 2832.00, 'Invoice INV-2024-001 payment', 'Sales', 1, 'Invoice', @FinCashierID, 'Active'),
    ('2024-02-12', 'Income', 3363.00, 'Invoice INV-2024-002 payment', 'Sales', 2, 'Invoice', @FinCashierID, 'Active'),
    ('2024-02-15', 'Income', 15930.00, 'Invoice INV-2024-003 payment', 'Sales', 3, 'Invoice', @FinCashierID, 'Active'),
    ('2024-02-18', 'Income', 2124.00, 'Invoice INV-2024-004 payment', 'Sales', 4, 'Invoice', @FinCashierID, 'Active'),
    ('2024-02-22', 'Income', 12744.00, 'Invoice INV-2024-006 payment', 'Sales', 6, 'Invoice', @FinCashierID, 'Active'),
    ('2024-02-25', 'Income', 2242.00, 'Invoice INV-2024-007 payment', 'Sales', 7, 'Invoice', @FinCashierID, 'Active'),
    ('2024-02-28', 'Income', 21240.00, 'Invoice INV-2024-008 payment', 'Sales', 8, 'Invoice', @FinCashierID, 'Active'),
    ('2024-03-01', 'Income', 1534.00, 'Invoice INV-2024-009 payment', 'Sales', 9, 'Invoice', @FinCashierID, 'Active'),
    ('2024-03-05', 'Income', 4035.60, 'Invoice INV-2024-010 payment', 'Sales', 10, 'Invoice', @FinCashierID, 'Active');
END

-- Expenses - Salary payments (Get paysheetIDs dynamically)
IF @FinAccountantID IS NOT NULL
BEGIN
    DECLARE @Pay1 INT = (SELECT TOP 1 paysheetID FROM paysheetTable ORDER BY paysheetID);
    DECLARE @Pay2 INT = (SELECT TOP 1 paysheetID FROM paysheetTable ORDER BY paysheetID OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY);
    DECLARE @Pay3 INT = (SELECT TOP 1 paysheetID FROM paysheetTable ORDER BY paysheetID OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY);
    DECLARE @Pay4 INT = (SELECT TOP 1 paysheetID FROM paysheetTable ORDER BY paysheetID OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY);
    DECLARE @Pay5 INT = (SELECT TOP 1 paysheetID FROM paysheetTable ORDER BY paysheetID OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY);
    DECLARE @Pay6 INT = (SELECT TOP 1 paysheetID FROM paysheetTable ORDER BY paysheetID OFFSET 5 ROWS FETCH NEXT 1 ROWS ONLY);
    
    IF @Pay1 IS NOT NULL AND @Pay2 IS NOT NULL AND @Pay3 IS NOT NULL AND @Pay4 IS NOT NULL AND @Pay5 IS NOT NULL AND @Pay6 IS NOT NULL
    BEGIN
        INSERT INTO financialTransactions (transactionDate, transactionType, amount, description, category, referenceID, referenceType, createdBy, status)
        VALUES
        ('2024-03-01', 'Expense', 75000.00, 'Manager Perera salary', 'Payroll', @Pay1, 'Paysheet', @FinAccountantID, 'Active'),
        ('2024-03-01', 'Expense', 59200.00, 'Accountant Silva salary', 'Payroll', @Pay2, 'Paysheet', @FinAccountantID, 'Active'),
        ('2024-03-01', 'Expense', 44525.00, 'Cashier Fernando salary', 'Payroll', @Pay3, 'Paysheet', @FinAccountantID, 'Active'),
        ('2024-03-01', 'Expense', 57250.00, 'Engineer Wickramasinghe salary', 'Payroll', @Pay4, 'Paysheet', @FinAccountantID, 'Active'),
        ('2024-03-01', 'Expense', 51750.00, 'Stock Manager Jayawardena salary', 'Payroll', @Pay5, 'Paysheet', @FinAccountantID, 'Active'),
        ('2024-03-01', 'Expense', 35458.30, 'Worker Mendis salary', 'Payroll', @Pay6, 'Paysheet', @FinAccountantID, 'Active');
    END
END
GO

-- =============================================
-- 13. SUPPLIER SALES
-- =============================================

-- Supplier Sales (Get actual itemIDs)
DECLARE @SupItem1 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK001');
DECLARE @SupItem2 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK002');
DECLARE @SupItem3 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK003');
DECLARE @SupItem4 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK004');
DECLARE @SupItem9 INT = (SELECT itemID FROM itemTable WHERE modelID = 'ST001');
DECLARE @SupItem14 INT = (SELECT itemID FROM itemTable WHERE modelID = 'PR001');

IF @SupItem1 IS NOT NULL AND @SupItem2 IS NOT NULL AND @SupItem3 IS NOT NULL AND @SupItem4 IS NOT NULL AND @SupItem9 IS NOT NULL AND @SupItem14 IS NOT NULL
BEGIN
    INSERT INTO supplierSales (supplierID, SupplierNIC, itemID, SalesQTY, salesDate, unitPrice, totalAmount)
    VALUES
    (1, '123456789V', @SupItem1, 50, '2024-01-15', 800.00, 40000.00),
    (1, '123456789V', @SupItem2, 45, '2024-01-15', 1000.00, 45000.00),
    (4, '345678901V', @SupItem3, 30, '2024-01-20', 2500.00, 75000.00),
    (1, '123456789V', @SupItem4, 60, '2024-01-20', 1200.00, 72000.00),
    (2, '234567890V', @SupItem9, 200, '2024-02-10', 150.00, 30000.00),
    (3, '345678901V', @SupItem14, 80, '2024-02-25', 1800.00, 144000.00);
END
GO

-- =============================================
-- 14. SALES REPORTS
-- =============================================

INSERT INTO salesCount (itemID, modelID, brand, category, supplier, qty, stockUpdateDate, qtyAvailable, qtySold)
SELECT 
    i.itemID,
    i.modelID,
    i.brand,
    i.category,
    i.supplier,
    i.quantity,
    GETDATE(),
    ISNULL(av.availableQTY, 0),
    ISNULL(SUM(ss.soldQTY), 0)
FROM itemTable i
LEFT JOIN availableSTOCKS av ON i.itemID = av.itemID
LEFT JOIN soldSTOCKS ss ON i.itemID = ss.itemID
GROUP BY i.itemID, i.modelID, i.brand, i.category, i.supplier, i.quantity, av.availableQTY;
GO

-- Sales Report Count (Get actual itemIDs)
DECLARE @RepItem1 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK001');
DECLARE @RepItem2 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK002');
DECLARE @RepItem3 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK003');
DECLARE @RepItem4 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK004');
DECLARE @RepItem7 INT = (SELECT itemID FROM itemTable WHERE modelID = 'BK007');

IF @RepItem1 IS NOT NULL AND @RepItem2 IS NOT NULL AND @RepItem3 IS NOT NULL AND @RepItem4 IS NOT NULL AND @RepItem7 IS NOT NULL
BEGIN
    INSERT INTO salesReportCount (itemID, salesMonth, salesYear, saleType, itemSold, serviceCharge, materialCost, equipmentCost, totalSalary, transportCost, totalSales, serviceIncome, totalCost, profit, reportDate)
    VALUES
    (@RepItem1, 'February', 2024, 'Retail', 3, 0.00, 2400.00, 0.00, 0.00, 0.00, 3600.00, 0.00, 2400.00, 1200.00, '2024-03-01'),
    (@RepItem2, 'February', 2024, 'Retail', 2, 0.00, 2000.00, 0.00, 0.00, 0.00, 2850.00, 0.00, 2000.00, 850.00, '2024-03-01'),
    (@RepItem3, 'February', 2024, 'Bulk', 7, 0.00, 17500.00, 0.00, 0.00, 0.00, 22050.00, 0.00, 17500.00, 4550.00, '2024-03-01'),
    (@RepItem4, 'February', 2024, 'Retail', 4, 0.00, 4800.00, 0.00, 0.00, 0.00, 6750.00, 0.00, 4800.00, 1950.00, '2024-03-01'),
    (@RepItem7, 'February', 2024, 'Bulk', 7, 0.00, 9800.00, 0.00, 0.00, 0.00, 12620.00, 0.00, 9800.00, 2820.00, '2024-03-01');
END
GO

-- =============================================
-- 15. SESSION DATA
-- =============================================

-- Session Data (Get actual userIDs)
DECLARE @SessAdminID INT = (SELECT userID FROM userTable WHERE username = 'admin');
DECLARE @SessManagerID INT = (SELECT userID FROM userTable WHERE username = 'manager');
DECLARE @SessAccountantID INT = (SELECT userID FROM userTable WHERE username = 'accountant');
DECLARE @SessCashierID INT = (SELECT userID FROM userTable WHERE username = 'cashier');

IF @SessAdminID IS NOT NULL
    INSERT INTO sessionStart (userID, sessionStartTime, ipAddress, machineName)
    VALUES (@SessAdminID, '2024-03-10 08:00:00', '192.168.1.100', 'ADMIN-PC');

IF @SessManagerID IS NOT NULL
    INSERT INTO sessionStart (userID, sessionStartTime, ipAddress, machineName)
    VALUES (@SessManagerID, '2024-03-10 08:15:00', '192.168.1.101', 'MANAGER-PC');

IF @SessCashierID IS NOT NULL
    INSERT INTO sessionStart (userID, sessionStartTime, ipAddress, machineName)
    VALUES (@SessCashierID, '2024-03-10 08:30:00', '192.168.1.103', 'CASHIER-PC');

IF @SessAccountantID IS NOT NULL
    INSERT INTO sessionStart (userID, sessionStartTime, ipAddress, machineName)
    VALUES (@SessAccountantID, '2024-03-10 09:00:00', '192.168.1.102', 'ACCOUNTANT-PC');
GO

-- =============================================
-- 16. REPORTS
-- =============================================

-- Reports (Get actual userIDs)
DECLARE @RepAccountantID INT = (SELECT userID FROM userTable WHERE username = 'accountant');
DECLARE @RepStockMgrID INT = (SELECT userID FROM userTable WHERE username = 'stockmgr');

IF @RepAccountantID IS NOT NULL
BEGIN
    INSERT INTO report (reportType, reportName, generatedDate, generatedBy, reportData, filePath)
    VALUES
    ('Sales Report', 'February 2024 Sales Summary', '2024-03-01 10:00:00', @RepAccountantID, 'Monthly sales report for February 2024', 'C:\Reports\Sales_Feb2024.pdf'),
    ('Financial Report', 'Monthly Financial Summary', '2024-03-01 16:00:00', @RepAccountantID, 'Income and expense summary for February', 'C:\Reports\Financial_Feb2024.pdf');
END

IF @RepStockMgrID IS NOT NULL
BEGIN
    INSERT INTO report (reportType, reportName, generatedDate, generatedBy, reportData, filePath)
    VALUES
    ('Inventory Report', 'Stock Status Report', '2024-03-05 14:00:00', @RepStockMgrID, 'Current stock levels and availability', 'C:\Reports\Stock_Mar2024.pdf');
END
GO

-- =============================================
-- COMPLETION MESSAGE
-- =============================================

PRINT '';
PRINT '=============================================';
PRINT 'Sample Bookshop Data Inserted Successfully!';
PRINT '=============================================';
PRINT '';
PRINT 'Data Summary:';
PRINT '  - Suppliers: 5';
PRINT '  - Items (Books/Stationery/Printing): 18';
PRINT '  - Stock Purchases: 18';
PRINT '  - Customers: 10';
PRINT '  - Users/Employees: 7';
PRINT '  - Invoices: 10';
PRINT '  - Invoice Line Items: 15';
PRINT '  - Bill Estimates: 3';
PRINT '  - Projects: 3';
PRINT '  - Schedules: 4';
PRINT '  - Paysheets: 6';
PRINT '  - Financial Transactions: 15';
PRINT '  - Sales Reports: 5';
PRINT '  - Sessions: 4';
PRINT '';
PRINT 'All tables have been populated with sample bookshop data!';
PRINT '=============================================';
GO

