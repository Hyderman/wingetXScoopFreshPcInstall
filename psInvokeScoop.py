import subprocess
import json

def psCommandPackage(cmd):
    subprocess.run(["powershell", "-Command", cmd]) 


def psCommandBucket():
    cmd = "scoop bucket add main; scoop bucket add extras"
    subprocess.run(["powershell", "-Command", cmd]) 


if __name__ == "__main__":
    psCommandBucket()
    with open("scoopPackage.json") as f:
        dirlist = json.load(f)
        for dir in dirlist:
            if dir != "scoop":
                cmd = f"scoop install {dir}"
                psCommandPackage(cmd)