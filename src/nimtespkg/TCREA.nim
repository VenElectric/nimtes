import std/[options,sugar,editdistance]
import record,util

# unsure if I want this....
type
    CreatureFlags* = enum
        CRNone = -1,
        CRDefault,
        CRBiped,
        CRRespawn,
        CRWeapShield = "Weapon and Shield",
        CRSwims,
        CRFlies,
        CRWalks,
        CREssential,
        CRBloodType0 = "Red"
        CRBloodType1 = "Dust",
        CRBloodType2 = "Sparks",
        CRBloodType3,
        CRBloodType4,
        CRBloodType5,
        CRBloodType6,
        CRBloodType7

    CreatureData* = ref object of DataField
        kind: uint32
        level: uint32
        attributes: array[8,uint32]
        health: uint32
        spell_pts: uint32
        fatigue: uint32
        soul: uint32
        combat: uint32
        magic: uint32
        stealth: uint32
        attackmin1: uint32
        attackmax1: uint32
        attackmin2: uint32
        attackmax2: uint32
        attackmin3: uint32
        attackmax3: uint32
        gold: uint32
    CREA* = ref object of TES3Record
        NAME: string
        MODL: string
        CNAM: Option[string]
        FNAM: Option[string]
        SCRI: Option[string]
        NPDT: CreatureData
        FLAG: uint32
        XSCL: Option[float32]
        NPCO: seq[CarriedObject[uint32]]
        NPCS: seq[string] # do each of these have a size, or does NPCS have one size for all?
        AIDT: AIData
        DODT: TagList[CellTravelData]
        Pkgs: seq[AI_Package]

const FTBTRED = flagtup(0x0000,CRBloodType0)
const FTBIPED = flagtup(0x0001,CRBiped)
const FTRESP = flagtup(0x0002,CRRespawn)
const FTWEAPSHIELD = flagtup(0x0004,CRWeapShield)
const FTNONE = flagtup(0x0008,CRNone)
const FTSWIM = flagtup(0x0010,CRSwims)
const FTFLY = flagtup(0x0020,CRFlies)
const FTWALK = flagtup(0x0040,CRWalks)
const FTDEFAULT = flagtup(0x0048,CRDefault)
const FTESS = flagtup(0x0080,CREssential)
const FTBT1 = flagtup(0x0400,CRBloodType1)
const FTBT2 = flagtup(0x0800,CRBloodType2)
const FTBT3 = flagtup(0x0C00,CRBloodType3)
const FTBT4 = flagtup(0x1000,CRBloodType4)
const FTBT5 = flagtup(0x1400,CRBloodType5)
const FTBT6 = flagtup(0x1800,CRBloodType6)
const FTBT7 = flagtup(0x1C00,CRBloodType7)

let creaFlagLookups = [FTBIPED,FTBTRED,FTRESP,FTWEAPSHIELD,FTNONE,FTSWIM,FTFLY,FTWALK,FTDEFAULT,FTESS,FTBT1,FTBT2,FTBT3,FTBT4,FTBT5,FTBT6,FTBT7]

using
    r:CREA

func id*(r:CREA): string = stripNull(r.NAME)
func model_path*(r:CREA): string = stripNull(r.MODL)
func sound_gen*(r:CREA): Option[string] = r.CNAM
func has_name*(r:CREA): bool = isSome(r.FNAM)
func name*(r:CREA): Option[string] = r.FNAM
func has_script*(r:CREA): bool = isSome(r.SCRI)
func script_name*(r:CREA): Option[string] = r.SCRI
func data*(r:CREA): CreatureData = r.NPDT
func is_creature*(r:CREA): bool = data(r).kind == 0
func is_daedra*(r:CREA): bool = data(r).kind == 1
func is_undead*(r:CREA): bool = data(r).kind == 2
func is_humanoid*(r:CREA): bool = data(r).kind == 3
func level*(r:CREA): uint32 = data(r).level
func attributes*(r:CREA): array[8,uint32] = data(r).attributes
func attr_at(r:CREA,idx:AttributeRange): uint32 = attributes(r)[idx]
func str*(r:CREA): uint32 = attr_at(r,0)
func inte*(r:CREA): uint32 = attr_at(r,1)
func will*(r:CREA): uint32 = attr_at(r,2)
func agility*(r:CREA): uint32 = attr_at(r,3)
func speed*(r:CREA): uint32 = attr_at(r,4)
func endu*(r:CREA): uint32 = attr_at(r,5)
func pers*(r:CREA): uint32 = attr_at(r,6)
func luck*(r:CREA): uint32 = attr_at(r,7)
func health*(r:CREA): uint32 = data(r).health
func spell_pts*(r:CREA): uint32 = data(r).spell_pts
func fatigue*(r:CREA): uint32 = data(r).fatigue
func soul_lvl*(r:CREA): uint32 = data(r).soul
func petty_soul*(r:CREA): bool = soul_lvl(r) <= PETTY_SOUL
func lesser_soul*(r:CREA): bool = soul_lvl(r) <= LESSER_SOUL
func common_soul*(r:CREA): bool = soul_lvl(r) <= COMMON_SOUL
func greater_soul*(r:CREA): bool = soul_lvl(r) <= GREATER_SOUL
func grand_soul*(r:CREA): bool = soul_lvl(r) <= GRAND_SOUL
func azura_soul*(r:CREA): bool = soul_lvl(r) <= AZURA_SOUL
func combat*(r:CREA): uint32 = data(r).combat
func magic*(r:CREA): uint32 = data(r).magic
func stealth*(r:CREA): uint32 = data(r).stealth
# q how are the different attacks calculated?
func attacks*(r:CREA): array[3,tuple[min,max:uint32]] = [(min:data(r).attackmin1,max:data(r).attackmax1),(min:data(r).attackmin2,max:data(r).attackmax2),(min:data(r).attackmin3,max:data(r).attackmax3)]
func gold*(r:CREA): uint32 = data(r).gold

proc flags*(r): set[CreatureFlags] = 
    for _,f in creaFlagLookups:
        let (check,incl) = f
        if has_flag(r.FLAG,check):
            result.incl(incl)

func scale*(r:CREA): float32 =
    if isSome(r.XSCL):
        return get(r.XSCL)
    else:
        return 1.0

func items*(r:CREA): seq[CarriedObject[uint32]] = r.NPCO

proc search_items*(r:CREA,name:string): seq[CarriedObject[uint32]] = 
    result = @[]
    if len(items(r)) > 0:
        let results = collect(newSeq):
            for idx,m in items(r):
                if editDistance(stripNull(name(m)),name) <= 1:
                    m
        result = results

proc spells*(r:CREA): seq[string] = 
    result = @[]
    for s in r.NPCS:
        result.add stripNull(s)

proc ai_data*(r:CREA): AIData = r.AIDT

func hello*(r:CREA): uint8 = hello(ai_data(r))
func fight*(r:CREA): uint8 = fight(ai_data(r))
func flee*(r:CREA): uint8 = flee(ai_data(r))
func alarm*(r:CREA): uint8 = alarm(ai_data(r))
proc ai_flags*(r:CREA): set[AIServices] = flags(ai_data(r))

func cell_travel_dests*(r:CREA): seq[CellTravelData] = seq[CellTravelData](r.DODT)

func ai_pkgs*(r:CREA): seq[AI_Package] = r.Pkgs


proc `$`*(r:CREA): string = 
    result = "CREA"
    result.add `T$`(r)

export travel_dest,prev_dest_name