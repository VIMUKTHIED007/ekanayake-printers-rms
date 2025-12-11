# 🔧 MANUAL LOG4NET INSTALLATION - Step by Step

## ⚠️ If NuGet Installation Failed

If restoring NuGet packages didn't work, follow these manual steps:

---

## Method 1: Download and Copy DLL Directly

### Step 1: Download log4net.dll

**Option A: Direct Download Link**
1. Go to: https://www.nuget.org/api/v2/package/log4net/1.2.10
2. This will download `log4net.1.2.10.nupkg`
3. **Rename** the file from `.nupkg` to `.zip`
4. **Extract** the zip file (right-click → Extract All)

**Option B: Alternative Download**
1. Search Google for: "log4net 1.2.10 download dll"
2. Download from a trusted source
3. Make sure it's version **1.2.10.0**

### Step 2: Extract the DLL

1. After extracting the `.nupkg` (renamed to `.zip`):
2. Navigate to: `lib\net40-full\` folder
3. Find: `log4net.dll` (should be around 400-500 KB)

### Step 3: Copy to Project Folders

**Copy the DLL to these locations:**

1. **Debug folder:**
   ```
   Ekanayake Application\bin\Debug\log4net.dll
   ```

2. **Release folder (if exists):**
   ```
   Ekanayake Application\bin\Release\log4net.dll
   ```

3. **Create packages folder structure:**
   ```
   packages\log4net.1.2.10\lib\net40-full\log4net.dll
   ```

### Step 4: Verify and Rebuild

1. **Check files exist:**
   - `Ekanayake Application\bin\Debug\log4net.dll` ✅
   - `packages\log4net.1.2.10\lib\net40-full\log4net.dll` ✅

2. **Rebuild Solution:**
   - Build → Rebuild Solution (`Ctrl+Shift+B`)

3. **Test the application**

---

## Method 2: Use NuGet Command Line (nuget.exe)

### Step 1: Download NuGet.exe

1. Go to: https://www.nuget.org/downloads
2. Download `nuget.exe`
3. Place it in a folder (e.g., `C:\NuGet\`)

### Step 2: Install log4net via Command Line

1. **Open Command Prompt as Administrator**

2. **Navigate to your project folder:**
   ```cmd
   cd "C:\Users\sadew\Documents\GitHub\ekanayake-printers-rms"
   ```

3. **Run NuGet install:**
   ```cmd
   C:\NuGet\nuget.exe install log4net -Version 1.2.10 -OutputDirectory packages
   ```

4. **Wait for download and extraction**

5. **Rebuild Solution in Visual Studio**

---

## Method 3: Add Reference Manually in Visual Studio

### Step 1: Download DLL (see Method 1, Step 1-2)

### Step 2: Add Reference in Visual Studio

1. **Open Visual Studio**

2. **Right-click** on `Ekanayake Printers RMS` project → **Add → Reference**

3. **Click:** "Browse" button

4. **Navigate** to where you saved `log4net.dll`

5. **Select** `log4net.dll`

6. **Click:** OK

7. **In Solution Explorer:**
   - Expand: References
   - Find: `log4net`
   - Right-click → Properties
   - Set: **Copy Local = True**

8. **Rebuild Solution**

---

## Method 4: Copy from Another Project (If Available)

If you have another project with log4net installed:

1. **Find log4net.dll** in that project's `bin\Debug\` folder
2. **Copy** it to: `Ekanayake Application\bin\Debug\`
3. **Rebuild Solution**

---

## ✅ Verification Checklist

After installation, verify:

- [ ] `log4net.dll` exists in `Ekanayake Application\bin\Debug\`
- [ ] File size is approximately 400-500 KB
- [ ] File version shows 1.2.10.0 (right-click → Properties → Details)
- [ ] Solution rebuilds without errors
- [ ] Application runs without Crystal Reports error

---

## 🚨 Common Issues

### Issue: "Still getting error after copying DLL"
**Solution:**
1. Close Visual Studio completely
2. Delete `bin` and `obj` folders
3. Reopen Visual Studio
4. Rebuild Solution

### Issue: "Wrong version error"
**Solution:**
- Must use exactly version **1.2.10.0**
- Check DLL properties: Right-click → Properties → Details → File version

### Issue: "DLL gets deleted after rebuild"
**Solution:**
- Make sure "Copy Local = True" in reference properties
- Or copy DLL to `packages\log4net.1.2.10\lib\net40-full\` folder

---

## 📥 Quick Download Links

**Direct NuGet Package:**
- https://www.nuget.org/api/v2/package/log4net/1.2.10

**NuGet Package Page:**
- https://www.nuget.org/packages/log4net/1.2.10

---

## 🎯 Recommended: Method 1 (Direct Copy)

**Fastest way:** Download the package, extract DLL, copy to `bin\Debug\` folder.

**This should work immediately without rebuilding!**

