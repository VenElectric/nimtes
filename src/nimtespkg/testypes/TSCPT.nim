import std/options
import record

type
    ScriptHeader* = ref object of DataField
        name{.zsize(32).}: string
        num_shorts:uint32
        num_longs:uint32
        num_floats:uint32
        data_size: uint32
        local_var_size: uint32
    SCPT* = ref object of TES3Record
        SCHD: ScriptHeader
        SCVR: Option[string]
        SCDT: ScriptData
        SCTX: Option[string]

using
    r:SCPT

func name*(r): string = stripNull(r.SCHD.name)

proc `$`*(r): string =
    result = "SCPT"
    result.add `T$`(r)