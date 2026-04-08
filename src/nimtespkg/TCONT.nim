import std/options
import record, util

type
    CONT* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        CNDT: float32
        FLAG: uint32
        NPCO: seq[CarriedObject[int32]]
        SCRI: Option[string]

func id*(r: CONT): string = stripNull(r.NAME)
func model_path*(r: CONT): string = stripNull(r.MODL)
func name*(r: CONT): Option[string] = r.FNAM
func capacity*(r: CONT): float32 = r.CNDT
proc organic*(r: CONT): bool = has_flag(r.FLAG, 0x1)
proc respawns*(r: CONT): bool = has_flag(r.FLAG, 0x2)
func items*(r: CONT): seq[CarriedObject[int32]] = r.NPCO
func script_name*(r: CONT): Option[string] = r.SCRI

proc `$`*(r: CONT): string =
    result = "CONT"
    result.add `T$`(r)

export item_name,item_count