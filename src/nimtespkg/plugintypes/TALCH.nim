import std/[streams,options]
import record

type 
    AlchemyData* = ref object of DataField
        weight:float32
        value: uint32
        flags: uint32
    ALCH* = ref object of TES3Record
        NAME {.dtag("ID").}: string
        MODL {.dtag("Model Path"),mesh.}: Option[string]
        TEXT {.dtag("Icon Path"),icon.}: Option[string]
        SCRI {.dtag("Script Name").}: Option[string]
        FNAM {.dtag("Name").}: Option[string]
        ALDT {.dtag("Alchemy Data").}: Option[AlchemyData]
        ENAM {.dtag("Enchantments").}: seq[EnchantmentData] 

using 
    r: ALCH
    ad:AlchemyData

proc `==`*(l,r:AlchemyData): bool = 
    l.weight == r.weight and l.value == r.value and l.flags == r.flags

func id*(r): string = stripNull(r.NAME)
func modelPath*(r): Option[string] = r.MODL
func iconPath*(r): Option[string] = r.TEXT
func scriptName*(r): Option[string] = r.SCRI
func name*(r): Option[string] = r.FNAM
func enchants*(r): seq[EnchantmentData] = r.ENAM
func data*(r): Option[AlchemyData] = r.ALDT

proc autoCalc*(ad): bool = hasFlag(ad.flags,AUTO_CALC)
func weight*(ad): float32 = ad.weight
func value*(ad): uint32 = ad.value


proc `$`*(r): string =
    result = "ALCH"
    result.add `T$`(r)

export effect,attr_affected,skill_affected,effect_range,aoe,duration,magnitude