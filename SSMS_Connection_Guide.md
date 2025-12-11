# SQL Server Management Studio (SSMS) Connection Guide

## Connection Details

Based on your application configuration:
- **Server Name:** `LAPTOP-2956U5GC\SQLEXPRESS`
- **Database:** `EKANAYAKE_PRINTERS_001`
- **Authentication:** Windows Authentication (Integrated Security)

---

## Steps to Connect to SSMS

### 1. Open SQL Server Management Studio
- Press `Windows Key` and search for "SQL Server Management Studio" or "SSMS"
- Click to open the application

### 2. Connect to Server Dialog
When SSMS opens, you'll see the "Connect to Server" dialog. If it doesn't appear:
- Click **File** → **Connect Object Explorer...** (or press `Ctrl+Alt+N`)

### 3. Enter Connection Information

In the "Connect to Server" dialog:

**Server type:** 
- Select `Database Engine` (default)

**Server name:**
- Enter: `LAPTOP-2956U5GC\SQLEXPRESS`
- Or try: `.\SQLEXPRESS` (if connecting locally)
- Or try: `localhost\SQLEXPRESS`

**Authentication:**
- Select `Windows Authentication` (default)
- This uses your Windows login credentials

### 4. Click Connect
- Click the **Connect** button

---

## Troubleshooting

### If Connection Fails:

#### Error: "Cannot connect to LAPTOP-2956U5GC\SQLEXPRESS"

**Solution 1: Check SQL Server Service**
1. Press `Windows Key + R`
2. Type `services.msc` and press Enter
3. Look for **SQL Server (SQLEXPRESS)** service
4. If it's not running, right-click and select **Start**
5. Ensure the service status is "Running"

**Solution 2: Try Alternative Server Names**
- `.\SQLEXPRESS`
- `localhost\SQLEXPRESS`
- `(local)\SQLEXPRESS`
- `127.0.0.1\SQLEXPRESS`

**Solution 3: Check SQL Server Configuration Manager**
1. Press `Windows Key` and search for "SQL Server Configuration Manager"
2. Navigate to **SQL Server Services**
3. Ensure **SQL Server (SQLEXPRESS)** is running
4. Check **SQL Server Network Configuration** → **Protocols for SQLEXPRESS**
   - Ensure **TCP/IP** is **Enabled**
   - Ensure **Named Pipes** is **Enabled**

**Solution 4: Verify SQL Server Express Installation**
- If SQL Server Express is not installed, download it from Microsoft's website
- Or check if you have a different SQL Server instance name

---

## After Successful Connection

### 1. Create/Verify Database
Once connected, you can:
1. Expand **Databases** in Object Explorer
2. Check if `EKANAYAKE_PRINTERS_001` exists
3. If it doesn't exist, right-click **Databases** → **New Database** → Name it `EKANAYAKE_PRINTERS_001`

### 2. Execute Your SQL Script
1. Click **File** → **Open** → **File** (or press `Ctrl+O`)
2. Navigate to `SQLQuery1.sql` in your project
3. Click **Execute** (or press `F5`) to run the script
4. This will create all the tables and schema for your RMS system

### 3. Verify Database Objects
After executing the script:
1. Expand `EKANAYAKE_PRINTERS_001` database
2. Expand **Tables** to see all created tables
3. You should see tables like:
   - `itemTable`
   - `customerTable`
   - `invoiceTable`
   - `userTable`
   - `employeeTable`
   - And many more...

---

## Quick Connection String Reference

For your application:
```
Data Source=LAPTOP-2956U5GC\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True
```

---

## Next Steps

1. ✅ Connect to SSMS using the steps above
2. ✅ Execute `SQLQuery1.sql` to create the database schema
3. ✅ Verify all tables are created successfully
4. ✅ Test your application connection

---

## Need Help?

If you continue to have connection issues:
- Verify SQL Server Express is installed
- Check Windows Firewall settings
- Ensure SQL Server Browser service is running
- Try connecting with SQL Server Authentication (if enabled) using `sa` account

