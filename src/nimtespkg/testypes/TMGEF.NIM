import std/options
import record



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

const FTTargetsSkill: (uint32,MagicEffectFlags) = (0x00001, METargetsSkill)
const FTTargetsAttribute: (uint32,MagicEffectFlags) = (0x00002, METargetsAttribute)
const FTNoDuration: (uint32,MagicEffectFlags) = (0x00004, MENoDuration)
const FTNoMagnitude: (uint32,MagicEffectFlags) = (0x00008, MENoMagnitude)
const FTHarmful: (uint32,MagicEffectFlags) = (0x00010, MEHarmful)
const FTContinuousVFX: (uint32,MagicEffectFlags) = (0x00020, MEContinuousVFX)
const FTCanCastOnSelf: (uint32,MagicEffectFlags) = (0x00040, MECanCastSelf)
const FTCanCastOnTouch: (uint32,MagicEffectFlags) = (0x00080, MECanCastTouch)
const FTCanCastOnTarget: (uint32,MagicEffectFlags) = (0x00100, MECanCastTarget)
const FTSpellmaking: (uint32,MagicEffectFlags) = (0x00200, MESpellMaking)
const FTEnchanting: (uint32,MagicEffectFlags) = (0x00400, MEEnchanting)
const FTNegativeLighting: (uint32,MagicEffectFlags) = (0x00800, MENegLight)
const FTAppliedOnce: (uint32,MagicEffectFlags) = (0x01000, MEApplyOnce)
const FTStealth: (uint32,MagicEffectFlags) = (0x02000, MEStealth)
const FTCannotRecast: (uint32,MagicEffectFlags) = (0x04000, MECantRecast)
const FTIllegalDaedra: (uint32,MagicEffectFlags) = (0x08000, MEIllDeadra)
const FTUnreflectable: (uint32,MagicEffectFlags) = (0x10000, MENoReflect)
const FTLinkedToCaster: (uint32,MagicEffectFlags) = (0x20000, MELinkCaster)

const meFlagLookup = [FTTargetsSkill, FTTargetsAttribute, FTNoDuration,
        FTNoMagnitude, FTHarmful, FTContinuousVFX,
FTCanCastOnSelf, FTCanCastOnTarget, FTCanCastOnTouch, FTSpellmaking,
        FTEnchanting, FTNegativeLighting, FTAppliedOnce,
FTStealth, FTCannotRecast, FTIllegalDaedra, FTUnreflectable, FTLinkedToCaster]

using
    r: MGEF

proc id*(r): EffectIndex =
    effectAssert(r.INDX)
    result = EffectIndex(r.INDX)

func data*(r): MagicEffectData = r.MEDT
proc school*(r): SpellSchool =
    let idx = data(r).school
    assert(idx < 6, "Magic School Index > 5: " & $idx)
    SpellSchool(idx)
func baseCost*(r): float32 = data(r).base_cost

proc flags*(r): set[MagicEffectFlags] =
    let f = data(r).flags
    for _, x in meFlagLookup:
        let (check,incl) = x
        if hasFlag(f, check):
            result.incl(incl)

func lightingRed*(r): uint32 = data(r).red
func lightingGreen*(r): uint32 = data(r).green
func lightingBlue*(r): uint32 = data(r).blue

func speed*(r): float32 = data(r).speed_x
func size*(r): float32 = data(r).size_x
func sizeCap*(r): float32 = data(r).size_cap

func effectIcon*(r): Option[string] = r.ITEX
func particleTexture*(r): Option[string] = r.PTEX
func boltSound*(r): Option[string] = r.BSND
func castingSound*(r): Option[string] = r.CSND
func hitSound*(r): Option[string] = r.HSND
func areaSound*(r): Option[string] = r.ASND
func castingVfx*(r): Option[string] = r.CVFX
func boltVfx*(r): Option[string] = r.BVFX
func hitVfx*(r): Option[string] = r.HVFX
func areaVfx*(r): Option[string] = r.AVFX
func desc*(r): Option[string] = r.DESC

proc `$`*(r): string =
    result = "MGEF"
    result.add `T$`(r)
