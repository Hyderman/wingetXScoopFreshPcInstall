Set-ExecutionPolicy ByPass -Scope CurrentUser
# Install scoop
if (!(Get-Command scoop))
{
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
        + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")   
}

scoop install aria2
scoop install git
scoop bucket add main
scoop bucket add extras
scoop bucket add nerd-fonts
sudo scoop install -g FiraCode-NF-Mono

$scoopApps = Get-Content -Raw -Path "./scoopPackage.json" | ConvertFrom-Json

# Disable UAC
# sudo Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
#     -Name "ConsentPromptBehaviorAdmin" `
#     -Value 0
# Disable internet start menu
sudo New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows" `
    -Name "Explorer" 
sudo New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
    -Name "DisableSearchBoxSuggestions" `
    -Value 1 `
    -PropertyType "DWord"
# Restore old context menu
sudo New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" `
    -Value "" `
    -Force

# Remove "Saved Games folder"
sudo Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" `
    -Name "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}"
Remove-Item -Force ~/Saved Games/
# Remove "Favorites folder"
sudo Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" `
    -Name "Favorites"
Remove-Item -Force ~/Favorites/

# Remove windows + l shortcut
$LockScreenPath = "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Policies\System"
if  (!(Test-Path $LockScreenPath))
{
    Write-Output "add System key"
    sudo New-Item -Path $LockScreenPath.Replace("\System", "") -Name "System" 
}
sudo New-ItemProperty -Path $LockScreenPath `
    -Name "DisableLockWorkstation" `
    -Value 1 `
    -PropertyType "DWord"

# Install apps and package
$wingetApps = Get-Content -Raw -Path "./wingetPackage.json" | ConvertFrom-Json
$wingetUninstall = Get-Content -Raw -Path "./wingetUninstallBloatware.json" | ConvertFrom-Json

$scoopApps | ForEach-Object {
    scoop install $_
}

$wingetApps | ForEach-Object {
    sudo winget install $_
}

$wingetUninstall | ForEach-Object {
    sudo sudo winget uninstall $_
}

# Remove gameoverlay pop-up
sudo Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" `
    -Name "AppCaptureEnabled" `
    -Value 0
    
sudo Set-ItemProperty -Path "HKCU:\System\GameConfigStore" `
    -Name "GameDVR_Enabled" `
    -Value 0

# Move different folder jettings

Copy-Item -Path "./dotfiles/powerShell/*" `
    -Destination "$env:USERPROFILE/Documents/" `
    -Recurse `
    -Force
Copy-Item -Path "./dotfiles/powerToys/*" `
    -Destination "$env:USERPROFILE/Documents/" `
    -Recurse `
    -Force
Copy-Item -Path "./WindowsTerminal/*" `
    -Destination "$env:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" `
    -Recurse `
    -Force
Copy-Item -Path "./nvim/*" `
    -Destination "$env:USERPROFILE\AppData\Local\." `
    -Recurse `
    -Force
Copy-Item -Path "./nvim/*" `
    -Destination "$env:USERPROFILE\AppData\Local\." `
    -Recurse `
    -Force

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
    + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
pwsh -Command {
    Install-Module -Name Pscx -AllowClobber -Force
    # Install-Module -Name Terminal-Icons -Repository PSGallery -Force # to slow
}
