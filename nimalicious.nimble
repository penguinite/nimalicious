# Package

version       = "0.1.0"
author        = "penguinite"
description   = "Open-source malware written in Nim for better Antivirus heuristics."
license       = "MIT"
srcDir        = "src"
binDir        = "build"
bin           = @["gen_ransom","gen_deransom"]

# Dependencies

requires "nim >= 2.0.0"
requires "nimcrypto"