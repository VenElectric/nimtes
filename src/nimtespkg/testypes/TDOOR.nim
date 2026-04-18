import std/options
import record

type
    DOOR* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        SCRI: Option[string]
        SNAM: Option[string]
        ANAM: Option[string]

using
    r:DOOR

func id*(r): string = r.NAME
func model_path*(r): string = r.MODL
func name*(r): Option[string] = r.FNAM
func script_name*(r): Option[string] = r.SCRI
func open_sound*(r): Option[string] = r.SNAM
func close_sound*(r): Option[string] = r.ANAM

proc `$`*(r): string =
    result = "DOOR"
    result.add `T$`(r)