import std/options
import record

type
    PROB* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        PBDT: ConsumableItem
        ITEX: Option[string]
        SCRI: Option[string]

using
    r:PROB
    
proc `$`*(r): string = 
    result = "PROB"
    result.add `T$`(r)
