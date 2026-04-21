import std/[options]
import record

type
    ACTI* = ref object of TES3Record
        NAME {.dtag("ID").}: string
        MODL {.dtag("Model Path").}: Option[string]
        FNAM {.dtag("Name").}: Option[string]
        SCRI {.dtag("Script Name").}: Option[string]

using
    r: ACTI

func id*(r): string = stripNull(r.NAME)
func modelPath*(r):Option[string] = r.MODL
func name*(r): Option[string] = r.FNAM
func scriptName*(r): Option[string] = r.SCRI


proc `$`*(r): string =
    result = "ACTI"
    result.add `T$`(r)
