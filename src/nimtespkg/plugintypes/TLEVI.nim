import record

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
proc calcEach*(r): bool = hasFlag(flags(r),0x1)
proc calcAllLevels*(r): bool = hasFlag(flags(r),0x2)
func chanceNone*(r): uint8 = r.NNAM
func itemCount*(r): uint32 = r.INDX
func items*(r): seq[Item] = seq[Item](r.INAM)

func itemName*(r:Item): string = r.INAM
func pcLevel*(r:Item): uint16 = r.INTV

proc `$`*(r): string =
    result = "LEVI"
    result.add `T$`(r)