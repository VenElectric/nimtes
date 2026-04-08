import std/[options]
import record,util

type
    ArmorKind* = enum 
        Helmet = 0,
        Cuirass,
        LeftPauldron = "Left Pauldron",
        RightPauldron = "Right Pauldron",
        Greaves,
        Boots,
        LeftGauntlet = "Left Gauntlet",
        RightGauntlet = "Right Gauntlet",
        Shield,
        LeftBracer = "Left Bracer",
        RightBracer = "Right Bracer"
    ArmorData* = ref object of DataField
        kind: uint32
        weight: float32
        value: uint32
        health: uint32
        enchant_pts: uint32
        armor_rating: uint32
    ARMO* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: string
        SCRI: Option[string]
        AODT: ArmorData
        ITEX: Option[string]
        INDX: TagList[BipedObject]
        ENAM: Option[string]

using 
    r:ARMO

func id*(r): string = stripNull(r.NAME)
func model_path*(r): string = stripNull(r.MODL)
func name*(r): string = stripNull(r.FNAM)
func script_name*(r): string = 
    if isSome(r.SCRI):
        stripNull(get(r.SCRI))
    else:
        ""
func data*(r): ArmorData = r.AODT
func icon_path*(r): string = 
    if isSome(r.ITEX):
        stripNull(get(r.ITEX))
    else:
        ""
func enchant_name*(r): string = 
    if isSome(r.ENAM):
        stripNull(get(r.ENAM))
    else:
        ""
func body_data*(r): seq[BipedObject] = seq[BipedObject](r.INDX)
func armor_kind*(r): ArmorKind = ArmorKind(data(r).kind)
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func health*(r): uint32 = data(r).health
func enchant_points*(r): uint32 = data(r).enchant_pts
func rating*(r): uint32 = data(r).armor_rating


proc `$`*(r:ARMO): string =
    result = "ARMO"
    result.add `T$`(r)

export item_slot,male_name,female_name,ItemSlot