# INSTALL LOG4NET - Step by Step Instructions

## ⚠️ Current Error
You're seeing this error because log4net.dll is missing. Let's fix it now!

## ✅ Method 1: Visual Studio NuGet Package Manager (Easiest)

### Step-by-Step:

1. **Open Visual Studio** (if not already open)

2. **Open Solution Explorer** (View → Solution Explorer, or press `Ctrl+Alt+L`)

3. **Right-click** on the project name:
   - Look for: `Ekanayake Printers RMS` (or `Ekanayake Application`)
   - **Right-click** on it

4. **Select:** "Manage NuGet Packages..." from the context menu

5. **In the NuGet window:**
   - Click the **"Browse"** tab at the top
   - In the search box, type: `log4net`
   - Press Enter

6. **Select the package:**
   - Look for: `log4net` by Apache Software Foundation
   - **IMPORTANT:** Select version **1.2.10** (not the latest version!)
   - Click the **"Install"** button

7. **Wait for installation:**
   - A progress bar will show
   - Wait until it says "Installed"

8. **Close the NuGet window**

9. **Rebuild the solution:**
   - Go to: **Build → Rebuild Solution**
   - Or press: `Ctrl+Shift+B`
   - Wait for build to complete

10. **Test:**
    - Run the application (F5)
    - Try to open a report
    - Error should be gone!

---

## ✅ Method 2: Package Manager Console (Alternative)

If Method 1 doesn't work:

1. **Open Visual Studio**

2. **Open Package Manager Console:**
   - Go to: **Tools → NuGet Package Manager → Package Manager Console**
   - A console window will open at the bottom

3. **Type this command:**
   ```powershell
   Install-Package log4net -Version 1.2.10
   ```

4. **Press Enter**

5. **Wait for installation** (you'll see progress messages)

6. **Rebuild Solution:**
   - Build → Rebuild Solution (`Ctrl+Shift+B`)

---

## ✅ Method 3: Restore NuGet Packages

If log4net is already in packages.config:

1. **Right-click** on the **Solution** (not the project) in Solution Explorer
   - Look for the solution name at the top of Solution Explorer

2. **Select:** "Restore NuGet Packages"

3. **Wait** for packages to restore

4. **Rebuild Solution:** Build → Rebuild Solution

---

## ✅ Method 4: Manual Installation (If NuGet Fails)

If NuGet doesn't work:

### Step 1: Download log4net
1. Go to: https://www.nuget.org/packages/log4net/1.2.10
2. Click "Download package" button
3. Save the file (it will be `log4net.1.2.10.nupkg`)

### Step 2: Extract the DLL
1. **Rename** the file from `.nupkg` to `.zip`
2. **Extract** the zip file (right-click → Extract All)
3. Navigate to: `lib\net40-full\` folder
4. Copy `log4net.dll`

### Step 3: Copy to Project
1. Navigate to your project folder:
   - `Ekanayake Application\bin\Debug\`
2. **Paste** `log4net.dll` there
3. Also paste to: `Ekanayake Application\bin\Release\` (if it exists)

### Step 4: Rebuild
1. **Rebuild Solution:** Build → Rebuild Solution

---

## 🔍 Verify Installation

After installation, check:

1. **Package folder exists:**
   - `packages\log4net.1.2.10\` should exist

2. **DLL in output folder:**
   - `Ekanayake Application\bin\Debug\log4net.dll` should exist
   - Check file size: should be around 400-500 KB

3. **In Visual Studio:**
   - Open Solution Explorer
   - Expand: `Ekanayake Printers RMS` → References
   - Look for: `log4net` in the list
   - Right-click it → Properties
   - Check: "Copy Local" should be `True`

---

## 🚨 Troubleshooting

### Problem: "Package restore failed"
**Solution:**
- Check internet connection
- Try: Tools → NuGet Package Manager → Package Manager Settings
- Click "Clear All NuGet Cache(s)"
- Try installing again

### Problem: "Version not found"
**Solution:**
- Make sure you're searching for version **1.2.10** (not 2.0.0)
- In NuGet, click "Include prerelease" if needed
- Or use Package Manager Console method

### Problem: "DLL still missing after install"
**Solution:**
1. Clean solution: Build → Clean Solution
2. Rebuild: Build → Rebuild Solution
3. Check "Copy Local" property (see Verify Installation above)
4. Manually copy DLL (Method 4)

### Problem: "Still getting error after install"
**Solution:**
1. Close Visual Studio completely
2. Delete `bin` and `obj` folders in project directory
3. Reopen Visual Studio
4. Restore NuGet Packages
5. Rebuild Solution

---

## 📋 Quick Checklist

- [ ] Opened Visual Studio
- [ ] Right-clicked project → Manage NuGet Packages
- [ ] Searched for "log4net"
- [ ] Selected version 1.2.10
- [ ] Clicked Install
- [ ] Waited for installation
- [ ] Rebuilt Solution (Ctrl+Shift+B)
- [ ] Verified log4net.dll exists in bin\Debug
- [ ] Tested the application

---

## ✅ Success Indicators

You'll know it's fixed when:
- ✅ No error message appears
- ✅ Crystal Reports viewer loads
- ✅ Reports display correctly
- ✅ `log4net.dll` exists in `bin\Debug\`

---

**Follow Method 1 first - it's the easiest and most reliable!**

