import subprocess
import json

def psCommand(cmd):
    subprocess.run(["powershell", "command", cmd]) 

if __name__ == "__main__":
    with open("scoopPackage.json") as f:
        dirlist = json.load(f)
        for dir in dirlist:
            psCommand(f"scoop install {dir}")