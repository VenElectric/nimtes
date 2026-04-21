import std/options
import record

type
    NPCFlags* = enum
        NPFemale = "Female",
        NPEssential = "Essential",
        NPRespawn = "Respawn",
        NPAutocalc = "Auto Calc",
        NPBloodSkele = "Blood Texture: Skeleton",
        NPBloodMetal = "Blood Texture: Metal Sparks"
    NPC* = ref object of TES3Record
        NAME: string
        MODL: Option[string]
        FNAM: Option[string]
        RNAM: string
        CNAM: string
        ANAM: Option[string]
        BNAM: string
        KNAM: Option[string]
        SCRI: Option[string]
        NPDT: NPCData
        FLAG: uint32
        NPCO: seq[CarriedObject[int32]]
        NPCS: seq[string]
        AIDT: Option[AIData]
        DODT: TagList[CellTravelData]
        Pkgs: seq[AI_Package]

const FTFemale: (uint32,NPCFlags) = (0x0001,NPFemale)
const FTEssential: (uint32,NPCFlags) = (0x0002,NPEssential)
const FTRespawn: (uint32,NPCFlags) = (0x0004,NPRespawn)
const FTAUTOCALC: (uint32,NPCFlags) = (0x0010,NPAutocalc)
const FTBLOODSKELE: (uint32,NPCFlags) = (0x0400,NPBloodSkele)
const FTBLOODMETAL: (uint32,NPCFlags) = (0x0800,NPBloodMetal)

const npcFlagLookup = [FTFemale,FTEssential,FTRespawn,FTAUTOCALC,FTBLOODSKELE,FTBLOODMETAL]

using 
    r:NPC

func id*(r): string = r.NAME
func modelPath*(r): Option[string] = r.MODL
func name*(r): Option[string] = r.FNAM
func raceName*(r): string = r.RNAM
func className*(r): string = r.CNAM
func factionName*(r): Option[string] = r.ANAM
func headModelPath*(r): string = r.BNAM
func hairModelPath*(r): Option[string] = r.KNAM
func scriptName*(r): Option[string] = r.SCRI
func npcFlags*(r): set[NPCFlags] =
    for f in npcFlagLookup:
        let (check,incl) = f
        if hasFlag(r.flags,check):
            result.incl incl
func data*(r): NPCData = r.NPDT
func npcLevel*(r): uint16 = data(r).level
func npcDisposition*(r):uint8 = data(r).disposition
func npcReputation*(r):uint8 = data(r).reputation
func npcGold*(r): uint32 = data(r).gold
func stats*(r): Option[NPCStats] = data(r).stats

func aiPkgs*(r): seq[AI_Package] = r.Pkgs

proc aiFlags*(r): set[AIServices] =
    if isSome(r.AIDT):
        result = flags(get(r.AIDT))

proc `$`*(r): string = 
    result = "NPC"
    result.add `T$`(r)

export hello,fight,flee,alarm,travelDest,prevDestName,attributes,skills,health,spellPoints,fatigue


