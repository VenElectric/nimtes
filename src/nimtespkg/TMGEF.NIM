import std/options
import record, util



type
    MagicEffectFlags* = enum
        METargetsSkill = (0, "Targets Skill"),
        METargetsAttribute = "Targets Attribute",
        MENoDuration = "No Duration",
        MENoMagnitude = "No Magnitude"
        MEHarmful = "Harmful",
        MEContinuousVFX = "Continuous VFX",
        MECanCastSelf = "Cast on Self",
        MECanCastTouch = "Cast on Touch",
        MECanCastTarget = "Cast on Target",
        MESpellMaking = "Spellmaking",
        MEEnchanting = "Enchanting",
        MENegLight = "Negative Lighting",
        MEApplyOnce = "Applied Once",
        MEStealth = "Stealth",
        MECantRecast = "Cannot Recast",
        MEIllDeadra = "Illegal Daedra",
        MENoReflect = "Unreflectable",
        MELinkCaster = "Linked to Caster"
    SpellSchool* = enum
        Alteration = 0,
        Conjuration,
        Destruction,
        Illusion,
        Mysticism,
        Restoration
    MagicEffectData* = ref object of DataField
        school*: uint32
        base_cost*: float32
        flags*: uint32
        red*: uint32
        green*: uint32
        blue*: uint32
        speed_x*: float32
        size_x*: float32
        size_cap*: float32
    MGEF* = ref object of TES3Record
        INDX: uint32
        MEDT: MagicEffectData
        ITEX: Option[string]
        PTEX: Option[string]
        BSND: Option[string]
        CSND: Option[string]
        HSND: Option[string]
        ASND: Option[string]
        CVFX: Option[string]
        BVFX: Option[string]
        HVFX: Option[string]
        AVFX: Option[string]
        DESC: Option[string]

const FTTargetsSkill = flagtup(0x00001, METargetsSkill)
const FTTargetsAttribute = flagtup(0x00002, METargetsAttribute)
const FTNoDuration = flagtup(0x00004, MENoDuration)
const FTNoMagnitude = flagtup(0x00008, MENoMagnitude)
const FTHarmful = flagtup(0x00010, MEHarmful)
const FTContinuousVFX = flagtup(0x00020, MEContinuousVFX)
const FTCanCastOnSelf = flagtup(0x00040, MECanCastSelf)
const FTCanCastOnTouch = flagtup(0x00080, MECanCastTouch)
const FTCanCastOnTarget = flagtup(0x00100, MECanCastTarget)
const FTSpellmaking = flagtup(0x00200, MESpellMaking)
const FTEnchanting = flagtup(0x00400, MEEnchanting)
const FTNegativeLighting = flagtup(0x00800, MENegLight)
const FTAppliedOnce = flagtup(0x01000, MEApplyOnce)
const FTStealth = flagtup(0x02000, MEStealth)
const FTCannotRecast = flagtup(0x04000, MECantRecast)
const FTIllegalDaedra = flagtup(0x08000, MEIllDeadra)
const FTUnreflectable = flagtup(0x10000, MENoReflect)
const FTLinkedToCaster = flagtup(0x20000, MELinkCaster)

let meFlagLookup = [FTTargetsSkill, FTTargetsAttribute, FTNoDuration,
        FTNoMagnitude, FTHarmful, FTContinuousVFX,
FTCanCastOnSelf, FTCanCastOnTarget, FTCanCastOnTouch, FTSpellmaking,
        FTEnchanting, FTNegativeLighting, FTAppliedOnce,
FTStealth, FTCannotRecast, FTIllegalDaedra, FTUnreflectable, FTLinkedToCaster]

using
    r: MGEF

proc id*(r): EffectIndex =
    effect_assert(r.INDX)
    result = EffectIndex(r.INDX)

func data(r): MagicEffectData = r.MEDT
proc school(r): SpellSchool =
    let idx = data(r).school
    assert(idx < 6, "Magic School Index > 5: " & $idx)
    SpellSchool(idx)
func base_cost*(r): float32 = data(r).base_cost

proc flags*(r): set[MagicEffectFlags] =
    let f = data(r).flags
    for _, (check, incl) in meFlagLookup:
        if has_flag(f, check):
            result.incl(incl)

func lighting_red*(r): uint32 = data(r).red
func lighting_green*(r): uint32 = data(r).green
func lighting_blue*(r): uint32 = data(r).blue

func speed*(r): float32 = data(r).speed_x
func size*(r): float32 = data(r).size_x
func size_cap*(r): float32 = data(r).size_cap

func effect_icon*(r): Option[string] = r.ITEX
func particle_texture*(r): Option[string] = r.PTEX
func bolt_sound*(r): Option[string] = r.BSND
func casting_sound*(r): Option[string] = r.CSND
func hit_sound*(r): Option[string] = r.HSND
func area_sound*(r): Option[string] = r.ASND
func casting_vfx*(r): Option[string] = r.CVFX
func bolt_vfx*(r): Option[string] = r.BVFX
func hit_vfx*(r): Option[string] = r.HVFX
func area_vfx*(r): Option[string] = r.AVFX
func desc*(r): Option[string] = r.DESC

proc `$`*(r): string =
    result = "MGEF"
    result.add `T$`(r)
