import record,util

type
    STAT* = ref object of TES3Record
        NAME: string
        MODL: string

using 
    r:STAT

proc `$`*(r): string = 
    result = "STAT"
    result.add `T$`(r)