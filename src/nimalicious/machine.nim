when defined(windows):
  # I feel dirty for doing this.
  {.emit: "#include <sysinfoapi.h>".} 
  {.emit: "MEMORYSTATUSEX _NM_memStatus;".}
  {.emit: "_NM_memStatus.dwLength = sizeof(_NM_memStatus);".}

  type
    MEMORYSTATUSEX* = object
      dwLength*: int32
      ullTotalPhys*: int64
  let status {.header: "<sysinfoapi.h>", importc: "_NM_memStatus", nodecl.}: MEMORYSTATUSEX
  proc globalMemoryStatusEx(status: ptr MEMORYSTATUSEX) {.header: "<sysinfoapi.h>", importc: "GlobalMemoryStatusEx", nodecl.}
  proc getFreeRAM*(): int =
    globalMemoryStatusEx(addr(status))
    return status.ullTotalPhys
else:
  let SC_PHYS_PAGES {.header: "<unistd.h>", importc:"_SC_PHYS_PAGES", nodecl.}: cint
  let SC_PAGE_SIZE {.header: "<unistd.h>", importc:"_SC_PAGE_SIZE", nodecl.}: cint
  proc sysconf(shit: cint): clong {.header: "<unistd.h>", importc: "sysconf".}
  proc getFreeRAM*(): int =
    return sysconf(SC_PHYS_PAGES) * sysconf(SC_PAGE_SIZE)