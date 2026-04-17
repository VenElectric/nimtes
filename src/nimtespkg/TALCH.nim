import std/options
import record,util,reader,conflicts

type 
    AlchemyData* = ref object of DataField
        weight:float32
        value: uint32
        flags: uint32
    ALCH* = ref object of TES3Record
        NAME: string
        MODL: Option[string]
        TEXT: Option[string]
        SCRI: Option[string]
        FNAM: Option[string]
        ALDT: Option[AlchemyData]
        ENAM: seq[EnchantmentData] 

using 
    r: ALCH
    s:Stream

proc auto_calc*(r): bool = 
    result = false
    if isSome(r.ALDT):
        result = has_flag(get(r.ALDT).flags,AUTO_CALC)

func weight*(r): Option[float32] = 
    if isSome(r.ALDT):
        result = some(get(r.ALDT).weight)

func value*(r): Option[uint32] = 
    if isSome(r.ALDT):
        result = some(get(r.ALDT).value)

func id*(r): string = stripNull(r.NAME)
func model_path*(r): Option[string] = r.MODL
func icon_path*(r): Option[string] = r.TEXT
func script_name*(r): string = unwrap_str(r.SCRI)
func name*(r): string = unwrap_str(r.FNAM)
func enchants*(r): seq[EnchantmentData] = r.ENAM

proc readAlchemy*(s): ALCH = readRecord(s,ALCH)

proc readAllAlchemy*(s): seq[ALCH] = readAllRecordofType(s,ALCH,"ALCH")

proc `$`*(r): string =
    result = "ALCH"
    result.add `T$`(r)

export effect,attr_affected,skill_affected,effect_range,aoe,duration,magnitude