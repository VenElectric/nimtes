import std/options
import record

type
    BSGN* = ref object of TES3Record
        NAME: string
        FNAM: Option[string]
        NPCS: seq[string]
        TNAM: Option[string]
        DESC: Option[string]

func id*(r:BSGN): string = r.NAME
func name*(r:BSGN): Option[string] = r.FNAM
func spells*(r:BSGN): seq[string] = r.NPCS
func texturePath*(r:BSGN): Option[string] = r.TNAM
func desc*(r:BSGN): Option[string] = r.DESC

proc `$`*(r:BSGN): string =
    result = "BSGN"
    result.add `T$`(r)