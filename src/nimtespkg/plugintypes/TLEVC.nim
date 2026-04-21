import std/options
import record

type
    Creature* = object
        CNAM: string
        INTV: uint16
    LEVC* = ref object of TES3Record
        NAME: string
        DATA: uint32
        NNAM: uint8
        INDX: Option[uint32]
        CNAM: TagList[Creature]

using
    r:LEVC

func id*(r): string = r.NAME
func chanceOfNone*(r): uint8 = r.NNAM
proc calcAllLevels*(r): bool = hasFlag(r.DATA,0x1)
func creatureCount*(r): uint32 =
    result = 0
    if isSome(r.INDX):
        result = get(r.INDX)
func creatureList*(r): seq[Creature] = seq[Creature](r.CNAM)
func creatureName*(r:Creature): string = r.CNAM
func pcLevel*(r:Creature): uint16 = r.INTV

proc `$`*(r): string =
    result = "LEVC"
    result.add `T$`(r)