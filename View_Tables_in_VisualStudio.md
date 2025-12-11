# How to View Database Tables in Visual Studio

## Connection Information
- **Server:** `LAPTOP-2956U5GC\SQLEXPRESS`
- **Database:** `EKANAYAKE_PRINTERS_001`
- **Authentication:** Windows Authentication (Integrated Security)

---

## Method 1: SQL Server Object Explorer (Recommended)

### Steps:
1. Open Visual Studio with your solution
2. Go to **View** → **SQL Server Object Explorer** (or press `Ctrl+\, Ctrl+S`)
3. In SQL Server Object Explorer:
   - Right-click **SQL Server** → **Add SQL Server...**
   - Enter server name: `LAPTOP-2956U5GC\SQLEXPRESS`
   - Select **Windows Authentication**
   - Click **Connect**
4. Expand the tree:
   - `LAPTOP-2956U5GC\SQLEXPRESS`
   - **Databases**
   - `EKANAYAKE_PRINTERS_001`
   - **Tables**
5. You'll see all 37 tables listed
6. Right-click any table → **View Data** to see records
7. Right-click any table → **View Designer** to see table structure

### Features:
- ✅ View table data
- ✅ Edit table structure
- ✅ View indexes, triggers, constraints
- ✅ Execute queries
- ✅ View table properties

---

## Method 2: Server Explorer

### Steps:
1. Go to **View** → **Server Explorer** (or press `Ctrl+Alt+S`)
2. Right-click **Data Connections** → **Add Connection...**
3. Configure connection:
   - **Server name:** `LAPTOP-2956U5GC\SQLEXPRESS`
   - **Authentication:** Windows Authentication
   - **Select or enter database name:** `EKANAYAKE_PRINTERS_001`
   - Click **Test Connection** to verify
   - Click **OK**
4. Expand the connection:
   - **Data Connections**
   - `LAPTOP-2956U5GC\SQLEXPRESS.EKANAYAKE_PRINTERS_001.dbo`
   - **Tables**
5. Double-click any table to view its data
6. Right-click table → **Open Table Definition** to see structure

### Features:
- ✅ View table data
- ✅ Edit table structure
- ✅ Create new tables
- ✅ View stored procedures, views, functions

---

## Method 3: Data Sources Window

### Steps:
1. Go to **View** → **Other Windows** → **Data Sources** (or press `Shift+Alt+D`)
2. Click **Add New Data Source...**
3. Select **Database** → **Next**
4. Select **Dataset** → **Next**
5. Click **New Connection...**
6. Configure:
   - **Server name:** `LAPTOP-2956U5GC\SQLEXPRESS`
   - **Authentication:** Windows Authentication
   - **Database:** `EKANAYAKE_PRINTERS_001`
   - Click **OK**
7. Select tables you want to view
8. Click **Finish**

---

## Available Tables (37 Total)

### Core Tables:
- `userTable` - User accounts
- `employeeTable` - Employee information
- `customerTable` / `customer` - Customer data
- `itemTable` / `ITEMS` - Product/Item information

### Management Tables:
- `managerTable`
- `accountantTable`
- `cashierTable`
- `siteEngineerTable`
- `stockManagerTable`
- `workerTable`

### Business Tables:
- `invoiceTable` - Invoices
- `invoiceLineItems` - Invoice line items
- `BillESIMATE` - Bill estimates
- `BillEstimateLineItems` - Estimate line items
- `returnTable` - Returns

### Stock Tables:
- `availableSTOCKS` - Available stock
- `soldSTOCKS` - Sold stock
- `STOCKBUYING` - Stock purchases

### Project Tables:
- `projectTable` / `projects` - Projects
- `projectProgress` - Project progress
- `workingProcedure` - Working procedures
- `schedule` - Schedules

### Financial Tables:
- `paysheetTable` - Paysheets
- `JD_EMPLOYEE_PAYSHEET` - Employee paysheets
- `salaryHistory` - Salary history
- `financialTransactions` - Financial transactions

### Supplier Tables:
- `supplier` - Suppliers
- `SUPPLIERS` - Suppliers (alternate)
- `supplierSales` - Supplier sales

### Reporting Tables:
- `report` - Reports
- `salesCount` - Sales counts
- `salesReportCount` - Sales report counts

### Session Tables:
- `sessionStart` - Session start logs
- `sessionEnd` - Session end logs

---

## Tips

1. **Quick Access:** Pin SQL Server Object Explorer to keep it always visible
2. **Edit Data:** In SQL Server Object Explorer, you can directly edit table data
3. **Query Editor:** Right-click database → **New Query** to write SQL queries
4. **Table Designer:** Right-click table → **View Designer** to modify table structure
5. **Refresh:** Right-click → **Refresh** to update the view

---

## Troubleshooting

### Connection Issues:
- Ensure SQL Server Express is running
- Check Windows Authentication is enabled
- Verify server name: `LAPTOP-2956U5GC\SQLEXPRESS`
- Test connection first before expanding

### Can't See Tables:
- Make sure you're connected to the correct database: `EKANAYAKE_PRINTERS_001`
- Refresh the connection (right-click → Refresh)
- Check if you have proper permissions

### SSL Certificate Error:
- The connection string already includes `TrustServerCertificate=True`
- This should be handled automatically in the application

---

## Keyboard Shortcuts

- **SQL Server Object Explorer:** `Ctrl+\, Ctrl+S`
- **Server Explorer:** `Ctrl+Alt+S`
- **Data Sources:** `Shift+Alt+D`

