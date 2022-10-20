import os
import json

def dirtojson(path):
    with open('scoopPackage.json', 'w') as f:
        json.dump(os.listdir(path), f)

if __name__ == "__main__":
    path = "C:\\Users\\%USERNAME%\\scoop\\apps"
    dirtojson(path)