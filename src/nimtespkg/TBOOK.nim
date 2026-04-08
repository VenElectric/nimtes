import std/options
import record, util

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
func model_name*(r): string = stripNull(r.MODL)
func name*(r): string = unwrap_str(r.FNAM)
func book_text*(r): Option[string] = r.TEXT
func script_name*(r): Option[string] = r.SCRI
func icon_path*(r): Option[string] = r.ITEX
func enchantment*(r): Option[string] = r.ENAM
func data(r): BookData = r.BKDT
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func skill_id*(r): int32 = r.BKDT.skill_id
func enchant_points*(r): uint32 = data(r).enchant_pts
proc is_scroll*(r): bool = has_flag(data(r).flags,0x1)

proc `$`*(r: BOOK): string =
    result = "BOOK"
    result.add `T$`(r)

