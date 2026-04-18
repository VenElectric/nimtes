import std/options
import record

type
    SpellKind* = enum 
        Spell = 0,
        Ability,
        Blight,
        Disease,
        Curse,
        Power
    SpellData* = ref object of DataField
        kind: uint32
        cost: uint32
        flags: uint32
    SPEL* = ref object of TES3Record
        NAME: string
        FNAM: string
        SPDT: SpellData
        ENAM: seq[EnchantmentData]

using 
    r:SPEL

func id*(r): string = r.NAME
func name*(r): string = r.FNAM
func data*(r): SpellData = r.SPDT
func kind*(r):SpellKind = 
    let k = data(r).kind
    assert(k < 6,"Spell type number invalid: " & $k)
    SpellKind(k)
func mana_cost*(r): uint32 = data(r).cost
func auto_calc*(r): bool = has_flag(data(r).flags,0x1)
func at_pc_start*(r): bool = has_flag(data(r).flags,0x2)
func always_succeeds*(r): bool = has_flag(data(r).flags,0x4)
func enchantments*(r): seq[EnchantmentData] = r.ENAM

proc `$`*(r): string =
    result = "SPEL"
    result.add `T$`(r)

export effect,attr_affected,skill_affected,effect_range,aoe,duration,magnitude