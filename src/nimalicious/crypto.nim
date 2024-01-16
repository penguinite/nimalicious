import nimcrypto, std/[sysrand, base64]

type
  Usecase* = enum
    Ransomware, # Use AES256 encryption and stuff.
  
  Algo* = object
    case use*: Usecase
    of Ransomware:
      rnsk*: CBC[aes256]
    key: string

proc genKey*(use: Usecase): string =
  var limit: int
  case use:
  of Ransomware:
    limit = 256

  for bite in urandom(limit):
    result.add(encode($bite))
    if len(result) >= limit:
      var cut = len(result)
      if not cut <= 0:
        result = result[0..^cut]
      break

  return result

proc init*(use: Usecase, key: string = genKey(use)): Algo =
  case use:
  of Ransomware:
    result = Algo(use: Ransomware)
    result.rnsk.init(key)
    result.key = key


proc encrypt*(algo: Algo, str: string): string =
  case algo.use:
  of Ransomware:
    algo.rnsk.encrypt(str, result)
  return result

proc decrypt*(algo: Algo, str: string): string =
  case algo.use:
  of Ransomware:
    algo.rnsk.decrypt(str, result)
  return result

proc clear*(algo: Algo): Algo =
  result = algo
  case result.use:
  of Ransomware:
    result.rnsk.clear()
  return result