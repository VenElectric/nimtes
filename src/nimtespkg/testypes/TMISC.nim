import std/options
import record

type
    MiscData* = ref object of DataField
        weight: float32
        value: uint32
        flags: uint32
    MISC* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        MCDT: MiscData
        SCRI: Option[string]
        ITEX: Option[string]

using
    r:MISC

func id*(r): string = r.NAME
func model_path*(r): string = r.MODL
func name*(r): Option[string] = r.FNAM
func data(r):MiscData = r.MCDT
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func is_key*(r): bool = data(r).flags == 1
func script_name*(r): Option[string] = r.SCRI
func icon_path*(r): Option[string] = r.ITEX

proc `$`*(r): string =
    result = "MISC"
    result.add `T$`(r)