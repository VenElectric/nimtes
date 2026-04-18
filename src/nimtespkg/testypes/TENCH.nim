import record

type
    EnchantKind* = enum 
        CastOnce = (0,"Cast Once"),
        CastStrikes = "Cast on Strike",
        CastUsed = "Cast on Use",
        Constant = "Constant Effect"
    EnchantmentInfo* = ref object of DataField #naming too similar to EnchantmentData
        kind: uint32
        cost: uint32
        charge: uint32
        flags: uint32
    ENCH* = ref object of TES3Record
        NAME: string
        ENDT: EnchantmentInfo
        ENAM: seq[EnchantmentData]

func id*(r:ENCH): string = r.NAME
func data*(r:ENCH): EnchantmentInfo = r.ENDT
proc enchant_kind*(r:ENCH): EnchantKind = 
    let kind = data(r).kind
    assert(kind < 4,"Enchant kind > 3")
    EnchantKind(kind)
func enchant_cost*(r:ENCH): uint32 = data(r).cost
func enchant_charge*(r:ENCH): uint32 = data(r).charge
proc auto_calc*(r:ENCH): bool = has_flag(data(r).flags,AUTO_CALC)
func enchantments*(r:ENCH): seq[EnchantmentData] = r.ENAM



proc `$`*(r:ENCH): string =
    result = "ENCH"
    result.add `T$`(r)

export effect,attr_affected,skill_affected,effect_range,aoe,duration,magnitude