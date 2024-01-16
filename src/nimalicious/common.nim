const  prettyPrintLimit{.intdefine.}: int = 80


proc prettyList*(list: seq[string]): string =
  for i in list:
    result.add("      * " & i & "\n")
  result = result[0..^2]
  return result

proc prettyPrint*(str: string): string =
  var i = 0
  result.add("\n")
  for ch in str:
    inc(i)
    if ch == '\n':
      result.add("\n")
      i = 0
      continue

    if ch == ' ' and i >= prettyPrintLimit:
      result.add("\n")
      i = 0
      continue
    result.add(ch)
  
  if result[high(result)] != '\n': result.add("\n")
  return result