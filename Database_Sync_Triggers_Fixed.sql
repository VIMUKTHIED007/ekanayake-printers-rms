-- =============================================
-- Database Synchronization Triggers - FIXED
-- Ensures data consistency across related tables
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- Drop existing triggers if they exist
IF OBJECT_ID('TR_invoiceTable_Update_SalesCount', 'TR') IS NOT NULL
    DROP TRIGGER TR_invoiceTable_Update_SalesCount;
GO

IF OBJECT_ID('TR_JD_PAYSHEET_Update_paysheetTable', 'TR') IS NOT NULL
    DROP TRIGGER TR_JD_PAYSHEET_Update_paysheetTable;
GO

IF OBJECT_ID('TR_paysheetTable_Update_FinancialTransactions', 'TR') IS NOT NULL
    DROP TRIGGER TR_paysheetTable_Update_FinancialTransactions;
GO

-- =============================================
-- 1. INVOICE & SALES SYNCHRONIZATION (FIXED)
-- =============================================

-- Trigger: When invoice is created, update salesReportCount
IF OBJECT_ID('TR_invoiceTable_Update_SalesReportCount', 'TR') IS NOT NULL
    DROP TRIGGER TR_invoiceTable_Update_SalesReportCount;
GO

CREATE TRIGGER TR_invoiceTable_Update_SalesReportCount
ON invoiceTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Update salesReportCount based on invoice line items
        INSERT INTO salesReportCount (itemID, modelID, brand, category, supplier, qty, stockUpdateDate, qtyAvailable, qtySold)
        SELECT 
            ili.itemID,
            i.modelID,
            i.brand,
            i.category,
            i.supplier,
            ili.quantity AS qty,
            GETDATE() AS stockUpdateDate,
            ISNULL(av.availableQTY, 0) AS qtyAvailable,
            ili.quantity AS qtySold
        FROM inserted inv
        INNER JOIN invoiceLineItems ili ON inv.invoiceID = ili.invoiceID
        INNER JOIN itemTable i ON ili.itemID = i.itemID
        LEFT JOIN availableSTOCKS av ON i.itemID = av.itemID
        WHERE NOT EXISTS (
            SELECT 1 FROM salesReportCount src 
            WHERE src.itemID = ili.itemID 
            AND CAST(src.stockUpdateDate AS DATE) = CAST(GETDATE() AS DATE)
        );
    END
END;
GO

-- =============================================
-- 2. PAYSHEET SYNCHRONIZATION (FIXED)
-- =============================================

-- Trigger: When JD_EMPLOYEE_PAYSHEET is updated, sync to paysheetTable
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
                empID AS employeeID,
                empName AS employeeName,
                CASE userType
                    WHEN 0 THEN 'Administrator'
                    WHEN 1 THEN 'Manager'
                    WHEN 2 THEN 'Accountant'
                    WHEN 3 THEN 'Cashier'
                    WHEN 4 THEN 'Site Engineer'
                    WHEN 5 THEN 'Stock Manager'
                    WHEN 6 THEN 'Worker'
                    ELSE 'Other'
                END AS employeeType,
                MONTH(Month) AS payMonth,
                YEAR(Month) AS payYear,
                basicSalary,
                incentive,
                workDays AS workingDays,
                otHours,
                otHours * (basicSalary / 30 / 8) AS hourRate,
                otHours * (basicSalary / 30 / 8) AS otAmount,
                etf,
                0 AS epf,
                0 AS deductions,
                totalSalary,
                GETDATE() AS paymentDate,
                'Paid' AS paymentStatus,
                createdDate
            FROM inserted
        ) AS source
        ON target.employeeID = source.employeeID 
        AND target.payMonth = source.payMonth 
        AND target.payYear = source.payYear
        WHEN MATCHED THEN
            UPDATE SET 
                employeeName = source.employeeName,
                employeeType = source.employeeType,
                basicSalary = source.basicSalary,
                incentive = source.incentive,
                workingDays = source.workingDays,
                otHours = source.otHours,
                hourRate = source.hourRate,
                otAmount = source.otAmount,
                etf = source.etf,
                totalSalary = source.totalSalary,
                paymentDate = source.paymentDate,
                paymentStatus = source.paymentStatus
        WHEN NOT MATCHED THEN
            INSERT (employeeID, employeeName, employeeType, payMonth, payYear, basicSalary, incentive, workingDays, otHours, hourRate, otAmount, etf, epf, deductions, totalSalary, paymentDate, paymentStatus, createdDate)
            VALUES (source.employeeID, source.employeeName, source.employeeType, source.payMonth, source.payYear, source.basicSalary, source.incentive, source.workingDays, source.otHours, source.hourRate, source.otAmount, source.etf, source.epf, source.deductions, source.totalSalary, source.paymentDate, source.paymentStatus, source.createdDate);
    END
END;
GO

-- Trigger: When paysheetTable is created, update financialTransactions (FIXED)
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
            paymentDate AS transactionDate,
            'Expense' AS transactionType,
            totalSalary AS amount,
            'Salary Payment for ' + employeeName AS description,
            'Payroll' AS category,
            paysheetID AS referenceID,
            'Paysheet' AS referenceType,
            'Active' AS status
        FROM inserted;
    END
END;
GO

PRINT 'Fixed database synchronization triggers created successfully!';
PRINT 'All tables will now automatically sync when data is inserted or updated.';
GO

