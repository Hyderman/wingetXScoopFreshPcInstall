Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
if (!(Get-Command scoop)) {
    irm get.scoop.sh | iex
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")   
}

scoop bucket add main
scoop bucket add extras
scoop install aria2

$scoopApps = Get-Content -Raw -Path ./scoopPackage.json | ConvertFrom-Json
$wingetApps = Get-Content -Raw -Path ./wingetPackage.json | ConvertFrom-Json

scoop bucket add main
scoop bucket add extras

$scoopApps | ForEach-Object {
    scoop install $_
}

$wingetApps | ForEach-Object {
    winget install $_
}

Copy-Item -Path ./Powershell/* -Destination $env:USERPROFILE/Documents/PowerShell -Recurse
Copy-Item -Path ./PowerToys/* -Destination $env:USERPROFILE/Documents/PowerToys -Recurse
Copy-Item -Path ./WindowsTerminal/* -Destination $env:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState -Recurse

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
pwsh -Command {
    Install-Module -Name Pscx -AllowClobber -Force
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}