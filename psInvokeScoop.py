import os
import subprocess
import json


def psCommand(cmd):
    subprocess.run(["powershell", "-Command", cmd])


def configurePs():
    allowRemoteScript = "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
    scoopScript = "irm get.scoop.sh | iex"
    psCommand(allowRemoteScript)
    psCommand(scoopScript)


def scoopBucket():
    cmd = "scoop bucket add main; scoop bucket add extras"
    psCommand(cmd)


def scoopInstall():
    with open("scoopPackage.json") as scoopJson:
        scoopListSoft = json.load(scoopJson)
        for scoopSoft in scoopListSoft:
            psScoopCmd = f"scoop install {scoopSoft}"
            psCommand(psScoopCmd)


def wingetInstall():
    with open("wingetPackage.json") as wingetJson:
        wingetListSoft = json.load(wingetJson)
        for wingetSoft in wingetListSoft:
            psWingetCmd = f"winget install {wingetSoft}"
            psCommand(psWingetCmd)


def psProfile():
    os.replace(
        "Microsoft.PowerShell_profile.ps1",
        "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
    )
    psCommand("Install-Module Pscx -Scope CurrentUser")
    psCommand("Install-Module -Name Terminal-Icons -Repository PSGallery")


if __name__ == "__main__":
    configurePs()
    scoopBucket()
    scoopInstall()
    wingetInstall()
    psProfile()
