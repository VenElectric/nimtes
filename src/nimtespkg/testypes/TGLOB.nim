import std/options
from strutils import indent
import record

type
    GLOB* = ref object of TES3Record
        NAME: string
        FNAM: char
        FLTV: float32

using
    r:GLOB

func name*(r): string = stripNull(r.NAME)

func field_kind*(r): char = r.FNAM

func int16_value*(r): Option[int16] =
    if field_kind(r) == 's':
        result = some(int16(r.FLTV))
func int32_value*(r): Option[int] =
    if field_kind(r) == 'l':
        result = some(int(r.FLTV))
func float32_value*(r): Option[float32] =
    if field_kind(r) == 'f':
        result = some(r.FLTV)

proc `$`*(r): string =
    result = "GLOB\n"
    result.add indent("NAME" & ":" & name(r),INDENT) & "\n"
    result.add indent("FNAM" & ":" & field_kind(r),INDENT) & "\n"
    if isSome(int16_value(r)):
        let v = get(int16_value(r))
        result.add indent("FLTV" & ":" & $v,INDENT) & "\n"
    elif isSome(int32_value(r)):
        let v = get(int32_value(r))
        result.add indent("FLTV" & ":" & $v,INDENT) & "\n"
    elif isSome(float32_value(r)):
        let v = get(float32_value(r))
        result.add indent("FLTV" & ":" & $v,INDENT) & "\n"
    else: discard