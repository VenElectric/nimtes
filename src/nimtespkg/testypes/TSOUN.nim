import record

type
    AttenuationData* = ref object of DataField
        vol:uint8
        min_range:uint8
        max_range:uint8
    SOUN* = ref object of TES3Record
        NAME: string
        FNAM: string
        DATA: AttenuationData

using
    r:SOUN

func id*(r): string = r.NAME
func fileName*(r): string = r.FNAM
func data*(r): AttenuationData = r.DATA
func volume*(r): uint8 = data(r).vol
func volRange*(r): tuple[min: uint8, max:uint8] = 
    let d = data(r)
    result = (min: d.min_range,max:d.max_range)

proc `$`*(r): string =
    result = "SOUN"
    result.add `T$`(r)