
## MUST BE RAN FOR EVERY BINARY

import std/[os, times]
from strutils import `%`

const
  consentPattern{.strdefine.} = "Yes, I consent."
  message = "The program you are trying to run is malware, that can do real harm to your machine. This project was started to write open-source malware in Nim so that antiviruses can better fine-tune what \"suspicious\" or \"malicious\" behavior means. "
  consent = "\nRunning this program on another person's computer or property without asking for their consent is illegal, even as a joke or a prank. If you consent to this program running on your machine then the program authors cannot be held liable or responsible for any damages whatsoever. Are you sure you wish to proceed? Knowing that this program may permanently damage your computer. "

  prettyPrintLimit{.intdefine.}: int = 80
  ransomwareDangers* = @[
      "Files on your machine will be made inaccessible (via encryption)",
      "You face high risk of losing important and valuable data permanently",
      "You face high risk of destroying your operating system"
    ]

  consentDirs = @[
    getHomeDir() & "Documents", # Save to the user's Document folder.
    getHomeDir() & "Downloads", # Save to the user's Download folder.
    getHomeDir() & "Desktop", # Save to the user's Download folder.
    getHomeDir() & ".consent", # Save to a special consent folder
    getConfigDir(), # Save to the user's config folder
    getTempDir(), # Save to a temporary directory.
  ]

proc prettyList*(list: seq[string]): string =
  result.add("\n")
  for i in list:
    result.add("\t * " & i & "\n")
  return result

proc prettyPrint*(str: string): string =
  var i = 0
  for ch in str:
    inc(i)
    if ch == ' ' and i >= prettyPrintLimit:
      result.add("\n")
      i = 0
      continue
    result.add(ch)
  return result


proc askConsent*(name: string, dangers: seq[string]) =
  proc print(str: string) = stdout.write(prettyPrint(str))
  proc printList(dng: seq[string]) = stdout.write(prettyList(dng) & "\n")
  print(message)
  print("Running this program may result in the following:")
  printList(dangers)
  print(consent)
  print("Type \"" & consentPattern & "\" to consent.")
  stdout.write("\n> ")
  let input = readLine(stdin)
  
  if input != consentPattern:
    print "Exiting..."
    quit(1)

  print "Saving consent with time and date."

  var contents = "\nThis user (more specifically, the user who has a home directory in $#) has consented and allowed the \"$#\" program to run on their machine willingly.\nThis consent has taken place in Date: \"$#\", Time: \"$#\"\n\nThe original message, prior to the user's consent is as follows:\n$#\n$#\n$#\n\nThe user has typed \"$#\" and thus consented to the malicious program running on their machine.\nAs explained, prior to the consent, all program authors are not liable for any damages nor are they\nresponsible for any damages if you consent to the program running on your machine." % [getHomeDir(), name, getDateStr(), $getTime(), prettyPrint(message), prettyList(dangers), prettyPrint(consent), consentPattern]

  for dir in consentDirs:
    if dirExists(dir):
      createDir(dir)
    try:
      writeFile(dir & "/" & name & "_consent_form.txt", contents)
    except:
      print "Failed to write consent. Revoking consent and exiting quietly."
      quit(1)