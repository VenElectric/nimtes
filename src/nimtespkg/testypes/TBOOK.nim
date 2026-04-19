import std/options
import record

type
    BookData* = ref object of DataField
        weight: float32
        value: uint32
        flags: uint32
        skill_id: int32
        enchant_pts: uint32
    BOOK* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        BKDT: BookData
        SCRI: Option[string]
        ITEX: Option[string]
        TEXT: Option[string]
        ENAM: Option[string]

using 
    r:BOOK

func id*(r): string = stripNull(r.NAME)
func modelPath*(r): string = stripNull(r.MODL)
func name*(r): Option[string] = r.FNAM
func bookText*(r): Option[string] = r.TEXT
func scriptName*(r): Option[string] = r.SCRI
func iconPath*(r): Option[string] = r.ITEX
func enchantment*(r): Option[string] = r.ENAM
func data(r): BookData = r.BKDT
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func skillId*(r): int32 = r.BKDT.skill_id
func enchantPoints*(r): uint32 = data(r).enchant_pts
proc isScroll*(r): bool = hasFlag(data(r).flags,0x1)

proc `$`*(r: BOOK): string =
    result = "BOOK"
    result.add `T$`(r)

