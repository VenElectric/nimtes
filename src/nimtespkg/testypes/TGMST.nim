import std/options
from strutils import indent
import record

type
    GMST* = ref object of TES3Record
        NAME: string
        FLTV: Option[float32]
        INTV: Option[int32]
        STRV: Option[string]

using
    r:GMST

func name*(r): string = r.NAME
func str_value*(r): string =
    result = ""
    if isSome(r.STRV):
        result = get(r.STRV)
func int_value*(r): int32 =
    result = 0
    if isSome(r.INTV):
        result = get(r.INTV)
func float_value*(r): float32 =
    result = 0.0
    if isSome(r.FLTV):
        result = get(r.FLTV)

proc `$`*(r): string =
    result = "GMST\n"
    result.add indent("NAME" & ":" & name(r),INDENT) & "\n"
    result.add indent("STRV" & ":" & str_value(r),INDENT) & "\n"
    result.add indent("INTV" & ":" & $int_value(r),INDENT) & "\n"
    result.add indent("FLTV" & ":" & $float_value(r),INDENT) & "\n"