import std/[sysrand, base64, strutils]

proc genKey*(limit: int = 256): string =
  for ch in encode(urandom(limit)):
    result.add(ch)
    if len(result) >= limit:
      result = result[0..limit - 1]
      break
  return result

proc autoPad*(input: string, segmentSize: int = 256): seq[string] =
  var
    i = 0
    tmp = ""

  for ch in input:
    tmp.add(ch)
    inc i
    if len(tmp) == segmentSize:
      result.add(tmp)
      tmp = ""
  
  if len(tmp) > 0: result.add(tmp)
  
  # Re-size first/last segment if its too small
  if result[high(result)].len() < segmentSize:
    let diff = segmentSize - result[high(result)].len()
    for i in 0..diff - 1:
      result[high(result)].add(' ')
  return result

proc autoPadStr*(input: string, segmentSize: int = 256): string =
  return autoPad(input, segmentSize).join

