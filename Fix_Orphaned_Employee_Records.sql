-- =============================================
-- Fix Orphaned Employee Records
-- This script helps identify and fix employee records
-- that reference non-existent userIDs
-- =============================================

USE EKANAYAKE_PRINTERS_001;
GO

-- =============================================
-- 1. CHECK FOR ORPHANED EMPLOYEE RECORDS
-- =============================================
-- This query finds employee records with invalid userIDs
PRINT 'Checking for orphaned employee records...';
PRINT '';

SELECT 
    e.employeeID,
    e.userID,
    e.employeeType,
    e.positionIndex,
    e.status,
    'ORPHANED - User does not exist' AS Issue
FROM employeeTable e
LEFT JOIN userTable u ON e.userID = u.userID
WHERE u.userID IS NULL;

GO

-- =============================================
-- 2. VIEW ALL EMPLOYEE RECORDS WITH USER INFO
-- =============================================
-- This query shows all employee records and their associated user info
PRINT '';
PRINT 'All employee records with user information:';
PRINT '';

SELECT 
    e.employeeID,
    e.userID,
    u.fullName,
    u.username,
    e.employeeType,
    e.positionIndex,
    e.status,
    CASE 
        WHEN u.userID IS NULL THEN 'ORPHANED'
        ELSE 'VALID'
    END AS RecordStatus
FROM employeeTable e
LEFT JOIN userTable u ON e.userID = u.userID
ORDER BY e.employeeID;

GO

-- =============================================
-- 3. DELETE ORPHANED EMPLOYEE RECORDS (USE WITH CAUTION!)
-- =============================================
-- Uncomment the code below ONLY if you want to delete orphaned records
-- Make sure to backup your database first!

/*
PRINT '';
PRINT 'Deleting orphaned employee records...';
PRINT '';

DELETE e
FROM employeeTable e
LEFT JOIN userTable u ON e.userID = u.userID
WHERE u.userID IS NULL;

PRINT 'Orphaned records deleted.';
GO
*/

-- =============================================
-- 4. VERIFY USER TABLE HAS VALID RECORDS
-- =============================================
PRINT '';
PRINT 'User table records:';
PRINT '';

SELECT 
    userID,
    fullName,
    username,
    userType,
    positionIndex,
    status
FROM userTable
ORDER BY userID;

GO

-- =============================================
-- 5. CREATE MISSING EMPLOYEE RECORDS FOR EXISTING USERS
-- =============================================
-- This creates employee records for users that don't have them
-- Only for users with positionIndex > 0 (not administrators)

PRINT '';
PRINT 'Checking for users without employee records...';
PRINT '';

-- Show users that need employee records
SELECT 
    u.userID,
    u.fullName,
    u.username,
    u.userType,
    u.positionIndex,
    'Needs employee record' AS Status
FROM userTable u
LEFT JOIN employeeTable e ON u.userID = e.userID
WHERE e.userID IS NULL 
  AND u.positionIndex > 0  -- Not administrator (positionIndex 0)
  AND u.status = 'Active';

GO

-- Uncomment below to automatically create employee records for users that need them
/*
PRINT '';
PRINT 'Creating missing employee records...';
PRINT '';

INSERT INTO employeeTable (userID, employeeType, positionIndex, status)
SELECT 
    u.userID,
    u.userType AS employeeType,
    u.positionIndex,
    'Active' AS status
FROM userTable u
LEFT JOIN employeeTable e ON u.userID = e.userID
WHERE e.userID IS NULL 
  AND u.positionIndex > 0  -- Not administrator
  AND u.status = 'Active';

PRINT 'Missing employee records created.';
GO
*/

PRINT '';
PRINT 'Script completed. Review the results above.';
PRINT 'Uncomment the DELETE or INSERT sections if you want to fix the issues automatically.';
GO

