# PowerShell Script to Download and Install log4net 1.2.10
# Run this script in PowerShell (Right-click → Run with PowerShell)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "log4net 1.2.10 Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectRoot = Split-Path -Parent $PSScriptRoot
$packagesDir = Join-Path $projectRoot "packages"
$log4netDir = Join-Path $packagesDir "log4net.1.2.10"
$libDir = Join-Path $log4netDir "lib\net40-full"
$binDebug = Join-Path $projectRoot "Ekanayake Application\bin\Debug"
$binRelease = Join-Path $projectRoot "Ekanayake Application\bin\Release"

Write-Host "Step 1: Creating directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $packagesDir | Out-Null
New-Item -ItemType Directory -Force -Path $log4netDir | Out-Null
New-Item -ItemType Directory -Force -Path $libDir | Out-Null
New-Item -ItemType Directory -Force -Path $binDebug | Out-Null
if (Test-Path (Split-Path $binRelease)) {
    New-Item -ItemType Directory -Force -Path $binRelease | Out-Null
}

Write-Host "Step 2: Downloading log4net 1.2.10..." -ForegroundColor Yellow
$downloadUrl = "https://www.nuget.org/api/v2/package/log4net/1.2.10"
$tempFile = Join-Path $env:TEMP "log4net.1.2.10.nupkg"

try {
    Write-Host "Downloading from: $downloadUrl" -ForegroundColor Gray
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -UseBasicParsing
    Write-Host "Download complete!" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to download log4net" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download manually from:" -ForegroundColor Yellow
    Write-Host "https://www.nuget.org/packages/log4net/1.2.10" -ForegroundColor Cyan
    Write-Host "Extract the .nupkg file (rename to .zip) and copy log4net.dll from lib\net40-full\" -ForegroundColor Yellow
    exit 1
}

Write-Host "Step 3: Extracting package..." -ForegroundColor Yellow
$extractDir = Join-Path $env:TEMP "log4net_extract"
if (Test-Path $extractDir) {
    Remove-Item $extractDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $extractDir | Out-Null

# Rename .nupkg to .zip and extract
$zipFile = Join-Path $env:TEMP "log4net.1.2.10.zip"
Copy-Item $tempFile $zipFile
Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

Write-Host "Step 4: Copying log4net.dll..." -ForegroundColor Yellow
$sourceDll = Join-Path $extractDir "lib\net40-full\log4net.dll"

if (Test-Path $sourceDll) {
    # Copy to packages folder
    Copy-Item $sourceDll $libDir -Force
    Write-Host "  ✓ Copied to packages folder" -ForegroundColor Green
    
    # Copy to bin\Debug
    Copy-Item $sourceDll $binDebug -Force
    Write-Host "  ✓ Copied to bin\Debug" -ForegroundColor Green
    
    # Copy to bin\Release if it exists
    if (Test-Path (Split-Path $binRelease)) {
        Copy-Item $sourceDll $binRelease -Force
        Write-Host "  ✓ Copied to bin\Release" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "SUCCESS! log4net.dll installed!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Open Visual Studio" -ForegroundColor White
    Write-Host "2. Rebuild Solution (Ctrl+Shift+B)" -ForegroundColor White
    Write-Host "3. Run the application" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "ERROR: log4net.dll not found in extracted package" -ForegroundColor Red
    Write-Host "Please extract manually and copy log4net.dll" -ForegroundColor Yellow
    exit 1
}

# Cleanup
Remove-Item $tempFile -ErrorAction SilentlyContinue
Remove-Item $zipFile -ErrorAction SilentlyContinue
Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

