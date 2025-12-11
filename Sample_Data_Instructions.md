# Sample Bookshop Data - Instructions

## Fixed Issues

The sample data script has been updated to fix all errors:

### ✅ Fixed Issues:
1. **Identity Column Error** - Disabled trigger temporarily when inserting into ITEMS
2. **Missing Columns** - Added checks for optional columns (status, createdDate, totalAmount)
3. **Duplicate Admin User** - Script now checks if admin exists before inserting
4. **Foreign Key Violations** - All foreign keys now use dynamic lookups (itemIDs, employeeIDs, userIDs)
5. **Column Name Mismatches** - Script checks for column existence before inserting

## How to Run

1. **First, run the table compatibility script** (if not already done):
   ```sql
   -- Execute: Fix_Table_Compatibility.sql
   ```

2. **Then run the sample data script**:
   ```sql
   -- Execute: Sample_Bookshop_Data.sql
   ```

## What the Script Does

The script now:
- ✅ Checks if admin user exists before creating
- ✅ Uses dynamic lookups for all foreign keys
- ✅ Handles missing columns gracefully
- ✅ Disables/enables triggers to avoid conflicts
- ✅ Uses IDENTITY_INSERT for ITEMS table sync

## Expected Results

After running successfully, you should see:
- ✅ All tables populated with bookshop data
- ✅ No foreign key constraint errors
- ✅ No duplicate key errors
- ✅ No identity column errors
- ✅ All relationships properly linked

## Troubleshooting

If you still get errors:

1. **Make sure Fix_Table_Compatibility.sql ran successfully first**
2. **Check if tables exist**: Run `SELECT * FROM sys.tables` to verify
3. **Check column names**: The script now auto-detects column existence
4. **Clear existing data**: Uncomment the DELETE statements at the top if needed

## Data Summary

- **Suppliers**: 5
- **Items**: 18 (Books, Stationery, Printing Supplies)
- **Customers**: 10
- **Users/Employees**: 7
- **Invoices**: 10 with line items
- **Projects**: 3
- **Schedules**: 4
- **Paysheets**: 6
- **Financial Transactions**: 15
- **And more...**

All data is interconnected and ready for dashboard testing!

