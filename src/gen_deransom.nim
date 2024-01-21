# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import std/[base64, strutils]
import nimalicious/[consent, crypto, files]
import nimcrypto

askConsent(
  "gen_deransom",
  @["You might risk corrupting some files if they were not encrypted."]
)

echo "You need the encryption key in order to continue:"
stdout.write("\n> ")
let key = readLine(stdin)

# Initialize encryption.
var algo: ECB[aes256]
algo.init(key)

let filesx = findFiles()
var i = 0
for file in filesx:
  inc(i)
  echo "Trying to decrypt ", i, " file out of ", len(filesx), " files. (", file, ")"
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
