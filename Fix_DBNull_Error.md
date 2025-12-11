# Fix: DBNull Casting Error When Creating User

## Error Message
```
Error: Object cannot be cast from DBNull to other types.
```

## Root Cause
The error occurs when trying to convert database values (which can be `DBNull`) directly to .NET types without checking for null values first. This commonly happens when:
- Reading values from database that are NULL
- Using `ExecuteScalar()` which can return `DBNull`
- Converting database values without null checks

## Solution Applied

### ✅ Code Fixes (User Account_Panel_Form.cs)

#### 1. **Fixed ExecuteScalar() DBNull Handling**
**Before:**
```csharp
int userExists = (int)checkUser.ExecuteScalar();
```

**After:**
```csharp
object result = checkUser.ExecuteScalar();
int userExists = result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
```

#### 2. **Fixed SCOPE_IDENTITY() DBNull Handling**
**Before:**
```csharp
int newUserID = Convert.ToInt32(new SqlCommand("SELECT SCOPE_IDENTITY()", con).ExecuteScalar());
```

**After:**
```csharp
object identityResult = new SqlCommand("SELECT SCOPE_IDENTITY()", con).ExecuteScalar();
if (identityResult == null || identityResult == DBNull.Value)
{
    throw new Exception("Failed to retrieve the newly created user ID.");
}
int newUserID = Convert.ToInt32(identityResult);
```

#### 3. **Fixed DataReader DBNull Handling**
**Before:**
```csharp
textBox8.Text = reader["userID"].ToString();
textBox5.Text = reader["fullName"].ToString();
```

**After:**
```csharp
object userIDObj = reader["userID"];
textBox8.Text = userIDObj != null && userIDObj != DBNull.Value ? userIDObj.ToString() : "";

object fullNameObj = reader["fullName"];
textBox5.Text = fullNameObj != null && fullNameObj != DBNull.Value ? fullNameObj.ToString() : "";
```

#### 4. **Fixed Telephone Number Validation**
**Before:**
```csharp
tel = string.IsNullOrWhiteSpace(textBox13.Text) ? 0 : Convert.ToInt64(textBox13.Text);
```

**After:**
```csharp
if (string.IsNullOrWhiteSpace(textBox13.Text))
{
    tel = 0;
}
else
{
    if (!long.TryParse(textBox13.Text, out tel))
    {
        MessageBox.Show("Please enter a valid telephone number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        return;
    }
}
```

#### 5. **Fixed Telephone Parameter for Database**
**Before:**
```csharp
cmd.Parameters.AddWithValue("@tel", tel);
```

**After:**
```csharp
// Handle tel - use DBNull if 0, otherwise use the value
cmd.Parameters.AddWithValue("@tel", tel == 0 ? (object)DBNull.Value : tel);
```

#### 6. **Fixed SqlDataReader Resource Management**
**Before:**
```csharp
SqlDataReader reader2 = cmd2.ExecuteReader();
if (reader2.Read())
{
    textBox10.Text = reader2.GetValue(1).ToString();
}
```

**After:**
```csharp
using (SqlDataReader reader2 = cmd2.ExecuteReader())
{
    if (reader2.Read())
    {
        object employeeUserID = reader2.GetValue(1);
        if (employeeUserID != null && employeeUserID != DBNull.Value)
        {
            textBox10.Text = employeeUserID.ToString();
        }
    }
}
```

---

## Key Improvements

1. ✅ **Null Safety** - All database value reads now check for DBNull before conversion
2. ✅ **Better Error Handling** - Clear error messages when values are missing
3. ✅ **Input Validation** - Telephone number validation with TryParse
4. ✅ **Resource Management** - Proper using statements for SqlDataReader
5. ✅ **Database Compatibility** - Proper handling of NULL values in database

---

## Common DBNull Patterns

### Pattern 1: ExecuteScalar()
```csharp
// ❌ Wrong
int value = (int)cmd.ExecuteScalar();

// ✅ Correct
object result = cmd.ExecuteScalar();
int value = result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
```

### Pattern 2: DataReader
```csharp
// ❌ Wrong
string name = reader["name"].ToString();

// ✅ Correct
object nameObj = reader["name"];
string name = nameObj != null && nameObj != DBNull.Value ? nameObj.ToString() : "";
```

### Pattern 3: Nullable Database Fields
```csharp
// ❌ Wrong
cmd.Parameters.AddWithValue("@tel", tel);

// ✅ Correct (if tel can be 0/null)
cmd.Parameters.AddWithValue("@tel", tel == 0 ? (object)DBNull.Value : tel);
```

---

## Testing

After the fix, test these scenarios:

1. ✅ **Create user with all fields filled** - Should work
2. ✅ **Create user with optional fields empty** - Should work (NIC, email, address, tel)
3. ✅ **Create user with invalid telephone** - Should show validation error
4. ✅ **Search for user** - Should handle NULL values properly
5. ✅ **Create user and verify employee record** - Should work correctly

---

## Related Files
- `Ekanayake Application/Main User Controls/Manager User Control/User Account_Panel_Form.cs` - Fixed

---

## Prevention Tips

1. **Always check for DBNull** when reading from database
2. **Use TryParse** for numeric conversions from user input
3. **Use nullable types** when database fields can be NULL
4. **Use using statements** for SqlDataReader to ensure proper disposal
5. **Validate user input** before database operations

