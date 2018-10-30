import sys
import shutil
import os

# grab repo name
apiKey = sys.argv[0]
# ios folder path
repoPath = os.path.join(sys.path[0])

def applySecret(secret, basicPath):
    for path, subdirs, files in os.walk(basicPath):
        for name in files:
            with open(os.path.join(path, name), 'r') as file :
                filedata = file.read()

            # Replace the target string
            filedata = filedata.replace('API_KEY', secret)

            # Write the file out again
            with open(os.path.join(path, name), 'w') as file:
                file.write(filedata)

applySecret(apiKey, repoPath)
