sudo Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "ConsentPromptBehaviorAdmin" `
    -Value 0
    
$wingetUninstall = Get-Content -Raw -Path "./wingetUninstallBloatware.json" | ConvertFrom-Json

$wingetUninstall | ForEach-Object {
    sudo winget uninstall $_
}