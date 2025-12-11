# PowerShell script to install log4net via NuGet
# Run this script in Package Manager Console or manually install via NuGet

Write-Host "Installing log4net package for Crystal Reports..." -ForegroundColor Yellow

# Method 1: Using NuGet CLI (if available)
if (Get-Command nuget -ErrorAction SilentlyContinue) {
    Write-Host "Using NuGet CLI..." -ForegroundColor Green
    nuget install log4net -Version 1.2.10 -OutputDirectory packages
} else {
    Write-Host "NuGet CLI not found. Please install via Visual Studio:" -ForegroundColor Yellow
    Write-Host "1. Right-click project -> Manage NuGet Packages" -ForegroundColor Cyan
    Write-Host "2. Search for 'log4net'" -ForegroundColor Cyan
    Write-Host "3. Install version 1.2.10" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or use Package Manager Console:" -ForegroundColor Yellow
    Write-Host "Install-Package log4net -Version 1.2.10" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "After installation, rebuild the solution!" -ForegroundColor Green

