import std/[options,sugar,editdistance]
import record

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

const FTBTRED: (uint32,CreatureFlags) = (0x0000,CRBloodType0)
const FTBIPED: (uint32,CreatureFlags) = (0x0001,CRBiped)
const FTRESP: (uint32,CreatureFlags) = (0x0002,CRRespawn)
const FTWEAPSHIELD: (uint32,CreatureFlags) = (0x0004,CRWeapShield)
const FTNONE: (uint32,CreatureFlags) = (0x0008,CRNone)
const FTSWIM: (uint32,CreatureFlags) = (0x0010,CRSwims)
const FTFLY: (uint32,CreatureFlags) = (0x0020,CRFlies)
const FTWALK: (uint32,CreatureFlags) = (0x0040,CRWalks)
const FTDEFAULT: (uint32,CreatureFlags) = (0x0048,CRDefault)
const FTESS: (uint32,CreatureFlags) = (0x0080,CREssential)
const FTBT1: (uint32,CreatureFlags) = (0x0400,CRBloodType1)
const FTBT2: (uint32,CreatureFlags) = (0x0800,CRBloodType2)
const FTBT3: (uint32,CreatureFlags) = (0x0C00,CRBloodType3)
const FTBT4: (uint32,CreatureFlags) = (0x1000,CRBloodType4)
const FTBT5: (uint32,CreatureFlags) = (0x1400,CRBloodType5)
const FTBT6: (uint32,CreatureFlags) = (0x1800,CRBloodType6)
const FTBT7: (uint32,CreatureFlags) = (0x1C00,CRBloodType7)

const creaFlagLookups = [FTBIPED,FTBTRED,FTRESP,FTWEAPSHIELD,FTNONE,FTSWIM,FTFLY,FTWALK,FTDEFAULT,FTESS,FTBT1,FTBT2,FTBT3,FTBT4,FTBT5,FTBT6,FTBT7]

using
    r:CREA

func id*(r): string = stripNull(r.NAME)
func modelPath*(r): string = stripNull(r.MODL)
func soundGen*(r): Option[string] = r.CNAM
func hasName*(r): bool = isSome(r.FNAM)
func name*(r): Option[string] = r.FNAM
func hasScript*(r): bool = isSome(r.SCRI)
func scriptName*(r): Option[string] = r.SCRI
func data*(r): CreatureData = r.NPDT
func isCreature*(r): bool = data(r).kind == 0
func isDaedra*(r): bool = data(r).kind == 1
func isUndead*(r): bool = data(r).kind == 2
func isHumanoid*(r): bool = data(r).kind == 3
func level*(r): uint32 = data(r).level
func attributes*(r): array[8,uint32] = data(r).attributes
func attrAt(r;idx:AttributeRange): uint32 = attributes(r)[idx]
func str*(r): uint32 = attr_at(r,0)
func inte*(r): uint32 = attr_at(r,1)
func will*(r): uint32 = attr_at(r,2)
func agility*(r): uint32 = attr_at(r,3)
func speed*(r): uint32 = attr_at(r,4)
func endu*(r): uint32 = attr_at(r,5)
func pers*(r): uint32 = attr_at(r,6)
func luck*(r): uint32 = attr_at(r,7)
func health*(r): uint32 = data(r).health
func spellPts*(r): uint32 = data(r).spell_pts
func fatigue*(r): uint32 = data(r).fatigue
func soulLvl*(r): uint32 = data(r).soul
func pettySoul*(r): bool = soulLvl(r) <= PETTY_SOUL
func lesserSoul*(r): bool = soulLvl(r) <= LESSER_SOUL
func commonSoul*(r): bool = soulLvl(r) <= COMMON_SOUL
func greaterSoul*(r): bool = soulLvl(r) <= GREATER_SOUL
func grandSoul*(r): bool = soulLvl(r) <= GRAND_SOUL
func azuraSoul*(r): bool = soulLvl(r) <= AZURA_SOUL
func combat*(r): uint32 = data(r).combat
func magic*(r): uint32 = data(r).magic
func stealth*(r): uint32 = data(r).stealth
# q how are the different attacks calculated?
func attacks*(r): array[3,tuple[min,max:uint32]] = [(min:data(r).attackmin1,max:data(r).attackmax1),(min:data(r).attackmin2,max:data(r).attackmax2),(min:data(r).attackmin3,max:data(r).attackmax3)]
func gold*(r): uint32 = data(r).gold

proc flags*(r): set[CreatureFlags] = 
    for f in creaFlagLookups:
        let (check,incl) = f
        if hasFlag(r.FLAG,check):
            result.incl(incl)

func scale*(r): float32 =
    if isSome(r.XSCL):
        return get(r.XSCL)
    else:
        return 1.0

func items*(r): seq[CarriedObject[uint32]] = r.NPCO

proc searchItems*(r;name:string): seq[CarriedObject[uint32]] = 
    if len(items(r)) > 0:
        result = collect(newSeq):
            for idx,m in items(r):
                if editDistance(stripNull(m.name),name) <= 1:
                    m

proc spells*(r): seq[string] = 
    result = @[]
    for s in r.NPCS:
        result.add stripNull(s)

proc aiData*(r): AIData = r.AIDT

func hello*(r): uint8 = hello(aiData(r))
func fight*(r): uint8 = fight(aiData(r))
func flee*(r): uint8 = flee(aiData(r))
func alarm*(r): uint8 = alarm(aiData(r))
proc aiFlags*(r): set[AIServices] = flags(aiData(r))

func cellTravelDests*(r): seq[CellTravelData] = seq[CellTravelData](r.DODT)

func aiPkgs*(r): seq[AI_Package] = r.Pkgs


proc `$`*(r): string = 
    result = "CREA"
    result.add `T$`(r)

export travelDest,prevDestName