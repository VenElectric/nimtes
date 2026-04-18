import record

type
    LTEX* = ref object of TES3Record
        NAME: string
        INTV: uint32
        DATA: string

using
    r:LTEX

func id*(r): string = r.NAME
func land_indx*(r): uint16 = uint16(r.INTV) # uesp alleges these should be restricted to uint16 values
func texture_path*(r): string = r.DATA

proc `$`*(r): string = 
    result = "LTEX"
    result.add `T$`(r)