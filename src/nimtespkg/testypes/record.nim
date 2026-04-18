import std/[options, colors, strutils]
import ../util

const TES3RecordLabels* = ["ACTI", "ACLH", "APPA", "ARMO", "BODY", "BOOK",
        "BSGN", "CELL", "CLAS", "CLOT", "CONT", "CREA", "DIAL", "DOOR", "ENCH",
        "FACT", "GLOB", "GMST", "INFO", "INGR", "LAND", "LEVC", "LEVI", "LIGH",
        "LOCK", "LTEX", "MGEF", "MISC", "NPC_", "PGRD", "PROB", "RACE", "REGN",
        "REPA", "SCPT", "SKIL", "SNDG", "SOUN",
        "SPEL", "SSCR", "STAT", "TES3", "WEAP"]

const PETTY_SOUL*: uint32 = 30
const LESSER_SOUL*: uint32 = 60
const COMMON_SOUL*: uint32 = 120
const GREATER_SOUL*: uint32 = 180
const GRAND_SOUL*: uint32 = 600
const AZURA_SOUL*: uint32 = 1000

const BIPED*: uint32 = 1
const RESPAWN*: uint32 = 2
const WEAP_SHIELD*: uint32 = 3
const SWIMS*: uint32 = 10
const WALKS*: uint32 = 40
const ESSENTIAL*: uint32 = 80

const AUTO_CALC*: uint32 = 0x01

# AI Flags...later
const AI_WEAPON = 0x00001
const AI_ARMOR = 0x00002
const AI_CLOTH = 0x00004
const AI_BOOKS = 0x00008
const AI_INGR = 0x00010
const AI_PICKS = 0x00020
const AI_PROBES = 0x00040
const AI_LIGHTS = 0x00080
const AI_APPA = 0x00100
const AI_RPITEMS = 0x00200
const AI_MISC = 0x00400
const AI_SPELLS = 0x00800
const AI_MGITEM = 0x01000
const AI_POTIONS = 0x02000
const AI_TRAIN = 0x04000
const AI_SPELLMAKING = 0x08000
const AI_ENCHANT = 0x10000
const AI_REPAIR = 0x20000
    # 0x00001 = Weapon
    # 0x00002 = Armor
    # 0x00004 = Clothing
    # 0x00008 = Books
    # 0x00010 = Ingredient
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

type
    EffectIndex* = enum
        Water_Breathing = (0, "sEffectWaterBreathing"),
        Swift_Swim = (1, "sEffectSwiftSwim"),
        Water_Walking = (2, "sEffectWaterWalking"),
        Shield = (3, "sEffectShield"),
        Fire_Shield = (4, "sEffectFireShield"),
        Lightning_Shield = (5, "sEffectLightningShield"),
        Frost_Shield = (6, "sEffectFrostShield"),
        Burden = (7, "sEffectBurden"),
        Feather = (8, "sEffectFeather"),
        Jump = (9, "sEffectJump"),
        Levitate = (10, "sEffectLevitate"),
        SlowFall = (11, "sEffectSlowFall"),
        Lock = (12, "sEffectLock"),
        Open = (13, "sEffectOpen"),
        Fire_Damage = (14, "sEffectFireDamage"),
        Shock_Damage = (15, "sEffectShockDamage"),
        Frost_Damage = (16, "sEffectFrostDamage"),
        Drain_Attribute = (17, "sEffectDrainAttribute"),
        Drain_Health = (18, "sEffectDrainHealth"),
        Drain_Magicka = (19, "sEffectDrainSpellpoints"),
        Drain_Fatigue = (20, "sEffectDrainFatigue"),
        Drain_Skill = (21, "sEffectDrainSkill"),
        Damage_Attribute = (22, "sEffectDamageAttribute"),
        Damage_Health = (23, "sEffectDamageHealth"),
        Damage_Magicka = (24, "sEffectDamageMagicka"),
        Damage_Fatigue = (25, "sEffectDamageFatigue"),
        Damage_Skill = (26, "sEffectDamageSkill"),
        Poison = (27, "sEffectPoison"),
        Weakness_to_Fire = (28, "sEffectWeaknessToFire"),
        Weakness_to_Frost = (29, "sEffectWeaknessToFrost"),
        Weakness_to_Shock = (30, "sEffectWeaknessToShock"),
        Weakness_to_Magicka = (31, "sEffectWeaknessToMagicka"),
        Weakness_to_Common_Disease = (32, "sEffectWeaknessToCommonDisease"),
        Weakness_to_Blight_Disease = (33, "sEffectWeaknessToBlightDisease"),
        Weakness_to_Corprus_Disease = (34, "sEffectWeaknessToCorprusDisease"),
        Weakness_to_Poison = (35, "sEffectWeaknessToPoison"),
        Weakness_to_Normal_Weapons = (36, "sEffectWeaknessToNormalWeapons"),
        Disintegrate_Weapon = (37, "sEffectDisintegrateWeapon"),
        Disintegrate_Armor = (38, "sEffectDisintegrateArmor"),
        Invisibility = (39, "sEffectInvisibility"),
        Chameleon = (40, "sEffectChameleon"),
        Light = (41, "sEffectLight"),
        Sanctuary = (42, "sEffectSanctuary"),
        Night_Eye = (43, "sEffectNightEye"),
        Charm = (44, "sEffectCharm"),
        Paralyze = (45, "sEffectParalyze"),
        Silence = (46, "sEffectSilence"),
        Blind = (47, "sEffectBlind"),
        Sound = (48, "sEffectSound"),
        Calm_Humanoid = (49, "sEffectCalmHumanoid"),
        Calm_Creature = (50, "sEffectCalmCreature"),
        Frenzy_Humanoid = (51, "sEffectFrenzyHumanoid"),
        Frenzy_Creature = (52, "sEffectFrenzyCreature"),
        Demoralize_Humanoid = (53, "sEffectDemoralizeHumanoid"),
        Demoralize_Creature = (54, "sEffectDemoralizeCreature"),
        Rally_Humanoid = (55, "sEffectRallyHumanoid"),
        Rally_Creature = (56, "sEffectRallyCreature"),
        Dispel = (57, "sEffectDispel"),
        Soultrap = (58, "sEffectSoultrap"),
        Telekinesis = (59, "sEffectTelekinesis"),
        Mark = (60, "sEffectMark"),
        Recall = (61, "sEffectRecall"),
        Divine_Intervention = (62, "sEffectDivineIntervention"),
        Almsivi_Intervention = (63, "sEffectAlmsiviIntervention"),
        Detect_Animal = (64, "sEffectDetectAnimal"),
        Detect_Enchantment = (65, "sEffectDetectEnchantment"),
        Detect_Key = (66, "sEffectDetectKey"),
        Spell_Absorption = (67, "sEffectSpellAbsorption"),
        Reflect = (68, "sEffectReflect"),
        Cure_Common_Disease = (69, "sEffectCureCommonDisease"),
        Cure_Blight_Disease = (70, "sEffectCureBlightDisease"),
        Cure_Corprus_Disease = (71, "sEffectCureCorprusDisease"),
        Cure_Poison = (72, "sEffectCurePoison"),
        Cure_Paralyzation = (73, "sEffectCureParalyzation"),
        Restore_Attribute = (74, "sEffectRestoreAttribute"),
        Restore_Health = (75, "sEffectRestoreHealth"),
        Restore_Magicka = (76, "sEffectRestoreSpellPoints"),
        Restore_Fatigue = (77, "sEffectRestoreFatigue"),
        Restore_Skill = (78, "sEffectRestoreSkill"),
        Fortify_Attribute = (79, "sEffectFortifyAttribute"),
        Fortify_Health = (80, "sEffectFortifyHealth"),
        Fortify_Magicka = (81, "sEffectFortifySpellpoints"),
        Fortify_Fatigue = (82, "sEffectFortifyFatigue"),
        Fortify_Skill = (83, "sEffectFortifySkill"),
        Fortify_Maximum_Magicka = (84, "sEffectFortifyMagickaMultiplier"),
        Absorb_Attribute = (85, "sEffectAbsorbAttribute"),
        Absorb_Health = (86, "sEffectAbsorbHealth"),
        Absorb_Magicka = (87, "sEffectAbsorbSpellPoints"),
        Absorb_Fatigue = (88, "sEffectAbsorbFatigue"),
        Absorb_Skill = (89, "sEffectAbsorbSkill"),
        Resist_Fire = (90, "sEffectResistFire"),
        Resist_Frost = (91, "sEffectResistFrost"),
        Resist_Shock = (92, "sEffectResistShock"),
        Resist_Magicka = (93, "sEffectResistMagicka"),
        Resist_Common_Disease = (94, "sEffectResistCommonDisease"),
        Resist_Blight_Disease = (95, "sEffectResistBlightDisease"),
        Resist_Corprus_Disease = (96, "sEffectResistCorprusDisease"),
        Resist_Poison = (97, "sEffectResistPoison"),
        Resist_Normal_Weapons = (98, "sEffectResistNormalWeapons"),
        Resist_Paralysis = (99, "sEffectResistParalysis"),
        Remove_Curse = (100, "sEffectRemoveCurse"),
        Turn_Undead = (101, "sEffectTurnUndead"),
        Summon_Scamp = (102, "sEffectSummonScamp"),
        Summon_Clannfear = (103, "sEffectSummonClannfear"),
        Summon_Daedroth = (104, "sEffectSummonDaedroth"),
        Summon_Dremora = (105, "sEffectSummonDremora"),
        Summon_Ancestral_Ghost = (106, "sEffectSummonAncestralGhost"),
        Summon_Skeletal_Minion = (107, "sEffectSummonSkeletalMinion"),
        Summon_Bonewalker = (108, "sEffectSummonLeastBonewalker"),
        Summon_Greater_Bonewalker = (109, "sEffectSummonGreaterBonewalker"),
        Summon_Bonelord = (110, "sEffectSummonBonelord"),
        Summon_Winged_Twilight = (111, "sEffectSummonWingedTwilight"),
        Summon_Hunger = (112, "sEffectSummonHunger"),
        Summon_Golden_Saint = (113, "sEffectSummonGoldensaint"),
        Summon_Flame_Atronach = (114, "sEffectSummonFlameAtronach"),
        Summon_Frost_Atronach = (115, "sEffectSummonFrostAtronach"),
        Summon_Storm_Atronach = (116, "sEffectSummonStormAtronach"),
        Fortify_Attack = (117, "sEffectFortifyAttackBonus"),
        Command_Creature = (118, "sEffectCommandCreatures"),
        Command_Humanoid = (119, "sEffectCommandHumanoids"),
        Bound_Dagger = (120, "sEffectBoundDagger"),
        Bound_Longsword = (121, "sEffectBoundLongsword"),
        Bound_Mace = (122, "sEffectBoundMace"),
        Bound_Battle_Axe = (123, "sEffectBoundBattleAxe"),
        Bound_Spear = (124, "sEffectBoundSpear"),
        Bound_Longbow = (125, "sEffectBoundLongbow"),
        EXTRA_SPELL = (126, "sEffectExtraSpell"),
        Bound_Cuirass = (127, "sEffectBoundCuirass"),
        Bound_Helm = (128, "sEffectBoundHelm"),
        Bound_Boots = (129, "sEffectBoundBoots"),
        Bound_Shield = (130, "sEffectBoundShield"),
        Bound_Gloves = (131, "sEffectBoundGloves"),
        Corprus = (132, "sEffectCorpus"),
        Vampirism = (133, "sEffectVampirism"),
        Summon_Centurion_Sphere = (134, "sEffectSummonCenturionSphere"),
        Sun_Damage = (135, "sEffectSunDamage"),
        Stunted_Magicka = (136, "sEffectStuntedMagicka"),
        Summon_Fabricant = (137, "sEffectSummonFabricant"),
        Call_Wolf = (138, "sEffectSummonCreature01"),
        Call_Bear = (139, "sEffectSummonCreature02"),
        Summon_Bonewolf = (140, "sEffectSummonCreature03"),
        sEffectSummonCreature04 = (141, "sEffectSummonCreature04"),
        sEffectSummonCreature05 = (142, "sEffectSummonCreature05"),
    AttributeIndex* = enum
        NoAttr = (-1, "None")
        Strength,
        Intelligence,
        Willpower,
        Agility,
        Speed,
        Endurance,
        Personality,
        Luck
    SkillIndex* = enum
        NoSkill = (-1, "None"),
        Block,
        Armorer,
        Medium_Armor = "Medium Armor",
        Heavy_Armor = "Heavy Armor",
        Blunt_Weapon = "Blunt Weapon",
        Long_Blade = "Long Blade",
        Axe,
        Spear,
        Athletics,
        Enchant,
        Destruction,
        Alteration,
        Illusion,
        Conjuration,
        Mysticism,
        Restoration,
        Alchemy,
        Unarmored,
        Security,
        Sneak,
        Acrobatics,
        Light_Armor = "Light Armor",
        Short_Blade = "Short Blade",
        Marksman,
        Mercantile,
        Speechcraft,
        Hand_To_Hand = "Hand to Hand"
    ItemSlot* = enum
        Head = 0,
        Hair,
        Neck,
        Cuirass,
        Groin,
        Skirt,
        RightHand = "Right Hand",
        LeftHand = "Left Hand",
        RightWrist = "Right Wrist",
        LeftWrist = "Left Wrist",
        Shield,
        RightForearm = "Right Forearm",
        LeftForearm = "Left Forearm",
        RightUpperArm = "Right Upper Arm",
        LeftUpperArm = "Left Upper Arm",
        RightFoot = "Right Foot",
        LeftFoot = "Left Foot",
        RightAnkle = "Right Ankle"
        LeftAnkle = "Left Ankle"
        RightKnee = "Right Knee",
        LeftKnee = "Left Knee",
        RightUpperLeg = "Right Upper Leg",
        LeftUpperLeg = "Left Upper Leg",
        RightPauldron = "Right Pauldron",
        LeftPauldron = "Left Pauldron",
        Weapon,
        Tail
    DialogueKind* = enum
        DNone = -1,
        RegularTopic = (0, "Regular Topic"),
        Voice,
        Greeting,
        Persuasion,
        Journal
    AIServices* = enum 
        AWeapon = (0,"Sells Weapons"),
        AArmor = "Sells Armor",
        AClothing = "Sells Clothing",
        ABooks = "Sells Books",
        AIngr = "Sells Ingredients",
        APicks = "Sells Lockpicks",
        AProbes = "Sells Probes",
        ALights = "Sells Lights",
        AAppa = "Sells Apparatus",
        ARepairItems = "Sells Repair Items",
        AMisc = "Sells Misc Items",
        ASpells = "Sells Spells",
        AMagic = "Sells Magic Items",
        APotions = "Sells Potions",
        ATraining = "Provides Training Service",
        ASpellmaking = "Provides Spellmaking Service",
        AEnchant = "Provides Enchant Service",
        ARepair = "Provides Repair Service"
    SpellRange* = enum 
        RSelf = (0,"Self")
        RTouch = "Touch"
        RTarget = "Target"
    SpecializationKind* = enum 
        Combat = 0,
        Magic,
        Stealth






type
    AttributeRange* = range[0..7]
    SkillRange* = range[0..26]
    EffectRange* = range[0..142]
    TagList*[T] = distinct seq[T]
    ScriptData* = distinct seq[uint8]
    DataField* = ref object of RootObj
    TES3Record* = ref object of RootObj
        size*: uint32
        flags*: uint32
    RGBA* = ref object of DataField
        r*: uint8
        g*: uint8
        b*: uint8
        a*: uint8
    RGB* = ref object of DataField
        r*: uint8
        g*: uint8
        b*: uint8
    RGBO* = object
        r*: uint8
        g*: uint8
        b*: uint8
    Coords* = ref object of DataField
        x*: int32
        y*: int32
    CellPosition* = ref object of DataField
        posx*: float32
        posy*: float32
        posz*: float32
        rotx*: float32
        roty*: float32
        rotz*: float32
    CellTravelData* = object
        DODT: CellPosition
        DNAM: Option[string]
    PackageKind* = enum
        Activate,
        Escort,
        Follow,
        Travel,
        Wander
    AI_Package* = object
        case kind*: PackageKind
        of Activate:
            AI_A*: ActivatePkg
        of Escort:
            AI_E*: EscortPkg
        of Follow:
            AI_F*: FollowPkg
        of Travel:
            AI_T*: TravelPkg
        of Wander:
            AI_W*: WanderPkg
    ActivatePkg* = object
        name*{.zsize(32).}: string
        unknown*: uint8 #made public so that compiler won't yell read.nim 170~
    FollowerData* = object #escort and follow
        x*: float32
        y*: float32
        z*: float32
        duration*: uint16
        id*{.zsize(32).}: string
        unknown*: uint8    #made public so that compiler won't yell read.nim 174~
        unused*: uint8     #made public so that compiler won't yell read.nim 174~
    EscortPkg* = object
        AI_E*: FollowerData
        CNDT*: Option[string]
    FollowPkg* = object
        AI_F*: FollowerData
        CNDT*: Option[string]
    TravelPkg* = object
        x*: float32
        y*: float32
        z*: float32
        unknown: uint8
        unused: array[3, uint8]
    WanderPkg* = object
        distance*: uint16
        duration*: uint16
        timeofday*: uint8
        idles*: array[8, uint8]
        unknown: uint8
    AIData* = ref object of DataField
        hello: uint8
        junk1: uint8
        fight: uint8
        flee: uint8
        alarm: uint8
        junk2: array[3, uint8]
        flags: uint32
    CarriedObject*[T:int32|uint32] = ref object of DataField
        count*: T
        name*{.zsize(32).}: string
    EnchantmentData* = ref object of DataField
        effect_idx: uint16
        skill: int8
        attribute: int8
        erang: uint32
        area: uint32
        duration: uint32
        mag_min: uint32
        mag_max: uint32
    BipedObject* = object
        INDX: uint32
        BNAM: Option[string]
        CNAM: Option[string]
    NPCStats* = object
        attributes*: array[8,uint8]
        skills*: array[27,uint8]
        health*: uint16
        spell_pts*: uint16
        fatigue*: uint16
    NPCData* = object
        level*: uint16
        disposition*: uint8
        reputation*: uint8
        rank*: uint8
        gold*: uint32
        stats*: Option[NPCStats]
    FlagTuple*[T:enum] = tuple[check:uint32,incl:T]
    ConsumableItem* = ref object of DataField
        weight*: float32
        value*: uint32
        quality*:float32
        uses*:uint32




func flagtup*[T:enum](c: int, f: T): FlagTuple[T] = (check: uint32(c), incl:f)
# SpecializationKind
proc spec_assert*(r: SomeUnsignedInt) = 
    assert(r < 4,"Invalid Specialization number: " & $r)

proc spec_assert*(r: SomeInteger) = 
    assert(r < 4,"Invalid Specialization number: " & $r)

proc attribute_assert*(r: SomeUnsignedInt) =
    assert(r < 8, "Invalid attribute index: " & $r)

proc attribute_assert*(r: SomeInteger) =
    assert(r < 8 and r >= -1, "Invalid attribute index: " & $r)

proc skill_assert*(r: SomeUnsignedInt) =
    assert(r < 27, "Invalid skill index: " & $r)

proc skill_assert*(r: SomeInteger) =
    assert(r < 27 and r >= -1, "Invalid skill index: " & $r)

proc effect_assert*(r: SomeInteger) =
    assert(r < 143 and r >= -1, "Invalid effect index: " & $r)

proc effect_assert*(r: SomeUnsignedInt) =
    assert(r < 143, "Invalid effect index: " & $r)

proc to_attributes*[R,T:SomeInteger|SomeUnsignedInt](r:array[R,T]): array[R,AttributeIndex] =
    for idx,a in pairs(r):
        attribute_assert(a)
        result[idx] = AttributeIndex(a)

proc to_skills*[R,T:SomeInteger|SomeUnsignedInt](r:array[R,T]): array[R,SkillIndex] =
    for idx,s in pairs(r):
        skill_assert(s)
        result[idx] = SkillIndex(s)

proc to_effects*[R,T:SomeInteger|SomeUnsignedInt](r:array[R,T]): array[R,EffectIndex] =
    for idx,e in pairs(r):
        effect_assert(e)
        result[idx] = EffectIndex(e)

func item_count*[T:int32|uint32](r:CarriedObject[T]): T = r.count
func item_name*[T:int32|uint32](r:CarriedObject[T]): string = stripNull(r.name)


func to_color*(r: RGBA): Color = rgb(r.r, r.g, r.b)
func to_color*(r: RGB): Color = rgb(r.r, r.g, r.b)
func to_color*(r: RGBO): Color = rgb(r.r, r.g, r.b)

proc `$`*(r: RGBA): string = $to_color(r)
proc `$`*(r: RGB): string = $to_color(r)
proc `$`*(r: RGBO): string = $to_color(r)

proc dele_flag*(r: TES3Record): bool = has_flag(r.flags, 0x0020)
proc persist_ref*(r: TES3Record): bool = has_flag(r.flags, 0x0400)
proc init_disabled*(r: TES3Record): bool = has_flag(r.flags, 0x0800)
proc blocked*(r: TES3Record): bool = has_flag(r.flags, 0x2000)

func hello*(r: AIData): uint8 = r.hello
func fight*(r: AIData): uint8 = r.fight
func flee*(r: AIData): uint8 = r.flee
func alarm*(r: AIData): uint8 = r.alarm

let aiServiceLookup = [flagtup(AI_WEAPON,AWeapon),flagtup(AI_ARMOR,AArmor),
    flagtup(AI_CLOTH,AClothing),flagtup(AI_BOOKS,ABooks),flagtup(AI_INGR,AIngr),
    flagtup(AI_PICKS,APicks),flagtup(AI_PROBES,AProbes),flagtup(AI_LIGHTS,ALights),
    flagtup(AI_APPA,AAppa),flagtup(AI_RPITEMS,ARepairItems),flagtup(AI_MISC,AMisc),
    flagtup(AI_SPELLS,ASpells),flagtup(AI_MGITEM,AMagic),flagtup(AI_POTIONS,APotions),
    flagtup(AI_TRAIN,ATraining),flagtup(AI_SPELLMAKING,ASpellmaking),
    flagtup(AI_ENCHANT,AEnchant),flagtup(AI_REPAIR,ARepair)]

proc flags*(r: AIData): set[AIServices] = 
    for _,f in aiServiceLookup:
        let (check,incl) = f
        if has_flag(r.flags,check):
            result.incl(incl)


func travel_dest*(r: CellTravelData): CellPosition = r.DODT
func prev_dest_name*(r: CellTravelData): Option[string] = r.DNAM

proc effect*(r: EnchantmentData): EffectIndex = 
    effect_assert(r.effect_idx)
    EffectIndex(r.effect_idx)
proc attr_affected*(r: EnchantmentData): AttributeIndex = 
    attribute_assert(r.attribute)
    AttributeIndex(r.attribute)
proc skill_affected*(r: EnchantmentData): SkillIndex = 
    skill_assert(r.skill)
    SkillIndex(r.skill)
func effect_range*(r:EnchantmentData): SpellRange = SpellRange(r.erang)
func aoe*(r: EnchantmentData): uint32 = r.area
func duration*(r: EnchantmentData): uint32 = r.duration
func magnitude*(r: EnchantmentData): tuple[min: uint32, max: uint32] = (
    min: r.mag_min, max: r.mag_max)


func item_slot*(r: BipedObject): ItemSlot = ItemSlot(uint8(r.INDX))
func male_name*(r: BipedObject): Option[string] = r.BNAM
func female_name*(r: BipedObject): Option[string] =
    if isSome(r.CNAM):
        return r.CNAM
    else:
        return r.BNAM

func attributes*(r:NPCStats):array[8,AttributeIndex] = 
    for idx,a in r.attributes:
        attribute_assert(a)
        result[idx] = AttributeIndex(a)

func skills*(r:NPCStats):array[27,SkillIndex] = 
    for idx,s in r.skills:
        skill_assert(s)
        result[idx] = SkillIndex(s)

func health*(r:NPCStats): uint16 = r.health
func spell_points*(r:NPCStats): uint16 = r.spell_pts
func fatigue*(r:NPCStats): uint16 = r.fatigue

const INDENT* = 2

proc `T$`*(r: AIData): string =
    result = "AIDT\n"
    result.add indent("Sells:" & $flags(r), INDENT) & "\n"

    result.add indent("Alarm:" & $alarm(r), INDENT) & "\n"
    result.add indent("Hello:" & $hello(r), INDENT) & "\n"
    result.add indent("Fight:" & $fight(r), INDENT) & "\n"
    result.add indent("Flee:" & $flee(r), INDENT)


proc `T$`*(r: EnchantmentData): string =
    result = "ENAM:\n"
    result.add indent("Effect:" & $effect(r), INDENT) & "\n"
    result.add indent("Skill Affected:" & $skill_affected(r), INDENT) & "\n"
    result.add indent("Attributed Affected:" & $attr_affected(r), INDENT) & "\n"
    
    result.add indent("Range:" & $effect_range(r), INDENT) & "\n"
    result.add indent("Area of Effect:" & $aoe(r), INDENT) & "\n"
    result.add indent("Duration:" & $duration(r), INDENT) & "\n"
    result.add indent("Magnitude Min:" & $r.mag_min, INDENT) & "\n"
    result.add indent("Magnitude Max:" & $r.mag_max, INDENT)

proc `T$`*[T, D](r: array[T, D]): string
proc `T$`*[T: SomeFloat|SomeInteger|bool|string](r: T): string
proc `T$`*[T](r: seq[T]): string
proc `T$`*[T](r: ref T): string
proc `T$`*[T: object](r: T): string
proc `T$`*[T](r: TagList[T]): string

proc `T$`*[T, D](r: array[T, D]): string = $r
proc `T$`*[T: SomeFloat|SomeInteger|bool|string](r: T): string = $r
proc `T$`*[T](r: seq[T]): string =
    result.add "[\n"
    var items:seq[string] = @[]
    for i in r:
        var collect:string
        collect.add "{\n"
        collect.add `T$` i
        collect.add "\n"
        collect.add "}\n"
        items.add collect
    result.add join(items,",\n")
    result.add "]\n"
proc `T$`*[T:enum](r:T): string = $r
proc `T$`*[T](r: TagList[T]): string = result = `T$`(seq[T](r))
proc `T$`*(r: ScriptData): string = result = "len:" & $len(seq[uint8](r))
proc `T$`*[T](r: ref T): string = `T$`(r[])
proc `T$`*[T: object](r: T): string =
    result = ""
    for key, value in fieldPairs(r):
        result.add "\n"
        when value is Option:
            if isSome(value):
                result.add indent(key & ":" & stripNull(`T$`(get(value))), INDENT)
        else:
            result.add indent(key & ":" & stripNull(`T$`(value)), INDENT)

proc `T$`*[T: TES3Record](r: T): string =
    result = "\n"
    for key, value in fieldPairs(r[]):
        when value is Option:
            if isSome(value):
                result.add indent(key & ":" & stripNull(`T$`(get(value))),
                        INDENT) & "\n"
        else:
            result.add indent(key & ":" & stripNull(`T$`(value)), INDENT) & "\n"

export hasFlag,stripNull,zsize,dtag,INDENTAMT
