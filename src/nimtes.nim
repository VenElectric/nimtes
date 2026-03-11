# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import std/[options, macros, streams]

const TAGSIZE = 4

using
    s: Stream

proc readTag*(s): string = readStr(s, TAGSIZE)
proc peekTag*(s): string = peekStr(s, TAGSIZE)
proc skip*(s; pos: Natural) = setPosition(s, getPosition(s) + pos)
proc eattag(s) = discard readTag(s)

proc readSize*(s): uint32 = readUint32(s)
proc readField(s; dst: var int8) =
    dst = s.readInt8()
proc readField(s; dst: var int16) =
    dst = s.readInt16()
proc readField(s; dst: var int32) =
    dst = s.readInt32()
proc readField(s; dst: var int64) =
    dst = s.readInt64()
proc readField(s; dst: var uint8) =
    dst = s.readUint8()
proc readField(s; dst: var uint16) =
    dst = s.readUint16()
proc readField(s; dst: var uint32) =
    dst = s.readUint32()
proc readField(s; dst: var uint64) =
    dst = s.readUint64()
proc readField(s; dst: var float32) =
    dst = s.readFloat32()
proc readField(s; dst: var float64) =
    dst = s.readFloat64()
proc readField(s; dst: var string) =
    let size = readSize(s)
    dst = s.readStr(int(size))
proc readField[T](s; dst: var Option[T]) =
    when T is ref:
        dst = some(new(T))
    else:
        dst = some(default(T))
    readField(s, dst.get)
# proc readField[T](s;dst: var tuple[T,T,T]) = discard
proc readField[T](s; dst: var seq[T]) = discard

proc readField[S, T](s; dst: var array[S, T]) =
    for i in countup(len(dst)-1):
        readField(s, dst[i])

type
    ActivatorRecord = object
        size*: uint32
        flags*: uint32
        id*: string
        model_name*: Option[string]
        full_name*: Option[string]
        script_name*: Option[string]

const ACTITAGS = (NAME, MODL, FNAM, SCRI)

proc readActivator*(s): ActivatorRecord =
    result = ActivatorRecord(kind: ACTI)
    consumeTag(s)
    result.size = readSize(s)
    skip(s, 4)
    result.flags = readUint32()

    while peekTag(s) in ACTITAGS:

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else: break

when isMainModule:
    discard



