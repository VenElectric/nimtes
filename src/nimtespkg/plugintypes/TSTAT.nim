import record

type
    STAT* = ref object of TES3Record
        NAME: string
        MODL: string

using 
    r:STAT

func id*(r): string = stripNull(r.NAME)
func modelPath*(r): string = stripNull(r.MODL)

proc `$`*(r): string = 
    result = "STAT"
    result.add `T$`(r)