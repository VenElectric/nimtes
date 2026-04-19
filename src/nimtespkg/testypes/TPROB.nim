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

func id*(r): string = r.NAME
func modelPath*(r): string = r.MODL
func iconPath*(r): Option[string] = r.ITEX
func scriptName*(r): Option[string] = r.SCRI
    
proc `$`*(r): string = 
    result = "PROB"
    result.add `T$`(r)
