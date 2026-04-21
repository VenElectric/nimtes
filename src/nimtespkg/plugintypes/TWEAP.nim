import std/options
import record

type
    WeaponKind* = enum 
        ShortBlade = (0,"Short Blade"),
        LongBladeOneHand = "Long Blade, One Handed",
        LongBladeTwoHand = "Long Blade, Two Handed",
        BluntOneHand,
        BluntTwoClose,
        BluntTwoWide,
        SpearTwoWide,
        AxeOneHand,
        AxeTwoHand,
        Bow,
        Crossbow,
        Thrown,
        Arrow,
        Bolt
    WeaponAtkRange* = tuple[min:uint8,max:uint8]
    WeaponData* = ref object of DataField
        weight: float32
        value: uint32
        kind: uint16
        health: uint16
        speed: float32
        reach: float32
        enchant_pts: uint16
        chop_min:uint8
        chop_max:uint8
        slash_min:uint8
        slash_max:uint8
        thrust_min:uint8
        thrust_max:uint8
        flags:uint32
    WEAP* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        WPDT: WeaponData
        ITEX: Option[string]
        ENAM: Option[string]
        SCRI: Option[string]

using
    r:WEAP

func id*(r): string = r.NAME
func modelPath*(r): string = r.MODL
func name*(r): Option[string] = r.FNAM
func data*(r): WeaponData = r.WPDT

func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func kind*(r): WeaponKind =
    let k = data(r).kind
    assert(k < 14,"Weapon type number invalid: " & $k)
    WeaponKind(k)

func health*(r): uint16 = data(r).health
func speed*(r): float32 = data(r).speed
func reach*(r): float32 = data(r).reach
func enchantPoints*(r): uint16 = data(r).enchant_pts

func atkRange(min,max:uint8): WeaponAtkRange = (min:min,max:max)

func attackRanges*(r): tuple[chop:WeaponAtkRange,slash:WeaponAtkRange,thrust:WeaponAtkRange] =
    let d = data(r)
    (chop:atkRange(d.chop_min,d.chop_max),slash:atkRange(d.slash_min,d.slash_max),thrust:atkRange(d.thrust_min,d.thrust_max))

proc ignoreNormalResistance*(r): bool = hasFlag(data(r).flags,0x1)
proc silverWeapon*(r): bool = hasFlag(data(r).flags,0x2)

func icon_path*(r): Option[string] = r.ITEX
func enchantmentId*(r): Option[string] = r.ENAM
func scriptId*(r): Option[string] = r.SCRI

proc `$`*(r): string = 
    result = "WEAP"
    result.add `T$`(r)
