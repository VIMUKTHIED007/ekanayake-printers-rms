# Sample Stock Data - Instructions

## 📦 What This Script Does

The `Sample_Stock_Data.sql` script inserts sample data into all stock-related tables:

1. **STOCKBUYING** - Stock purchase records
2. **availableSTOCKS** - Available stock quantities
3. **soldSTOCKS** - Sold stock records
4. **itemTable** - Updates item quantities

## 🚀 How to Use

### Step 1: Open SQL Server Management Studio (SSMS)

1. Open SSMS
2. Connect to your server: `LAPTOP-2956U5GC\SQLEXPRESS`
3. Select database: `EKANAYAKE_PRINTERS_001`

### Step 2: Run the Script

1. Open `Sample_Stock_Data.sql` in SSMS
2. Click **Execute** (or press F5)
3. Wait for execution to complete

### Step 3: Verify Data

Run these queries to check the data:

```sql
-- Check Stock Buying Records
SELECT * FROM STOCKBUYING;

-- Check Available Stocks
SELECT * FROM availableSTOCKS;

-- Check Sold Stocks
SELECT * FROM soldSTOCKS;

-- Summary View
SELECT 
    i.modelID,
    i.details,
    ISNULL(av.availableQTY, 0) AS AvailableQty,
    ISNULL(SUM(sb.boughtQTY), 0) AS TotalBought,
    ISNULL(SUM(ss.soldQTY), 0) AS TotalSold
FROM itemTable i
LEFT JOIN availableSTOCKS av ON i.itemID = av.itemID
LEFT JOIN STOCKBUYING sb ON i.itemID = sb.itemID
LEFT JOIN soldSTOCKS ss ON i.itemID = ss.itemID
GROUP BY i.itemID, i.modelID, i.details, av.availableQTY
ORDER BY i.modelID;
```

## 📊 Sample Data Included

### Stock Buying Records:
- **7 purchase records** for different items
- Dates: January-February 2024
- Includes: Books, Stationery, Printing Supplies
- Quantities: 30-200 units per purchase

### Available Stocks:
- **Auto-calculated** from stock buying minus sales
- Updated automatically via triggers
- Shows current available quantities

### Sold Stocks:
- **8 sales records** for different items
- Dates: February-March 2024
- Includes discounts (0%, 5%, 10%)
- Linked to invoices (if they exist)

## ⚠️ Important Notes

1. **Items Created Automatically:**
   - If items don't exist, the script creates sample items first
   - Items created: BK001, BK002, BK003, BK004, ST001, ST002, PR001

2. **No Duplicate Data:**
   - Script checks for existing records before inserting
   - Won't create duplicates if run multiple times

3. **Automatic Updates:**
   - Triggers automatically update `availableSTOCKS` when:
     - New stock is bought (STOCKBUYING insert)
     - Stock is sold (soldSTOCKS insert)

4. **Dependencies:**
   - Works with existing items in `itemTable`
   - Can link to invoices if they exist
   - Creates items if they don't exist

## 🔄 To Add More Stock Data

Edit the script and add more INSERT statements following the same pattern:

```sql
INSERT INTO STOCKBUYING (itemID, boughtQTY, unitPrice, sellingPricePerUnit, purchaseDate, supplierID)
VALUES (@ItemID, quantity, unitPrice, sellingPrice, '2024-XX-XX', 'supplierID');
```

## ✅ Success Indicators

After running the script, you should see:
- ✅ "Stock Data Inserted Successfully!" message
- ✅ Summary counts for each table
- ✅ Data visible in SSMS when querying tables
- ✅ Available stocks updated correctly

## 🐛 Troubleshooting

### Error: "Invalid column name 'totalAmount'"
**Solution:** The script automatically detects if the column exists and uses the correct INSERT statement.

### Error: "Foreign key constraint"
**Solution:** Make sure items exist in `itemTable` first, or let the script create them.

### No data inserted
**Solution:** Check if items exist. The script creates them if missing, but verify the modelID matches.

---

**Run the script and your stock tables will be populated with sample data!**

