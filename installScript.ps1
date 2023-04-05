winget install Microsoft.PowerShell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
Start-Process pwsh -ArgumentList "-NoExit -File ./powershellScript.ps1"