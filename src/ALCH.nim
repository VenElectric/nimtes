import std/options
from constants import AUTO_CALC

type 
    AlchemyData = object
        weight:float32
        value: uint32
        flags: uint32
    ALCH = object
        NAME: string
        MODL: Option[string]
        TEXT: Option[string]
        SCRI: Option[string]
        FNAM: Option[string]
        ALDT: AlchemyData
        ENAM: seq[int]

func auto_calc*(a:ALCH): bool = a.ALDT.flags == AUTO_CALC

func weight*(a:ALCH): float32 = a.ALDT.weight
func value*(a:ALCH): uint32 = a.ALDT.value

func id*(a:ALCH): string = a.NAME
func model_name*(a:ALCH): Option[string] = a.MODL
func inv_icon_name*(a:ALCH): Option[string] = a.TEXT
func script_name*(a:ALCH): Option[string] = a.SCRI
func name*(a:ALCH): Option[string] = a.FNAM
func enchants*(a:ALCH): seq[int] = a.ENAM