import std/options
import record

type
    SkillBonus* = object
        id: int32
        bonus: int32
    RaceData* = ref object of DataField
        skill_bonuses: array[7,SkillBonus]
        attrs: array[8,array[2,uint32]]
        height: array[2,float32]
        weight: array[2,float32]
        flags: uint32
    RACE* = ref object of TES3Record
        NAME: string
        FNAM: Option[string]
        RADT: RaceData
        NPCS: seq[string]
        DESC: Option[string]

using
    r:RACE

func name*(r): string = r.NAME
func race_name*(r): Option[string] = r.FNAM
func data*(r): RaceData = r.RADT
proc skillBonuses*(r): array[7,tuple[skill:SkillIndex,bonus:int32]] =
    for idx,s in data(r).skill_bonuses:
        let id = s.id
        let bonus = s.bonus
        skillAssert(id)
        result[idx] = (skill:SkillIndex(id),bonus:bonus)
func desc*(r): Option[string] = r.DESC

proc `$`*(r): string =
    result = "RACE"
    result.add `T$`(r)