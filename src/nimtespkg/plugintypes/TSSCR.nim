import std/options
import record

type
    SSCR* = ref object of TES3Record
        DATA: string
        NAME: Option[string]

using 
    r:SSCR

proc `$`*(r): string = 
    result = "SSCR"
    result.add `T$`(r)