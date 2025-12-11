# Customer Table Connection Guide

## 📋 Overview

The customer registration form connects to the database through the `customer` table, which automatically syncs with `customerTable` via database triggers.

## 🔗 Connection Flow

```
Customer Registration Form
         ↓
    customer table (INSERT)
         ↓
    TR_customer_Sync_customerTable Trigger
         ↓
    customerTable (AUTO-SYNC)
```

## ✅ Current Setup

### 1. **Form Inserts Into:**
- **Table:** `customer`
- **Location:** `Customer Register Form.cs` → `btnRegister_Click()`

### 2. **Automatic Sync:**
- **Trigger:** `TR_customer_Sync_customerTable`
- **Direction:** `customer` → `customerTable`
- **When:** After INSERT, UPDATE, DELETE on `customer` table

### 3. **Reverse Sync:**
- **Trigger:** `TR_customerTable_Sync_customer`
- **Direction:** `customerTable` → `customer`
- **When:** After INSERT, UPDATE, DELETE on `customerTable` table

## 🔍 Verify Connection

### Step 1: Run Verification Script

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to: `LAPTOP-2956U5GC\SQLEXPRESS`
3. Select database: `EKANAYAKE_PRINTERS_001`
4. Open and run: `Verify_Customer_Table_Connection.sql`
5. Check the output for any issues

### Step 2: Test Registration

1. **Open the application**
2. **Navigate to Customer Registration Form**
3. **Fill in the form:**
   - First Name: Test
   - Last Name: Customer
   - Customer Type: Regular Customer
   - Telephone: 123456789
   - Other fields (optional)
4. **Click Register**
5. **Verify in SSMS:**

```sql
-- Check customer table
SELECT * FROM customer WHERE firstName = 'Test' AND lastName = 'Customer';

-- Check customerTable (should have same data)
SELECT * FROM customerTable WHERE firstName = 'Test' AND lastName = 'Customer';

-- Both should return the same record
```

## 🛠️ If Connection Doesn't Work

### Issue 1: Triggers Not Created

**Solution:** Run `Verify_Customer_Table_Connection.sql` - it will create the triggers automatically.

### Issue 2: Data Not Syncing

**Check:**
1. Are triggers enabled?
   ```sql
   SELECT name, is_disabled FROM sys.triggers 
   WHERE name LIKE '%customer%';
   ```

2. If disabled, enable them:
   ```sql
   ALTER TABLE customer ENABLE TRIGGER TR_customer_Sync_customerTable;
   ALTER TABLE customerTable ENABLE TRIGGER TR_customerTable_Sync_customer;
   ```

### Issue 3: Tables Don't Exist

**Solution:** Run `Fix_Table_Compatibility.sql` to create missing tables.

## 📊 Table Structure

### customer Table
```sql
customerID (IDENTITY - auto-generated)
customerType
firstName
lastName
email
tel
city
nic
customerAddress
customerLocation
dob
regDate (DEFAULT GETDATE())
gender
status (DEFAULT 'Active')
```

### customerTable Table
```sql
customerID (IDENTITY - auto-generated)
customerType
firstName
lastName
email
tel
city
nic
customerAddress
customerLocation
dob
regDate (DEFAULT GETDATE())
gender
status (DEFAULT 'Active')
```

**Both tables have identical structure!**

## ✅ What's Fixed

1. ✅ Form inserts into `customer` table correctly
2. ✅ `customerID` is auto-generated (IDENTITY)
3. ✅ Triggers sync data to `customerTable` automatically
4. ✅ Both tables stay synchronized
5. ✅ Connection string fixed (no leading space)
6. ✅ Proper error handling added
7. ✅ Validation added

## 🎯 Summary

**The customer registration form is properly connected!**

- Form → `customer` table
- Trigger → Syncs to `customerTable`
- Both tables always have the same data
- All parts of the application can use either table

**Run `Verify_Customer_Table_Connection.sql` to ensure everything is working!**

