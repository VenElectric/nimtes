import std/[options,sugar]
import record


type
    ArmorKind* = enum 
        Helmet,
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
        NAME {.dtag("ID").}: string
        MODL {.dtag("Model Path").}: string
        FNAM {.dtag("Name").}: string
        SCRI {.dtag("Script Name").}: Option[string]
        AODT {.dtag("Armor Data").}: ArmorData
        ITEX {.dtag("Icon Path").}: Option[string]
        INDX {.dtag("Biped Objects").}: TagList[BipedObject]
        ENAM {.dtag("Enchantment Name").}: Option[string]

using 
    r:ARMO

func id*(r): string = stripNull(r.NAME)
func modelPath*(r): string = stripNull(r.MODL)
func name*(r): string = stripNull(r.FNAM)
func scriptName*(r): Option[string] = r.SCRI

func data*(r): ArmorData = r.AODT
func armorKind*(r): ArmorKind = ArmorKind(data(r).kind)
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func health*(r): uint32 = data(r).health
func enchantPoints*(r): uint32 = data(r).enchant_pts
func rating*(r): uint32 = data(r).armor_rating

func iconPath*(r): Option[string] = r.ITEX
func enchantName*(r): Option[string] = r.ENAM
func bodyData*(r): seq[BipedObject] = seq[BipedObject](r.INDX)
proc listItemSlots*(r): seq[ItemSlot] = 
    result = collect(newSeq):
        for d in bodyData(r):
            itemSlot(d)


proc `$`*(r:ARMO): string =
    result = "ARMO"
    result.add `T$`(r)

export itemSlot,maleName,femaleName,ItemSlot