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
func model_path*(r:BODY): string = stripNull(r.MODL)
func race*(r:BODY): string = stripNull(r.FNAM)
func body_data*(r:BODY): BodyPartData = r.BYDT

func is_vampire*(r:BODY): bool = bool(body_data(r).vampire)
func body_part*(r:BODY): BodyPart = BodyPart(body_data(r).part)
func is_female*(r:BODY): bool = body_data(r).flags == 1
func is_playable*(r:BODY): bool = body_data(r).flags == 2

func part_kind*(r:BODY): PartKind = PartKind(body_data(r).part_kind)

proc `$`*(r:BODY): string =
    result = "BODY"
    result.add `T$`(r)
