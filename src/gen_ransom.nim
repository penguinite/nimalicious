# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import nimalicious/[consent, crypto]

askConsent(
  "gen_random",
  ransomwareDangers
)

var algo: Algo = init(Ransomware)

echo algo.encrypt("Hello World!")