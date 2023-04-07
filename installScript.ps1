Set-ExecutionPolicy ByPass -Scope CurrentUser
if (!(Get-Command scoop)) {
    irm get.scoop.sh | iex
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")   
}
scoop install git
scoop bucket add main
scoop bucket add extras
scoop bucket add nerd-fonts
scoop install aria2
sudo scoop install -g FiraCode-NF-Mono

$scoopApps = Get-Content -Raw -Path ./scoopPackage.json | ConvertFrom-Json

# Disable UAC
sudo Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

$wingetApps = Get-Content -Raw -Path ./wingetPackage.json | ConvertFrom-Json
$wingetUninstall = Get-Content -Raw -Path ./wingetUninstallBloatware.json | ConvertFrom-Json

$scoopApps | ForEach-Object {
    scoop install $_
}

$wingetApps | ForEach-Object {
    winget install $_
}

$wingetUninstall | ForEach-Object {
    sudo winget uninstall $_
}

Copy-Item -Path ./Powershell/* -Destination $env:USERPROFILE/Documents/PowerShell -Recurse -Force
Copy-Item -Path ./PowerToys/* -Destination $env:USERPROFILE/Documents/PowerToys -Recurse -Force
Copy-Item -Path ./WindowsTerminal/* -Destination $env:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState -Recurse -Force

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
pwsh -Command {
    Install-Module -Name Pscx -AllowClobber -Force
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}

# Restore old right click context menu
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve