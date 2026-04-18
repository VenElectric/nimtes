import record

type
    DIAL* = ref object of TES3Record
        NAME: string
        DATA: uint8

func id*(r:DIAL): string = r.NAME
proc dialogue_kind*(r:DIAL): DialogueKind = DialogueKind(r.DATA)

proc `$`*(r:DIAL): string = 
    result = "DIAL"
    result.add `T$`(r)