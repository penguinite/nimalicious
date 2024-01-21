# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import std/[base64, os, strutils]
import nimalicious/[consent, crypto]
import nimcrypto

askConsent(
  "gen_deransom",
  @["You might risk corrupting some files if they were not encrypted."]
)

echo "You need the encryption key in order to continue:"
stdout.write("\n> ")
let key = readLine(stdin)

when defined(debug):
  # Make a dummy file specifically to be encrypted and decrypted.
  proc findFiles*(): seq[string] =
    try:
      writeFile("dummy_file.txt", "Hello World!")
      return @["dummy_file.txt"]
    except:
      # Return nothing as a safe measure.
      return @[]
else:
  # Search *everywhere* in the user's home directory.
  proc findFiles*(): seq[string] =
    for kind, path in walkDir(dir = getHomeDir(), skipSpecial = true):
      if kind == pcFile: result.add(path)
    return result

# Initialize encryption.
var algo: ECB[aes256]
algo.init(key)

let files = findFiles()
var i = 0
for file in files:
  inc(i)
  echo "Trying to decrypt ", i, " file out of ", len(files), " files. (", file, ")"
  var contents = readFile(file)
  if not contents.startsWith("---RANSOMWARE-ENCRYPTED---\n"):
    echo "Skipping, since it might not be encrypted anyway."
    continue
  contents = contents.split("---RANSOMWARE-ENCRYPTED---\n")[1] 
  var tmp = ""
  algo.decrypt(contents, tmp)
  tmp = decode(tmp)
  writeFile(file, tmp)

echo "Good luck... :-)"
algo.clear()
quit(0)
