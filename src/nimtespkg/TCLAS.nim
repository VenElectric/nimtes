import std/options
import record,util

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

const CAWEAP = flagtup(0x00001,CAWeapon)
const CAARMO = flagtup(0x00002,CAArmor)
const CACLOT = flagtup(0x00004,CAClothing)
const CABK = flagtup(0x00008,CABooks)
const CAINGR = flagtup(0x00010,CAIngredients)
const CAPICK = flagtup(0x00020,CAPicks)
const CAPROB = flagtup(0x00040,CAProbes)
const CALIGH = flagtup(0x00080,CALights)
const CAAPPA = flagtup(0x00100,CAApparatus)
const CAREPAITEM = flagtup(0x00200,CARepairItems)
const CAMSC = flagtup(0x00400,CAMisc)
const CASPLL = flagtup(0x00800, CASpells)
const CAMGITEMS = flagtup(0x01000,CAMagicItems)
const CAPOT = flagtup(0x02000,CAPotions)
const CATRAIN = flagtup(0x04000,CATraining)
const CASPLLMK = flagtup(0x08000,CASpellmaking)
const CAENCH = flagtup(0x10000,CAEnchant)
const CAREPA = flagtup(0x20000, CARepair)

using
    r:CLAS

let classAutoLookup = [CAWEAP,CAARMO,CACLOT,CABK,CAINGR,CAPICK,CAPROB,CALIGH,CAAPPA,CAREPAITEM,
    CAMSC,CASPLL,CAMGITEMS,CAPOT,CATRAIN,CASPLLMK,CAENCH,CAREPA]

func id*(r): string = r.NAME
func class_name*(r): string = r.FNAM
func data*(r): ClassData = r.CLDT
func desc*(r): Option[string] = r.DESC

proc primary_attrs*(r): array[2,AttributeIndex] = 
    let attr1 = data(r).primary[0]
    let attr2 = data(r).primary[1]
    attribute_assert(attr1)
    attribute_assert(attr2)
    [AttributeIndex(attr1),AttributeIndex(attr2)]
proc specialization*(r): SpecKind = SpecKind(uint8(data(r).spec))
proc skills*(r): array[5,tuple[minor: SkillIndex,major:SkillIndex]] = 
    for idx,s in pairs(data(r).skills):
        let skill1 = s[0]
        let skill2 = s[1]
        skill_assert(skill1)
        skill_assert(skill2)
        result[idx] = (minor:SkillIndex(skill1),major:SkillIndex(skill2))

proc auto_calc_flags*(r): set[ClassAutoCalcFlags] = 
    let d = data(r)
    for _,f in classAutoLookup:
        let (check,incl) = f
        if has_flag(d.flags,check):
            result.incl(incl)

proc is_playable*(r): bool = data(r).flags == 1

func specialization*(r): SpecializationKind = SpecializationKind(data(r).spec)

proc `$`*(r): string =
    result = "CLAS"
    result.add `T$`(r)

# autocalc flags...later
# 0x00001 = Weapon
# 0x00002 = Armor
# 0x00004 = Clothing
# 0x00008 = Books
# 0x00010 = Ingredients
# 0x00020 = Picks
# 0x00040 = Probes
# 0x00080 = Lights
# 0x00100 = Apparatus
# 0x00200 = Repair Items
# 0x00400 = Misc
# 0x00800 = Spells
# 0x01000 = Magic Items
# 0x02000 = Potions
# 0x04000 = Training
# 0x08000 = Spellmaking
# 0x10000 = Enchanting
# 0x20000 = Repair