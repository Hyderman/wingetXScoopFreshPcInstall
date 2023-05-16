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
scoop install -g FiraCode-NF-Mono

$scoopApps = Get-Content -Raw -Path "./scoopPackage.json" | ConvertFrom-Json

$scoopApps | ForEach-Object {
    scoop install $_
}
# Admin session
sudo

# Remap capslock to control
$hexified = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};

$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';

New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

# Disable internet start menu
New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows" `
    -Name "Explorer" 
New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
    -Name "DisableSearchBoxSuggestions" `
    -Value 1 `
    -PropertyType "DWord"
# Restore old context menu
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" `
    -Value "" `
    -Force

# Remove "Saved Games folder"
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" `
    -Name "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}"
Remove-Item -Force $Env:USERPROFILE/Saved Games/
# Remove "Favorites folder"
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" `
    -Name "Favorites"
Remove-Item -Force $Env:USERPROFILE/Favorites/

# Remove windows + l shortcut
$LockScreenPath = "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Policies\System"
if (!(Test-Path $LockScreenPath))
{
    Write-Output "add System key"
    New-Item -Path $LockScreenPath.Replace("\System", "") -Name "System" 
}
New-ItemProperty -Path $LockScreenPath `
    -Name "DisableLockWorkstation" `
    -Value 1 `
    -PropertyType "DWord"

# Install apps and package
$wingetApps = Get-Content -Raw -Path "./wingetPackage.json" | ConvertFrom-Json
$wingetUninstall = Get-Content -Raw -Path "./wingetUninstallBloatware.json" | ConvertFrom-Json


$wingetApps | ForEach-Object {
    winget install $_
}

$wingetUninstall | ForEach-Object {
    winget uninstall $_
}

# Remove gameoverlay pop-up
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" `
    -Name "AppCaptureEnabled" `
    -Value 0
    
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" `
    -Name "GameDVR_Enabled" `
    -Value 0

# Move different folder jettings
Copy-Item -Path "./dotfiles/powerShell/*" `
    -Destination "$Env:USERPROFILE/Documents/" `
    -Recurse `
    -Force
Copy-Item -Path "./dotfiles/powerToys/*" `
    -Destination "$Env:USERPROFILE/Documents/" `
    -Recurse `
    -Force
New-Item -ItemType SymbolicLink `
    -Path "$Env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" `
    -Target "$Env:USERPROFILE\dotfiles\windowsTerminal\settings.json"
Copy-Item -Path "./WindowsTerminal/*" `
    -Destination "$Env:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" `
    -Recurse `
    -Force

if (Test-Path -Path "$Env:USERPROFILE/OneDrive")
{
    # Change powershell path to OneDrive
    New-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' Personal `
        -Value '$Env:USERPROFILE\OneDrive\dotfiles\powerShell' `
        -Type ExpandString `
        -Force
    # Create symlink for neovim settings
    New-Item -ItemType SymbolicLink -Path "$Env:USERPROFILE\AppData\Local\nvim" -Target "C:\Users\logan\OneDrive\dotfiles\nvim\nvim"
    New-Item -ItemType SymbolicLink -Path "$Env:USERPROFILE\AppData\Local\nvim" -Target "C:\Users\logan\OneDrive\dotfiles\nvim\nvim"
} else
{
    Copy-Item -Path "./nvim/*" `
        -Destination "$Env:USERPROFILE\AppData\Local\." `
        -Recurse `
        -Force
}

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
    + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
pwsh -Command {
    Install-Module -Name Pscx -AllowClobber -Force
}
