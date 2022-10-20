import subprocess
import json

def psCommand(cmd):
    subprocess.run(["powershell", "-Command", cmd]) 

if __name__ == "__main__":
    with open("scoopPackage.json") as f:
        dirlist = json.load(f)
        for dir in dirlist:
            if dir != "scoop":
                cmd = f"scoop install {dir}"
                psCommand(cmd)