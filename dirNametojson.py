import os
import json


def dirtojson(path):
    with open("scoopPackage.json", "w") as f:
        listSoft = os.listdir(path)
        listSoft.remove("scoop")
        json.dump(listSoft, f)
    

if __name__ == "__main__":
    userProfile = os.environ["USERPROFILE"]
    path = f"{userProfile}\\scoop\\apps"
    dirtojson(path)
