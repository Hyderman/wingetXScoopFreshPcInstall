Set-ExecutionPolicy ByPass -Scope CurrentUser
# Install scoop
if (!(Get-Command scoop)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")   
}
scoop install git
scoop bucket add main
scoop bucket add extras
scoop bucket add nerd-fonts
scoop install aria2
sudo scoop install -g FiraCode-NF-Mono

$scoopApps = Get-Content -Raw -Path "./scoopPackage.json" | ConvertFrom-Json

# Disable UAC
sudo Set-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
# Disable internet start menu
sudo New-Item -Path "REGISTRY::HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows" -Name "Explorer" 
sudo New-ItemProperty -Path "REGISTRY::HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions"  -Value 1 -PropertyType "DWord"
# Restore old context menu
sudo New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Value "" -Force

$wingetApps = Get-Content -Raw -Path "./wingetPackage.json" | ConvertFrom-Json
$wingetUninstall = Get-Content -Raw -Path "./wingetUninstallBloatware.json" | ConvertFrom-Json

$scoopApps | ForEach-Object {
    scoop install $_
}

$wingetApps | ForEach-Object {
    winget install $_
}

$wingetUninstall | ForEach-Object {
    sudo winget uninstall $_
}

Copy-Item -Path "./Powershell/*" -Destination "$env:USERPROFILE/Documents/PowerShell" -Recurse -Force
Copy-Item -Path "./PowerToys/*" -Destination "$env:USERPROFILE/Documents/PowerToys" -Recurse -Force
Copy-Item -Path "./WindowsTerminal/*" -Destination "$env:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -Recurse -Force
Copy-Item -Path "./nvim/*" -Destination "$env:USERPROFILE\AppData\Local\nvim\." -Recurse -Force

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
pwsh -Command {
    Install-Module -Name Pscx -AllowClobber -Force
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}
