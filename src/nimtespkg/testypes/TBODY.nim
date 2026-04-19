import record

type
    BodyPart* = enum 
        Head = 0,
        Hair,
        Neck,
        Chest,
        Groin,
        Hand,
        Wrist,
        Forearm,
        Upperarm,
        Foot,
        Ankle,
        Knee,
        Upperleg,
        Clavicle,
        Tail
    PartKind* = enum 
        Skin = 0,
        Clothing,
        Armor

type 
    BodyPartData* = ref object of DataField
        part: uint8
        vampire: uint8
        flags: uint8
        part_kind: uint8
    BODY* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: string
        BYDT: BodyPartData

func id*(r:BODY): string = stripNull(r.NAME)
func modelPath*(r:BODY): string = stripNull(r.MODL)
func race*(r:BODY): string = stripNull(r.FNAM)
func data*(r:BODY): BodyPartData = r.BYDT

func isVampire*(r:BODY): bool = bool(data(r).vampire)
func bodyPart*(r:BODY): BodyPart = BodyPart(data(r).part)
func isFemale*(r:BODY): bool = data(r).flags == 1
func isPlayable*(r:BODY): bool = data(r).flags == 2

func partKind*(r:BODY): PartKind = PartKind(data(r).part_kind)

proc `$`*(r:BODY): string =
    result = "BODY"
    result.add `T$`(r)
