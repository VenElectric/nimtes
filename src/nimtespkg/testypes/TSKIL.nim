import std/options
import record

type
    SkillData* = ref object of DataField
        attribute:uint32
        specialization:uint32
        use_values: array[4,float32]
    SKIL* = ref object of TES3Record
        INDX: uint32
        SKDT: SkillData
        DESC: Option[string]

using 
    r:SKIL

func index*(r): SkillIndex =
    skillAssert(r.INDX)
    SkillIndex(r.INDX)

func data*(r): SkillData = r.SKDT
func attribute*(r): AttributeIndex = 
    let attr = data(r).attribute
    attributeAssert(attr)
    AttributeIndex(attr)
func specialization*(r): SpecializationKind =
    let spec = data(r).specialization
    specAssert(spec)
    SpecializationKind(spec)

func useValues*(r): array[4,float32] = data(r).use_values

func desc*(r): Option[string] = r.DESC


proc `$`*(r): string =
    result = "SKIL"
    result.add `T$`(r)