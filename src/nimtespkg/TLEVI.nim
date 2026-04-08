import std/options
import record,util

type
    Item* = object      
        INAM: string
        INTV: uint16
    LEVI* = ref object of TES3Record
        NAME: string
        DATA: uint32
        NNAM: uint8
        INDX: uint32
        INAM: TagList[Item]

using
    r:LEVI

func id*(r): string = r.NAME
func flags*(r): uint32 = r.DATA
proc calc_each*(r): bool = has_flag(flags(r),0x1)
proc calc_all_levels*(r): bool = has_flag(flags(r),0x2)
func chance_none*(r): uint8 = r.NNAM
func item_count*(r): uint32 = r.INDX
func items*(r): seq[Item] = seq[Item](r.INAM)

func item_name*(r:Item): string = r.INAM
func pc_level*(r:Item): uint16 = r.INTV

proc `$`*(r): string =
    result = "LEVI"
    result.add `T$`(r)