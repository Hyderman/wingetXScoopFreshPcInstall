import os
import json

def dirtojson(path):
    with open('scoopPackage.json', 'w') as f:
        json.dump(os.listdir(path), f)

if __name__ == "__main__":
    userProfile = os.environ['USERPROFILE']
    path = f"{userProfile}\\scoop\\apps"
    dirtojson(path)