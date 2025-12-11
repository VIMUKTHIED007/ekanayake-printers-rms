# Database Tables with Update Tracking

## 📋 Tables with Update/Date Tracking Columns

### 1. **itemTable**
- **Columns:**
  - `createdDate` - DATETIME (when item was created)
  - `lastUpdated` - DATETIME (when item was last updated)
- **Auto-updated:** `lastUpdated` is set to GETDATE() on updates
- **Purpose:** Tracks when items are created and modified

---

### 2. **availableSTOCKS**
- **Columns:**
  - `lastUpdatedDATE` - DATE (when stock quantity was last updated)
- **Auto-updated:** Automatically updated when stock is bought or sold
- **Purpose:** Tracks when available stock quantities change

---

### 3. **userTable**
- **Columns:**
  - `createdDate` - DATETIME (when user account was created)
  - `lastLogin` - DATETIME (when user last logged in)
- **Auto-updated:** `createdDate` on insert, `lastLogin` on login
- **Purpose:** Tracks user account creation and login activity

---

### 4. **supplier**
- **Columns:**
  - `createdDate` - DATETIME (when supplier was added)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks when suppliers are added to the system

---

### 5. **projectTable**
- **Columns:**
  - `createDate` - DATETIME (when project was created)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks project creation date

---

### 6. **customerTable**
- **Columns:**
  - `regDate` - DATE (when customer was registered)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks customer registration date

---

### 7. **salesCount**
- **Columns:**
  - `stockUpdateDate` - DATE (when stock count was updated)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks when sales count records are updated

---

### 8. **report**
- **Columns:**
  - `generatedDate` - DATETIME (when report was generated)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks when reports are generated

---

### 9. **salesReportCount**
- **Columns:**
  - `reportDate` - DATETIME (when report was created)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks sales report generation date

---

### 10. **financialTransactions**
- **Columns:**
  - `transactionDate` - DATETIME (when transaction occurred)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks transaction timestamps

---

### 11. **sessionStart**
- **Columns:**
  - `sessionStartTime` - DATETIME (when session started)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks user login sessions

---

### 12. **sessionEnd**
- **Columns:**
  - `sessionEndTime` - DATETIME (when session ended)
- **Auto-updated:** Set to GETDATE() on insert
- **Purpose:** Tracks user logout sessions

---

## 🔄 Tables Updated by Triggers

These tables are automatically updated by database triggers:

### 1. **availableSTOCKS**
- **Updated by:**
  - `TR_STOCKBUYING_Update_AvailableStocks` - When stock is purchased
  - `TR_soldSTOCKS_Update_AvailableStocks` - When stock is sold
- **What's updated:** `availableQTY`, `lastUpdatedDATE`

### 2. **itemTable**
- **Updated by:**
  - `TR_itemTable_Sync_ITEMS` - Syncs with ITEMS table
  - Stock buying triggers - Updates quantity
- **What's updated:** `quantity`, `lastUpdated`

### 3. **ITEMS** (Legacy table)
- **Updated by:**
  - `TR_itemTable_Sync_ITEMS` - Syncs with itemTable
- **What's updated:** All columns when itemTable changes

### 4. **customerTable**
- **Updated by:**
  - `TR_customer_Sync` - Syncs with customer table
- **What's updated:** All columns when customer table changes

### 5. **projectTable**
- **Updated by:**
  - `TR_projects_Sync` - Syncs with projects table
- **What's updated:** All columns when projects table changes

### 6. **paysheetTable**
- **Updated by:**
  - `TR_JD_PAYSHEET_Update_paysheetTable` - Syncs with JD_EMPLOYEE_PAYSHEET
- **What's updated:** All paysheet columns

### 7. **financialTransactions**
- **Updated by:**
  - `TR_paysheetTable_Update_FinancialTransactions` - When paysheet is created
  - `TR_invoiceTable_Update_FinancialTransactions` - When invoice is created
- **What's updated:** New transaction records created

---

## 📊 Summary Query

Run this query to see all tables with update tracking:

```sql
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    CASE 
        WHEN c.name LIKE '%update%' OR c.name LIKE '%Update%' THEN 'Update Tracking'
        WHEN c.name LIKE '%create%' OR c.name LIKE '%Create%' THEN 'Creation Tracking'
        WHEN c.name LIKE '%date%' OR c.name LIKE '%Date%' THEN 'Date Tracking'
        ELSE 'Other'
    END AS TrackingType
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE c.name LIKE '%update%' 
   OR c.name LIKE '%Update%'
   OR c.name LIKE '%create%'
   OR c.name LIKE '%Create%'
   OR c.name LIKE '%date%'
   OR c.name LIKE '%Date%'
   OR c.name LIKE '%login%'
   OR c.name LIKE '%Login%'
ORDER BY t.name, c.name;
```

---

## 🔍 Check Recent Updates

To see recently updated records:

```sql
-- Recently updated items
SELECT TOP 10 
    itemID, 
    modelID, 
    details, 
    lastUpdated 
FROM itemTable 
ORDER BY lastUpdated DESC;

-- Recently updated stock
SELECT TOP 10 
    stockID, 
    itemID, 
    availableQTY, 
    lastUpdatedDATE 
FROM availableSTOCKS 
ORDER BY lastUpdatedDATE DESC;

-- Recent user logins
SELECT TOP 10 
    userID, 
    username, 
    lastLogin 
FROM userTable 
WHERE lastLogin IS NOT NULL
ORDER BY lastLogin DESC;
```

---

## 📝 Notes

1. **Automatic Updates:**
   - Most date columns use `DEFAULT GETDATE()` for automatic timestamping
   - Triggers automatically update related tables when data changes

2. **Manual Updates:**
   - `lastUpdated` in `itemTable` should be updated manually in UPDATE statements
   - Or use triggers to auto-update

3. **Tracking Changes:**
   - For full audit trail, consider adding triggers that log all changes to an audit table
   - Current setup tracks creation and last update, but not full change history

---

**All tables with update tracking are listed above!**

