import std/macros

type
    TES3Kind* = enum
        ACTI = "ACTI",
        ALCH = "ALCH",
        APPA = "APPA",
        ARMO = "ARMO",
        BODY = "BODY",
        BOOK = "BOOK",
        BSGN = "BSGN",
        CELL = "CELL",
        CLAS = "CLAS",
        CLOT = "CLOT",
        CONT = "CONT",
        CREA = "CREA",
        DIAL = "DIAL",
        DOOR = "DOOR",
        ENCH = "ENCH",
        FACT = "FACT",
        GLOB = "GLOB",
        GMST = "GMST",
        INFO = "INFO",
        INGR = "INGR",
        LAND = "LAND",
        LEVC = "LEVC",
        LEVI = "LEVI",
        LIGH = "LIGH",
        LOCK = "LOCK",
        LTEX = "LTEX",
        MGEF = "MGEF",
        MISC = "MISC",
        NPC = "NPC_",
        PGRD = "PGRD",
        PROB = "PROB",
        RACE = "RACE",
        REGN = "REGN",
        REPA = "REPA",
        SCPT = "SCPT",
        SKIL = "SKIL",
        SNDG = "SNDG",
        SOUN = "SOUN",
        SPEL = "SPEL",
        SSCR = "SSCR",
        STAT = "STAT",
        TES3 = "TES3",
        WEAP = "WEAP"
    AIDataFlags* {.size: sizeof(uint32).} = enum
        AIWeapon = (0x00001, "Weapon")
        AIArmor = (0x00002, "Armor")
        AIClothing = (0x00004, "Clothing")
        AIBooks = (0x00008, "Books")
        AIIngredient = (0x00010, "Ingredients")
        AIPicks = (0x00020, "Picks")
        AIProbes = (0x00040, "Probes")
        AILights = (0x00080, "Lights")
        AIApparatus = (0x00100, "Apparatus")
        AIRepairItems = (0x00200, "Repair Items")
        AIMisc = (0x00400, "Misc")
        AISpells = (0x00800, "Spells")
        AIMagicItems = (0x01000, "Magic Items")
        AIPotions = (0x02000, "Potions")
        AITraining = (0x04000, "Training")
        AISpellmaking = (0x08000, "Spellmaking")
        AIEnchanting = (0x10000, "Enchanting")
        AIRepair = (0x20000, "Repair")
    CreatureKind* {.size: sizeof(uint32).} = enum
        Creature
        Daedra
        Undead
        Humanoid
    ClassAutoCalcFlags* {.size: sizeof(uint32).} = enum
        CAutoWeapon = (0x00001, "Weapon")
        CAutoArmor = (0x00002, "Armor")
        CAutoClothing = (0x00004, "Clothing")
        CAutoBooks = (0x00008, "Books")
        CAutoIngredients = (0x00010, "Ingredients")
        CAutoPicks = (0x00020, "Picks")
        CAutoProbes = (0x00040, "Probes")
        CAutoLights = (0x00080, "Lights")
        CAutoApparatus = (0x00100, "Apparatus")
        CAutoRepairItems = (0x00200, "Repair Items")
        CAutoMisc = (0x00400, "Misc")
        CAutoSpells = (0x00800, "Spells")
        CAutoMagicItems = (0x01000, "Magic Items")
        CAutoPotions = (0x02000, "Potions")
        CAutoTraining = (0x04000, "Training")
        CAutoSpellmaking = (0x08000, "Spellmaking")
        CAutoEnchanting = (0x10000, "Enchanting")
        CAutoRepair = (0x20000, "Repair")
    NPCFlags* {.size: sizeof(uint32).} = enum
        NPCFemale = (0x0001, "Female")
        NPCEssential = (0x0002, "Essential")
        NPCRespawn = (0x0004, "Respawn")
        NPCUnknown = (0x0008, "Unknown")
        NPCAutocalc = (0x0010, "Autocalc")
        NPCBloodSkeleton = (0x0400, "Blood Texture: Skeleton")
        NPCBloodMetalSparks = (0x0800, "Blood Texture: Metal Sparks")
    RangeKind* = enum
        RSELF = (0, "Self")
        RTOUCH = (1, "Touch")
        RTARGET = (2, "Target")
    AlchemyAppKind* = enum
        MortarPestle = (0, "Mortar and Pestle")
        Alembic = (1, "Alembic")
        Calcinator = (2, "Calcinator")
        Retor = (3, "Retort")
    AIPackageKind* = enum
        AIActivate
        AIEscort
        AIFollow
        AITravel
        AIWander
    ArmorKind* {.size: sizeof(uint32).} = enum
        AHELMET = (0, "Helmet")
        ACUIRASS = (1, "Cuirass")
        ALEFT_PAULD = (2, "Left Pauldron")
        ARIGHT_PAULD = (3, "Right Pauldron")
        AGREAVES = (4, "Greaves")
        ABOOTS = (5, "Boots")
        ALEFT_GAUNT = (6, "Left Gauntlet")
        ARIGHT_GAUNT = (7, "Right Gauntlet")
        ASHILED = (8, "Shield")
        ALEFT_BRACER = (9, "Left Bracer")
        ARIGHT_BRACER = (10, "Right Bracer")
    Attributes* = enum
        Strength = "Strength"
        Intelligence = "Intelligence"
        Willpower = "Willpower"
        Agility = "Agility"
        Endurance = "Endurance"
        Personality = "Personality"
        Luck = "Luck"
    BipedObjectKind* {.size: sizeof(uint32).} = enum
        BHEAD = (0, "Head")
        BHAIR = (1, "Hair")
        BNECK = (2, "Neck")
        BCUIRASS = (3, "Cuirass")
        BGROIN = (4, "Groin")
        BSKIRT = (5, "Skirt")
        BRIGHT_HAND = (6, "Right Hand")
        BLEFT_HAND = (7, "Left Hand")
        BRIGHT_WRIST = (8, "Right Wrist")
        BLEFT_RIGHT = (9, "Left Wrist")
        BSHIELD = (10, "Shield")
        BRIGHT_FOREARM = (11, "Right Forearm")
        BLEFT_FOREARM = (12, "Left Forearm")
        BRIGHT_UPARM = (13, "Right Upper Arm")
        BLEFT_UPARM = (14, "Left Upper Arm")
        BRIGHT_FOOT = (15, "Right Foot")
        BLEFT_FOOT = (16, "Left Foot")
        BRIGHT_ANKLE = (17, "Right Ankle")
        BLEFT_ANKLE = (18, "Left Ankle")
        BRIGHT_KNEE = (19, "Right Knee")
        BLEFT_KNEE = (20, "Left Knee")
        BRIGHT_UPLEG = (21, "Right Upper Leg")
        BLEFT_UPLEG = (22, "Left Upper Leg")
        BRIGHT_PAULD = (23, "Right Pauldron")
        BLEFT_PAULD = (24, "Left Pauldron")
        BWEAPON = (25, "Weapon")
        BTAIL = (26, "Tail")
    CellDataFlags* {.size: sizeof(uint32).} = enum
        CInterior = (0x01, "Interior")
        CWater = (0x02, "Has Water")
        CIllegal = (0x04, "Illegal to Sleep here")
        CFalseInterior = (0x80, "Behave like exterior (Tribunal)")
    GameSettingValue* = enum
        StringValue
        FloatValue
        IntegerValue
    BodyPart* {.size: sizeof(uint8).} = enum
        BPHead = (0, "Head")
        BPHair = (1, "Hair")
        BPNeck = (2, "Neck")
        BPChest = (3, "Chest")
        BPGroin = (4, "Groin")
        BPHand = (5, "Hand")
        BPWrist = (6, "Wrist")
        BPForearm = (7, "Forearm")
        BPUpperArm = (8, "Upperarm")
        BPFoot = (9, "Foot")
        BPAnkle = (10, "Ankle")
        BPKnee = (11, "Knee")
        BPUpperleg = (12, "Upperleg")
        BPClavicle = (13, "Clavicle")
        BPTail = (14, "Tail")
    BodyFlags* {.size: sizeof(uint8).} = enum
        BFemale = (1, "Female")
        BPlayable = (2, "Playable")
    BodyPartKind* {.size: sizeof(uint8).} = enum
        KSkin = (0, "Skin")
        KClothing = (1, "Clothing")
        KArmor = (2, "Armor")
    ClothingKind* {.size: sizeof(uint32).} = enum
        CPants = (0, "Pants")
        CShoes = (1, "Shoes")
        CShirt = (2, "Shirt")
        CBelt = (3, "Belt")
        CRobe = (4, "Robe")
        CRightGlove = (5, "Right Glove")
        CLeftGlove = (6, "Left Glove")
        CSkirt = (7, "Skirt")
        CRing = (8, "Ring")
        CAmulet = (9, "Amulet")
    ContainerFlags* {.size: sizeof(uint32).} = enum
        Organic = 0x1
        Respawns = 0x2
        Unknown = 0x8
    CreatureFlags* {.size: sizeof(uint32).} = enum
        CBiped = (0x0001, "Biped")
        CRespawn = (0x0002, "Respawn")
        CWeaponShield = (0x0004, "Weapon and shield")
        CNone = (0x0008, "None")
        CSwims = (0x0010, "Swims")
        CFlies = (0x0020, "Flies")
        CWalks = (0x0040, "Walks")
        CDefault = (0x0048, "Default flags")
        CEssential = (0x0080, "Essential")
        CBlood1 = (0x0400, "Blood Type 1 (Dust)")
        CBlood2 = (0x0800, "Blood Type 2 (Sparks)")
        CBlood3 = (0x0C00, "Blood Type 3")
        CBlood4 = (0x1000, "Blood Type 4")
        CBlood5 = (0x1400, "Blood Type 5")
        CBlood6 = (0x1800, "Blood Type 6")
        CBlood7 = (0x1C00, "Blood Type 7")
    RecordFlags* {.size: sizeof(uint32).} = enum
        None = 0
        Deleted = (0x0020, "Deleted")
        Persistent = (0x0400, "Persistent")
        InitiallyDisabled = (0x0800, "Initially Disabled")
        Blocked = (0x2000, "Blocked")
    Enchantments* = enum
        WaterBreathing = (0, "Water Breathing")
        SwiftSwim = (1, "Swift Swim")
        WaterWalking = (2, "Water Walking")
    LightFlags* {.size: sizeof(uint32).} = enum
        Dynamic = (0x0001, "Dynamic")
        CanCarry = (0x0002, "Can Carry")
        Negative = (0x0004, "Negative")
        Flicker = (0x0008, "Flicker")
        Fire = (0x0010, "Fire")
        OffDefault = (0x0020, "Off by Default")
        FlickerSlow = (0x0040, "Flicker Slow")
        Pulse = (0x0080, "Pulse")
        PulseSlow = (0x0100, "Pulse Slow")
    SpellSchools* = enum
        Alteration
        Conjuration
        Destruction
        Illusion
        Mysticism
        Restoration
    MagicEffectFlags* {.size: sizeof(uint32).} = enum
        TargetSkill = (0x00001, "Targets Skill")
        TargetAttribute = (0x00002, "Targets Attribute")
        NoDuration = (0x00004, "No Duration")
        NoMagnitude = (0x00008, "No Magnitude")
        Harmful = (0x00010, "Harmful")
        ContinuousVFX = (0x00020, "Continuous VFX")
        CanCastOnSelf = (0x00040, "Can Cast On Self")
        CanCastOnTouch = (0x00080, "Can Cast On Touch")
        CanCastOnTarget = (0x00100, "Can Cast On Target")
        Spellmaking = (0x00200, "Spellmaking")
        Enchanting = (0x00400, "Enchanting")
        NegativeLighting = (0x00800, "Negative Lighting")
        AppliedOnce = (0x01000, "Applied Once")
        Stealth = (0x02000, "Stealth")
        CannotRecast = (0x04000, "Cannot Recast")
        IllegalDaedra = (0x08000, "Illegal Daedra")
        Unreflectable = (0x10000, "Unreflectable")
        LinkedToCaster = (0x20000, "Linked To Caster")
    PathGridFlags* {.size: sizeof(uint16).} = enum
        Gran128 = (0x80, "128 granularity")
        Gran256 = (0x100, "256 granularity")
        Gran512 = (0x200, "512 granularity")
        Gran1024 = (0x400, "1024 granularity")
        Gran2048 = (0x800, "2048 granularity")
        Gran4096 = (0x1000, "4096 granularity")
    WeaponKind* {.size: sizeof(uint16).} = enum
        ShortBladeOneHand = (0, "Short Blade")
        LongBladeOneHand = "Long Blade, One Handed"
        LongBladeTwoClose = "Long Blade, Two Handed"
        BluntOneHand = "Blunt Weapon, One Handed"
        BluntTwoClose = "Blunt Weapon, Two Handled"
        BluntTwoWide = "Staff"
        SpearTwoWide = "Spear"
        AxeOneHand = "Axe, One Handed"
        AxeTwoHand = "Axe, Two Handed"
        MarksmanBow = "Bow"
        MarksmanCrossbow = "Crossbow"
        MarksmanThrown = "Thrown Weapon"
        Arrow = "Arrow"
        Bolt = "Bolt"
    WeaponFlags* {.size: sizeof(uint32).} = enum
        WeaponNormal = 0
        IgnoreNormal = (0x1, "Ignore Normal Weapon Resistance")
        Silver = 0x2
    SpellKind* {.size: sizeof(uint32).} = enum
        Spell = "Spell"
        Ability = "Ability"
        Blight = "Blight"
        Disease = "Disease"
        Curse = "Curse"
        Power = "Power"
    SoundKind* = enum
        SLeftFoot
        SRightFoot
        SSwimLeft
        SSwimRight
        SMarksmanThrown
        SRoar
        SScream
        SLand
    SkillKind* = enum
        NoSkill = (-1, "None")
        Block = "Block"
        Armorer = "Armorer"
        MediumArmor = "Medium Armor"
        HeavyArmor = "Heavy Armor"
        BluntWeapon = "Blunt Weapon"
        LongBlade = "Long Blade"
        Axe = "Axe"
        Spear = "Spear"
        Athletics = "Athletics"
        Enchant = "Enchant"
        Destruction = "Destruction"
        Alteration = "Alteration"
        Illusion = "Illusion"
        Conjuration = "Conjuration"
        Mysticism = "Mysticism"
        Restoration = "Restoration"
        Alchemy = "Alchemy"
        Unarmored = "Unarmored"
        Security = "Security"
        Sneak = "Sneak"
        Acrobatics = "Acrobatics"
        LightArmor = "Light Armor"
        ShortBlade = "Short Blade"
        Marksman = "Marksman"
        Mercantile = "Mercantile"
        Speechcraft = "Speechcraft"
        HandToHand = "Hand To Hand"
    EnchantmentKind* = enum
        CastOnce = "Cast Once"
        CastOnStrike = "Cast on Strike"
        CastWhenUsed = "Cast When Used"
        ConstantEffect = "Constant Effect"
    DialogueKind* = enum
        Topic
        Voice
        Greeting
        Persuastion
        Journal
    SpecializationKind* = enum
        SpecNone = (-1, "None")
        SpecCombat = "Combat"
        SpecMagic = "Magic"
        SpecStealth = "Stealth"
    GenderKind* = enum
        All = (-1, "All Genders")
        Male = "Male Only"
        Female = "Female Only"
    ReferenceKind* = enum
        Persistent
        Temporary
    RaceFlags* = enum
        RFPlayable = (0x1, "Playable")
        RFBeastRace = (0x2, "Beast Race")
    SpellFlags* {.size: sizeof(uint32).} = enum
        AutoCalc = (0x1, "AutoCalc")
        PCStart = (0x2, "PC Start")
        AlwaysSucceed = (0x4, "Always Succeeds")
    FilterFunctionKind* {.size: sizeof(char).} = enum
        FNone = 0
        Function
        Global
        Local
        Journal
        Item
        Dead
        NotID
        NotFaction
        NotClass
        NotRace
        NotCell
        NotLocal


    # 0x00001 = Targets Skill
    # 0x00002 = Targets Attribute
    # 0x00004 = No Duration
    # 0x00008 = No Magnitude
    # 0x00010 = Harmful
    # 0x00020 = Continuous VFX
    # 0x00040 = Can Cast On Self
    # 0x00080 = Can Cast On Touch
    # 0x00100 = Can Cast On Target
    # 0x00200 = Spellmaking
    # 0x00400 = Enchanting
    # 0x00800 = Negative Lighting
    # 0x01000 = Applied Once
    # 0x02000 = Stealth
    # 0x04000 = Cannot Recast
    # 0x08000 = Illegal Daedra
    # 0x10000 = Unreflectable
    # 0x20000 = Linked To Caster

proc hasFlag*[T: enum](e: T, flags: uint32): bool = result = (uint32(e) and (
        not flags)) == 0

macro enumStmts(a: typed): untyped =
    result = nnkStmtList.newTree()
    var ifstmt = nnkIfStmt.newTree()
    for ai in a.getType[1][1..^1]:
        assert ai.kind == nnkSym
        ifstmt.add(nnkElifBranch.newTree(
            nnkInfix.newTree(
              newIdentNode("=="),
              nnkCall.newTree(
                newIdentNode("hasFlag"),
                newLit(ai.strVal),
                newIdentNode("x")
            ),
            newIdentNode("true")
        ),
            nnkStmtList.newTree(
              nnkCall.newTree(
                nnkDotExpr.newTree(
                  newIdentNode("result"),
                  newIdentNode("add")
            ),
            newLit(ai.strVal)
        ))))

proc parseFilterFunctionKind*(x:char): FilterFunctionKind =
    echo $x
    case x:
        of '1':
            return Function
        of '2': return Global
        of '3': return Local
        of '4': return Journal
        of '5': return Item
        of '6': return Dead
        of '7': return NotID
        of '8': return NotFaction
        of '9': return NotClass
        of 'A': return NotRace
        of 'B': return NotCell
        of 'C': return NotLocal
        else: return FNone

proc parseBodyFlags*(x:uint8): seq[BodyFlags] =
    result = @[]
    enumStmts(BodyFlags)

proc parseRaceFlags*(x:uint32): seq[RaceFlags] =
    result = @[]
    enumStmts(RaceFlags)

proc parseMagicEffectFlags*(x: uint32): seq[MagicEffectFlags] =
    result = @[]
    enumStmts(MagicEffectFlags)

proc parsePathGridFlags*(x:uint16): seq[PathGridFlags] =
    result = @[]
    enumStmts(PathGridFlags)

proc parseLightFlags*(x: uint32): seq[LightFlags] =
    result = @[]
    enumStmts(LightFlags)

proc parseContainerFlags*(x:uint32): seq[ContainerFlags] =
    result = @[]
    enumStmts(ContainerFlags)
# Organic = 0x1
#         Respawns = 0x2
#         Unknown = 0x8

proc parseNPCFlags*(x:uint32): seq[NPCFlags] =
    result = @[]
    enumStmts(NPCFlags)

proc parseAIFlags*(flags: uint32): seq[AIDataFlags] =
    result = @[]
    enumStmts(NPCFlags)

proc parseCreatureFlags*(x:uint32): seq[CreatureFlags] =
    result = @[]
    enumStmts(CreatureFlags)

proc parseCellDataFlags*(x:uint32): seq[CellDataFlags] =
    result = @[]
    enumStmts(CellDataFlags)

proc parseClassAutoCalcFlags*(x:uint32): seq[ClassAutoCalcFlags] =
    result = @[]
    enumStmts(ClassAutoCalcFlags)

proc parseSpellFlags*(x:uint32): seq[SpellFlags] =
    result = @[]
    enumStmts(SpellFlags)

proc toRecordFlags*(v:uint32): RecordFlags =
     case v:
          of 0x0020: result = Deleted
          of 0x0400: result = Persistent
          of 0x0800: result = InitiallyDisabled
          of 0x2000: result = Blocked
          else: result = None

