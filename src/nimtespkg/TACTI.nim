import std/options
import record, util,conflicts
type
    ACTI* = ref object of TES3Record
        NAME: string
        MODL: Option[string]
        FNAM: Option[string]
        SCRI: Option[string]


using
    r: ACTI

func id*(r): string = stripNull(r.NAME)
func model_path*(r): string = unwrap_str(r.MODL)
func name*(r): string = unwrap_str(r.FNAM)
func script_name*(r): string = unwrap_str(r.SCRI)

proc conflict*(r1,r2:ACTI): seq[string] = 
    if model_path(r1) != model_path(r2):
        result.add create_message("Model path",model_path(r1),model_path(r2))
    if script_name(r1) != script_name(r2):
        result.add create_message("Script name",script_name(r1),script_name(r2))

# compare
# S1 and S2
# get all ACTI for S1 and S2
# loop through S1_ACTI
# get id, and then search for that ID in ACTI 2
# probably just compare that model paths are the same


proc `$`*(r): string =
    result = "ACTI"
    result.add `$T`(r)
