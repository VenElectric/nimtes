import std/options
import record,util

type
    LOCK* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        LKDT: ConsumableItem
        SCRI: Option[string]
        ITEX: Option[string]

using
    r:LOCK

func id*(r): string = r.NAME
func model_path*(r): string = r.MODL
func name*(r): Option[string] = r.FNAM
func data*(r): ConsumableItem = r.LKDT
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func quality*(r): float32 = data(r).quality
func uses*(r): uint32 = data(r).uses
func script_name*(r): Option[string] = r.SCRI
func icon_path*(r): Option[string] = r.ITEX

proc `$`*(r): string =
    result = "LOCK"
    result.add `T$`(r)