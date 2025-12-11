# User Credentials - Ekanayake Printers RMS

## Login Credentials for All User Roles

### 📋 Accountant
- **Username:** `accountant`
- **Password:** `acc123`
- **Full Name:** Accountant Silva
- **Email:** accountant@ekanayake.com
- **Position Index:** 2
- **User Type:** Accountant

---

### 💰 Cashier
- **Username:** `cashier`
- **Password:** `cash123`
- **Full Name:** Cashier Fernando
- **Email:** cashier@ekanayake.com
- **Position Index:** 3
- **User Type:** Cashier

---

### 🏗️ Site Engineer
- **Username:** `engineer`
- **Password:** `eng123`
- **Full Name:** Engineer Wickramasinghe
- **Email:** engineer@ekanayake.com
- **Position Index:** 4
- **User Type:** Site Engineer

---

### 📦 Stock Manager
- **Username:** `stockmgr`
- **Password:** `stock123`
- **Full Name:** Stock Manager Jayawardena
- **Email:** stock@ekanayake.com
- **Position Index:** 5
- **User Type:** Stock Manager

---

### 👷 Worker
- **Username:** `worker`
- **Password:** `work123`
- **Full Name:** Worker Mendis
- **Email:** worker@ekanayake.com
- **Position Index:** 6
- **User Type:** Worker

---

## Additional User Accounts

### 👨‍💼 Manager
- **Username:** `manager`
- **Password:** `manager123`
- **Full Name:** Manager Perera
- **Email:** manager@ekanayake.com
- **Position Index:** 1
- **User Type:** Manager

### 👑 Administrator
- **Username:** `admin`
- **Password:** `admin123`
- **Full Name:** Admin User
- **Email:** admin@ekanayake.com
- **Position Index:** 0
- **User Type:** Administrator

---

## Quick Reference Table

| Role | Username | Password | Position Index |
|------|----------|----------|----------------|
| Administrator | `admin` | `admin123` | 0 |
| Manager | `manager` | `manager123` | 1 |
| **Accountant** | `accountant` | `acc123` | 2 |
| **Cashier** | `cashier` | `cash123` | 3 |
| **Site Engineer** | `engineer` | `eng123` | 4 |
| **Stock Manager** | `stockmgr` | `stock123` | 5 |
| **Worker** | `worker` | `work123` | 6 |

---

## Notes

- All passwords are stored in **plain text** in the database (not encrypted)
- All users have status: **Active**
- These credentials are from the sample data script (`Sample_Bookshop_Data.sql`)
- If you haven't run the sample data script, these users may not exist in your database

## To Verify Users in Database

Run this SQL query in SSMS:

```sql
USE EKANAYAKE_PRINTERS_001;
GO

SELECT 
    userID,
    fullName,
    username,
    userPassword,
    userType,
    positionIndex,
    status
FROM userTable
WHERE userType IN ('Accountant', 'Cashier', 'Site Engineer', 'Stock Manager', 'Worker')
ORDER BY positionIndex;
```

---

## Security Recommendation

⚠️ **Important:** These are default/test credentials. For production use:
1. Change all default passwords
2. Implement password hashing/encryption
3. Enforce strong password policies
4. Use secure authentication mechanisms

