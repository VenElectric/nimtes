import std/[options]
import record

type
    ApparatusKind* = enum 
        AppaNone = (-1,"No Type"),
        MortarPestle = (0,"Mortar and Pestle"),
        Alembic,
        Calcinator,
        Retort
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

func id*(r): string = r.NAME
func modelPath*(r): Option[string] = r.MODL # ContainsMesh
func name*(r): Option[string] = r.FNAM
func scriptName*(r): Option[string] = r.SCRI # UsesScript
func data*(r): Option[ApparatusData] = r.AADT

func quality*(r): Option[float32] = 
    if isSome(data(r)):
        result = some(get(data(r)).quality)
func weight*(r): Option[float32] = 
    if isSome(data(r)):
        result = some(get(data(r)).weight)
func value*(r): Option[uint32] = 
    if isSome(data(r)):
        result = some(get(data(r)).value)

func iconPath*(r): Option[string] = r.ITEX #Icon

proc kind*(r): ApparatusKind = 
    result = AppaNone
    if isSome(data(r)):
        let k = get(data(r)).kind
        result = ApparatusKind(k)



proc `$`*(r:APPA): string =
    result = "APPA"
    result.add `T$`(r)

