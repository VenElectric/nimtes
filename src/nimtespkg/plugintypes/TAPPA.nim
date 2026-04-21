import std/[options]
import record

type
    ApparatusKind* = enum 
        AppaNone = (-1,"No Type"),
        MortarPestle = "Mortar and Pestle",
        Alembic,
        Calcinator,
        Retort
    ApparatusQuality* = enum 
        AQNone = "No Quality", # should be unreachable hopefully
        AQApprentice = "Apprentice",
        AQJourneyman = "Journeyman",
        AQMaster = "Master",
        AQGrandmaster = "Grandmaster",
        AQSecretMaster = "Secret Master" # Available through console commands
    ApparatusData* = ref object of DataField 
        kind: uint32
        quality: float32
        weight: float32
        value: uint32
    APPA* = ref object of TES3Record
        NAME {.dtag("ID").}: string
        MODL {.dtag("Model Path").}: Option[string]
        FNAM {.dtag("Name").}: Option[string]
        SCRI {.dtag("Script Name").}: Option[string]
        AADT {.dtag("Apparatus Data").}: Option[ApparatusData]
        ITEX {.dtag("Icon Path").}: Option[string]

using 
    r:APPA
    d:ApparatusData

proc `==`*(l,r:ApparatusData): bool = 
    l.kind == r.kind and l.quality == r.quality and l.weight == r.weight and l.value == r.value

func id*(r): string = r.NAME
func modelPath*(r): Option[string] = r.MODL # ContainsMesh
func name*(r): Option[string] = r.FNAM
func scriptName*(r): Option[string] = r.SCRI # UsesScript
func data*(r): Option[ApparatusData] = r.AADT

func quality*(d): ApparatusQuality =
    let q = d.quality
    if q < 1:
        return AQApprentice
    elif q == 1:
        return AQJourneyman
    elif q == 1.2:
        return AQMaster
    elif q == 1.5:
        return AQGrandmaster
    elif q == 2:
        return AQSecretMaster
    else:
        return AQNone
func weight*(d): float32 = d.weight
func value*(d): uint32 = d.value
proc apparatusAssert*(v:uint32) = assert(v < 5,"Invalid apparatus type value: " & $v)
func kind*(d): ApparatusKind = 
    apparatusAssert(d.kind)
    return ApparatusKind(d.kind)

func iconPath*(r): Option[string] = r.ITEX #Icon





proc `$`*(r:APPA): string =
    result = "APPA"
    result.add `T$`(r)

