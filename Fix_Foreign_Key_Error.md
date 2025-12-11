# Fix: Foreign Key Constraint Error - employeeTable

## Error Message
```
The INSERT statement conflicted with the FOREIGN KEY constraint "FKemmployeeT userl 6B24EA82". 
The conflict occurred in database "EKANAYAKE_PRINTERS_001", table "dbo.userTable", column "userID"
```

## Root Cause
The error occurs when trying to insert a record into `employeeTable` with a `userID` that doesn't exist in `userTable`. This violates the foreign key constraint.

## Solution Applied

### ✅ Code Fix (Employee User Control.cs)
The code has been updated to:
1. **Validate User ID exists** - Check if the userID exists in `userTable` before inserting
2. **Check for duplicates** - Prevent inserting duplicate employee records
3. **Better error messages** - Provide clear feedback to users

### Changes Made:
- Added validation to check if `userID` exists in `userTable`
- Added check to prevent duplicate employee records
- Improved error handling and user feedback
- Added input validation for numeric User ID

---

## How to Use

### When Creating an Employee Record:
1. **First, create the user account** using the User Account Panel
2. **Note the User ID** that was created
3. **Then, create the employee record** using the Employee User Control with that User ID

### The system will now:
- ✅ Verify the User ID exists before creating employee record
- ✅ Prevent duplicate employee records
- ✅ Show clear error messages if something is wrong

---

## If You Still Get the Error

### Option 1: Check for Orphaned Records
Run this SQL query to find any employee records with invalid userIDs:

```sql
-- Find employee records with invalid userIDs
SELECT e.employeeID, e.userID, e.employeeType
FROM employeeTable e
LEFT JOIN userTable u ON e.userID = u.userID
WHERE u.userID IS NULL;
```

### Option 2: Clean Up Orphaned Records
If you find orphaned records, you can delete them:

```sql
-- Delete orphaned employee records (use with caution!)
DELETE e
FROM employeeTable e
LEFT JOIN userTable u ON e.userID = u.userID
WHERE u.userID IS NULL;
```

### Option 3: Verify User Exists
Before creating an employee record, verify the user exists:

```sql
-- Check if a user exists
SELECT userID, fullName, username, userType
FROM userTable
WHERE userID = @YourUserID;
```

---

## Prevention Tips

1. **Always create user accounts first** before creating employee records
2. **Use the User Account Panel** to create users, which automatically creates employee records when appropriate
3. **Verify User IDs** exist before manually creating employee records
4. **Check for existing records** before inserting to avoid duplicates

---

## Testing the Fix

1. Try to create an employee record with a **non-existent User ID**
   - You should now get: "User ID X does not exist in the user table. Please create the user account first."

2. Try to create an employee record with an **existing User ID that already has an employee record**
   - You should now get: "Employee record already exists for User ID X. Please update the existing record instead."

3. Create a user account first, then create an employee record with that User ID
   - This should work successfully now!

---

## Related Files
- `Ekanayake Application/Main User Controls/Manager User Control/Employee User Control.cs` - Fixed
- `Ekanayake Application/Main User Controls/Manager User Control/User Account_Panel_Form.cs` - Already handles this correctly

