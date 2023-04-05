Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
if (!(Get-Command scoop)) {
    irm get.scoop.sh | iex
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")   
}
scoop install aria2
scoop install python
python childScript.py
Copy-Item -Path ./Powershell/* -Destination $env:USERPROFILE/Documents/PowerShell -Recurse
Copy-Item -Path ./PowerToys/* -Destination $env:USERPROFILE/Documents/PowerToys -Recurse
Copy-Item -Path ./WindowsTerminal/* -Destination $env:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState -Recurse
Install-Module -Name Pscx -AllowClobber -Confirm:$false
Install-Module -Name Terminal-Icons -Repository PSGallery -Confirm:$false