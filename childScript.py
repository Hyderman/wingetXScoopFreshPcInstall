import subprocess
import json

def psCommand(cmd):
    subprocess.run(["pwsh", "-Command", cmd])


def scoopBucket():
    cmd = "scoop bucket add main; scoop bucket add extras"
    psCommand(cmd)


def scoopInstall():
    with open("scoopPackage.json") as scoopJson:
        scoopListSoft = json.load(scoopJson)
        for soft in scoopListSoft:
            psScoopCmd = f"scoop install {soft}"
            psCommand(psScoopCmd)


def wingetInstall():
    with open("wingetPackage.json") as wingetJson:
        wingetListSoft = json.load(wingetJson)
        for soft in wingetListSoft:
            psWingetCmd = f"winget install {soft} --force"
            psCommand(psWingetCmd)


if __name__ == "__main__":
    scoopBucket()
    scoopInstall()
    wingetInstall()