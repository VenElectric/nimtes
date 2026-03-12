import std/options
import record
type 
    ACTI* = object
        NAME: string
        MODL: Option[string]
        FNAM: Option[string]
        SCRI: Option[string]

func id*(r:ACTI): string = r.NAME
func model_name*(r:ACTI): Option[string] = r.MODL
func name*(r:ACTI): Option[string] = r.FNAM
func script_name*(r:ACTI): Option[string] = r.SCRI