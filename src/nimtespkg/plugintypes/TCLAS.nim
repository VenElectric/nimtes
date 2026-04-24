import std/options
import record

type
    ClassAutoCalcFlags* = enum
        CAWeapon = "Weapon",
        CAArmor = "Armor",
        CAClothing = "Clothing",
        CABooks = "Books",
        CAIngredients = "Ingredients",
        CAPicks = "Lockpicks",
        CAProbes = "Probes",
        CALights = "Lights",
        CAApparatus = "Apparatus",
        CARepairItems = "Repair Items",
        CAMisc = "Misc",
        CASpells = "Spells",
        CAMagicItems = "Magic Items",
        CAPotions = "Potions",
        CATraining = "Training",
        CASpellmaking = "Spellmaking",
        CAEnchant = "Enchanting",
        CARepair = "Repair"
    SpecKind* = enum 
        Combat = 0,
        Magic,
        Stealth
    ClassData* = ref object of DataField 
        primary: array[2,uint32]
        spec: uint32
        skills: array[5,array[2,uint32]]
        flags: uint32
        autocalc: uint32
    CLAS* = ref object of TES3Record
        NAME: string
        FNAM: string
        CLDT:ClassData
        DESC: Option[string]

const CAWEAP: (uint32,ClassAutoCalcFlags) = (0x00001,CAWeapon)
const CAARMO: (uint32,ClassAutoCalcFlags) = (0x00002,CAArmor)
const CACLOT: (uint32,ClassAutoCalcFlags) = (0x00004,CAClothing)
const CABK: (uint32,ClassAutoCalcFlags) = (0x00008,CABooks)
const CAINGR: (uint32,ClassAutoCalcFlags) = (0x00010,CAIngredients)
const CAPICK: (uint32,ClassAutoCalcFlags) = (0x00020,CAPicks)
const CAPROB: (uint32,ClassAutoCalcFlags) = (0x00040,CAProbes)
const CALIGH: (uint32,ClassAutoCalcFlags) = (0x00080,CALights)
const CAAPPA: (uint32,ClassAutoCalcFlags) = (0x00100,CAApparatus)
const CAREPAITEM: (uint32,ClassAutoCalcFlags) = (0x00200,CARepairItems)
const CAMSC: (uint32,ClassAutoCalcFlags) = (0x00400,CAMisc)
const CASPLL: (uint32,ClassAutoCalcFlags) = (0x00800, CASpells)
const CAMGITEMS: (uint32,ClassAutoCalcFlags) = (0x01000,CAMagicItems)
const CAPOT: (uint32,ClassAutoCalcFlags) = (0x02000,CAPotions)
const CATRAIN: (uint32,ClassAutoCalcFlags) = (0x04000,CATraining)
const CASPLLMK: (uint32,ClassAutoCalcFlags) = (0x08000,CASpellmaking)
const CAENCH: (uint32,ClassAutoCalcFlags) = (0x10000,CAEnchant)
const CAREPA: (uint32,ClassAutoCalcFlags) = (0x20000, CARepair)

using
    r:CLAS

const classAutoLookup = [CAWEAP,CAARMO,CACLOT,CABK,CAINGR,CAPICK,CAPROB,CALIGH,CAAPPA,CAREPAITEM,
    CAMSC,CASPLL,CAMGITEMS,CAPOT,CATRAIN,CASPLLMK,CAENCH,CAREPA]

func id*(r): string = r.NAME
func className*(r): string = r.FNAM
func data*(r): ClassData = r.CLDT
func desc*(r): Option[string] = r.DESC

proc primaryAttrs*(r): array[2,AttributeIndex] = 
    let attr1 = data(r).primary[0]
    let attr2 = data(r).primary[1]
    attributeAssert(attr1)
    attributeAssert(attr2)
    [AttributeIndex(attr1),AttributeIndex(attr2)]
proc specialization*(r): SpecKind = SpecKind(uint8(data(r).spec))
proc skills*(r): array[5,tuple[minor: SkillIndex,major:SkillIndex]] = 
    for idx,s in pairs(data(r).skills):
        let skill1 = s[0]
        let skill2 = s[1]
        skillAssert(skill1)
        skillAssert(skill2)
        result[idx] = (minor:SkillIndex(skill1),major:SkillIndex(skill2))

proc auto_calc_flags*(r): set[ClassAutoCalcFlags] = 
    let d = data(r)
    for _,f in classAutoLookup:
        let (check,incl) = f
        if hasFlag(d.flags,uint32(check)):
            result.incl(incl)

proc isPlayable*(r): bool = data(r).flags == 1

func specialization*(r): SpecializationKind = SpecializationKind(data(r).spec)

proc `$`*(r): string =
    result = "CLAS"
    result.add `T$`(r)

