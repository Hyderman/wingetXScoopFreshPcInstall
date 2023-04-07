$wingetApps = Get-Content -Raw -Path ./wingetPackage.json | ConvertFrom-Json

$wingetApps | ForEach-Object {
    winget install $_
}