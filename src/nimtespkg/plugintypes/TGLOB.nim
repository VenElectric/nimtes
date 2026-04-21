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

func fieldKind*(r): char = r.FNAM

func int16Value*(r): Option[int16] =
    if fieldKind(r) == 's':
        result = some(int16(r.FLTV))
func int32Value*(r): Option[int] =
    if fieldKind(r) == 'l':
        result = some(int(r.FLTV))
func float32Value*(r): Option[float32] =
    if fieldKind(r) == 'f':
        result = some(r.FLTV)

proc `$`*(r): string =
    result = "GLOB\n"
    result.add indent("NAME" & ":" & name(r),INDENT) & "\n"
    result.add indent("FNAM" & ":" & field_kind(r),INDENT) & "\n"
    if isSome(int16Value(r)):
        let v = get(int16Value(r))
        result.add indent("FLTV" & ":" & $v,INDENT) & "\n"
    elif isSome(int32Value(r)):
        let v = get(int32Value(r))
        result.add indent("FLTV" & ":" & $v,INDENT) & "\n"
    elif isSome(float32Value(r)):
        let v = get(float32Value(r))
        result.add indent("FLTV" & ":" & $v,INDENT) & "\n"
    else: discard