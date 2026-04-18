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

const FTFemale = flagtup(0x0001,NPFemale)
const FTEssential = flagtup(0x0002,NPEssential)
const FTRespawn = flagtup(0x0004,NPRespawn)
const FTAUTOCALC = flagtup(0x0010,NPAutocalc)
const FTBLOODSKELE = flagtup(0x0400,NPBloodSkele)
const FTBLOODMETAL = flagtup(0x0800,NPBloodMetal)

const npcFlagLookup = [FTFemale,FTEssential,FTRespawn,FTAUTOCALC,FTBLOODSKELE,FTBLOODMETAL]

using 
    r:NPC

func id*(r): string = r.NAME
func model_path*(r): Option[string] = r.MODL
func name*(r): Option[string] = r.FNAM
func race_name*(r): string = r.RNAM
func class_name*(r): string = r.CNAM
func faction_name*(r): Option[string] = r.ANAM
func head_model_path*(r): string = r.BNAM
func hair_model_path*(r): Option[string] = r.KNAM
func script_name*(r): Option[string] = r.SCRI
func npc_flags*(r): set[NPCFlags] =
    for f in npcFlagLookup:
        let (check,incl) = f
        if has_flag(r.flags,check):
            result.incl incl
func data*(r): NPCData = r.NPDT
func npc_level*(r): uint16 = data(r).level
func npc_disposition*(r):uint8 = data(r).disposition
func npc_reputation*(r):uint8 = data(r).reputation
func npc_gold*(r): uint32 = data(r).gold
func stats*(r): Option[NPCStats] = data(r).stats

func ai_pkgs*(r): seq[AI_Package] = r.Pkgs

proc ai_flags*(r): Option[set[AIServices]] =
    if isSome(r.AIDT):
        result = some(flags(get(r.AIDT)))

proc `$`*(r): string = 
    result = "NPC"
    result.add `T$`(r)

export hello,fight,flee,alarm,travel_dest,prev_dest_name,attributes,skills,health,spell_points,fatigue


