import std/options
import record

type
    RepairData* = ref object of DataField # because uses and quality are swapped for REPA.RIDT
        weight*: float32
        value*: uint32
        uses*:uint32
        quality*:float32
    REPA* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        RIDT: RepairData
        ITEX: Option[string]
        SCRI: Option[string]

using
    r:REPA

func name*(r): string = stripNull(r.NAME)
func modelPath*(r): string = stripNull(r.MODL)
func data*(r): RepairData = r.RIDT

proc `$`*(r): string =
    result = "REPA"
    result.add `T$`(r)