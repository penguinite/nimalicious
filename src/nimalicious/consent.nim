
## MUST BE RAN FOR EVERY BINARY

import std/strutils

const message* = """
The program you are trying to run is malware, that can do real harm to your machine.
This project was started to write open-source malware in Nim so that antiviruses can better fine-tune what \"suspicious\" or \"malicious\" behavior means.

Furthermore, running this program on another person's computer or property without asking for permission is illegal. Even as a joke.
Running this program may result in the following:
$#
"""

const consent* = "If you consent to this program running on your machine then the program authors cannot be held liable or responsible for any damages whatsoever.\nAre you sure you wish to proceed? Knowing that this program may permanently damage your computer"


proc prettyList*(list: seq[string]): string =
  for i in list:
    result.add("\t * " & i & "\n")
  return result

const prettyPrintLimit{.intdefine.}: int = 80

proc prettyPrint*(str: string): string =
  var
    i = 0
    tmp = ""
  for ch in str:
    inc(i)
    if i == prettyPrintLimit:
      if ch != '\n': tmp.add(ch)
      i = 0
      result.add(tmp & "\n")
      tmp = ""
      continue
  
  if tmp.len() > 0:
    result.add(tmp)

  return result


proc askConsent*(name: string, dangers: seq[string], msg: string = message, question: string = consent) =
  echo prettyPrint(msg)
  let input = readLine(stdin)
  
  if input.toLower() != "y" or input.toLower() != "yes":
    echo "Exiting..."
    quit(1)
  


