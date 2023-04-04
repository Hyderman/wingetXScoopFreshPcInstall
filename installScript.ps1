winget install Microsoft.PowerShell --force
pwsh -Command {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    if (!(Get-Command scoop)) {
        irm get.scoop.sh | iex
    }
    scoop install aria2
    scoop install python
    python childScript.py
    Copy-Item -Path .\Microsoft.PowerShell_profile.ps1 -Destination $env:USERPROFILE/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 
    Install-Module -Name Pscx -AllowClobber
    Install-Module -Name Terminal-Icons -Repository PSGallery
}