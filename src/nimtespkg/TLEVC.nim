import std/options
import record,util

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
func chance_of_none*(r): uint8 = r.NNAM
proc calc_all_levels*(r): bool = has_flag(r.DATA,0x1)
func creature_count*(r): uint32 =
    result = 0
    if isSome(r.INDX):
        result = get(r.INDX)
func creature_list*(r): seq[Creature] = seq[Creature](r.CNAM)
func creature_name*(r:Creature): string = r.CNAM
func pc_level*(r:Creature): uint16 = r.INTV

proc `$`*(r): string =
    result = "LEVC"
    result.add `T$`(r)