# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import std/[options, macros, streams]

const TAGSIZE = 4

using
    s: Stream

proc readTag*(s): string = readStr(s, TAGSIZE)
proc peekTag*(s): string = peekStr(s, TAGSIZE)
proc skip*(s; pos: Natural) = setPosition(s, getPosition(s) + pos)
# proc consumeTag(s) = discard readTag(s)

proc readSize*(s): uint32 = readUint32(s)
proc readField(s; dst: var int8) =

    dst = readInt8(s)
proc readField(s; dst: var int16) =
    dst = readInt16(s)
proc readField(s; dst: var int32) =
    dst = readInt32(s)
proc readField(s; dst: var int64) =
    dst = readInt64(s)
proc readField(s; dst: var uint8) =
    dst = readUint8(s)
proc readField(s; dst: var uint16) =
    dst = readUint16(s)
proc readField(s; dst: var uint32) =
    dst = readUint32(s)
proc readField(s; dst: var uint64) =
    dst = readUint64(s)
proc readField(s; dst: var float32) =
    dst = readFloat32(s)
proc readField(s; dst: var float64) =
    dst = readFloat64(s)
proc readField(s; dst: var char) = 
    echo "CharSize: ",readSize(s)
    dst = readChar(s)
proc readField(s; dst: var string) =
    let size = readSize(s)
    dst = readStr(s,int(size))
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
    GlobalRecord = object
        size*: uint32
        flags*: uint32
        name*: string
        field_kind*: char
        fltv*: float32
    ProbeData = object
        weight*: float32
        value*: uint32
        quality*: float32
        uses*: uint32
    ProbeRecord = object
        size*: uint32
        flags*: uint32
        name*: string
        model*: string
        fnam*: string
        data*: ProbeData
        itex*: Option[string]
        scri*: Option[string]

const ACTITAGS = ["NAME", "MODL", "FNAM", "SCRI"]
const GLOBTAGS = ["NAME","FNAM","FLTV"]

proc readActivator*(s): ActivatorRecord =
    result = ActivatorRecord()
    readField(s,result.size)
    skip(s, 4)
    readField(s,result.flags)

    while peekTag(s) in ACTITAGS:
        let tag = readTag(s)
        case tag:
            of "NAME":
                readField(s,result.id)
            of "MODL":
                readField(s,result.model_name)
            of "FNAM":
                readField(s,result.full_name)
            of "SCRI":
                readField(s,result.script_name)
            else: break

proc readGlobal*(s): GlobalRecord =
    result = GlobalRecord()
    readField(s,result.size)
    skip(s, 4)
    readField(s,result.flags)

    while peekTag(s) in GLOBTAGS:
        let tag = readTag(s)
        #echo "Tag global: ",tag
        case tag:
            of "NAME":
                readField(s,result.name)
            of "FNAM":
                readField(s,result.field_kind)
            of "FLTV":
                readField(s,result.fltv)
            else: break

proc readProbe*(s): ProbeRecord =
    result = ProbeRecord()
    readField(s,result.size)
    skip(s, 4)
    readField(s,result.flags)
    while peekTag(s) in ["NAME","MODL","FNAM","PBDT","ITEX","SCRI"]:
        let tag = readTag(s)
        #echo "Tag global: ",tag
        case tag:
            of "NAME":
                readField(s,result.name)
            of "MODL":
                readField(s,result.model)
            of "FNAM":
                readField(s,result.fnam)
            of "PBDT":
                var data = ProbeData()
                let size = readSize(s)
                echo "PBDT SIZE: ",size
                readField(s,data.weight)
                readField(s,data.value)
                readField(s,data.quality)
                readField(s,data.uses)
                result.data = data
            of "ITEX":
                readField(s,result.itex)
            of "SCRI":
                readField(s,result.scri)
            else: break


# top level attributes *wilL* need size read (all data types)
# struct level attributes do not have a size data point before the data
# i.e. PBDT has a size field, but it's constituent struct values do not
# if there is a string in a struct, the uesp page for the parent record
# typically has a "size" i.e. char[32]
# for most structs, we can easily just do readData()
# but for those with strings of x length, I'm not sure that it would work.
# we could use array[32,char], but then we would need to convert between that and string...EH
# we can tag these string variables with their size. i.e. a template pragma
# and also make sure to tag the structs i.e. ttag(struct) template pragma again
# so that structs do not go through the same process as the parent record )
# to differentiate between what needs to read size and what does not
# and potentially something to signal that there is a "string" attribute
# we also need to know when to skip certain data points
# so some objects might need a "skip" value with a size param

when isMainModule:
    let s = newFileStream("Morrowind.esm")
    echo "At end? ",atEnd(s)
    var count = 0
    while not atEnd(s):
        if count > 10:
            echo "break"
            break
        let tag = readTag(s)
        #echo tag
        # if tag == "ACTI":
        #     let rec = readActivator(s)
        #     echo rec.id
        #     echo rec.model_name
        #     echo rec.full_name
        #     echo rec.script_name
        #     inc(count)
        if tag == "PROB":
            let rec = readProbe(s)
            echo rec.name
            echo rec.model
            echo rec.fnam
            echo rec.data.weight
            echo rec.data.value
            echo rec.data.quality
            echo rec.data.uses
            inc(count)
        else:
            let size = readSize(s)
            skip(s,size+8)




