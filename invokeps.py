import subprocess
import json

def psCommand(cmd):
    subprocess.run(["powershell", "-Command", cmd], capture_output=True) 

if __name__ == "__main__":
    with open("scoopPackage.json") as f:
        dirlist = json.load(f)
        for dir in dirlist:
            cmd = f"scoop install {dir}"
            psCommand(cmd)