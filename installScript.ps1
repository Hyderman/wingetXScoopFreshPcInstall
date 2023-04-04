winget install powershell --force
pwsh -Command {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    scoop install aria2
    scoop install python
    python childScript.py
    Copy-Item -Path $env:USERPROFILE\Programmation\ScoopInstallMultiplePackage\Microsoft.PowerShell_profile.ps1 -Destination $env:USERPROFILE/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 
    Install-Module Pscx -Scope CurrentUser
    Install-Module -Name Terminal-Icons -Repository PSGallery
}