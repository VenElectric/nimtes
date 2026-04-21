import std/options
import record

type
    ClothingData* = ref object of DataField
        kind:uint32
        weight: float32
        value: uint16
        enchant_pts: uint16
    CLOT* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        CTDT: ClothingData
        SCRI: Option[string]
        ITEX: Option[string]
        INDX: TagList[BipedObject]
        ENAM: Option[string]

func id*(r:CLOT): string = r.NAME
func modelPath*(r:CLOT): string = r.MODL
func name*(r:CLOT): Option[string] = r.FNAM
func data*(r:CLOT): ClothingData = r.CTDT
func scriptName*(r:CLOT): Option[string] = r.SCRI
func iconPath*(r:CLOT): Option[string] = r.ITEX
func bodyData*(r:CLOT): seq[BipedObject] = seq[BipedObject](r.INDX)
func enchantment*(r:CLOT): Option[string] = r.ENAM

proc `$`*(r:CLOT): string =
    result = "CLOT"
    result.add `T$`(r)


    

export item_slot,male_name,female_name,ItemSlot
