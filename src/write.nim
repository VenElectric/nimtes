import std/[streams, macros, options, tables]
import constants

using
    s: Stream


proc writeTag*(s): string = 
    write(s, TAGSIZE)
proc writeSize*(s;size:uint32) =
    write(s,size)
proc skip*(s; pos: Natural) = setPosition(s, getPosition(s) + pos)


proc filter_tags*(s): seq[tuple[start_pos: int; end_pos: int]] =
    result = @[]
    while not s.atEnd():
        let start = getPosition(s)
        skip(s, 4)
        let len = readUint32(s)
        skip(s, len + 8)
        result.add((start_pos: start, end_pos: getPosition(s)))

proc writeField(s; src:SomeInteger)
proc writeField(s; src: SomeFloat)
proc writeField(s; src: string)
proc writeField[T](s; src: Option[T])
proc writeField[S, T](s; src: array[S, T])
proc writeField[T](s; src: seq[T])
proc writeField[T: object|tuple](s; dst: var T)

proc writeField(s;src:SomeInteger) = 
    writeSize(s,uint32(sizeof(src)))
    write(s,src)
proc writeField(s;src:SomeFloat) =
    writeSize(s,uint32(sizeof(src)))
    write(s,src)
proc writeField(s; src: string) =
    # some of these may not have a size? i.e. if it is a struct, there should (I think)
    # only be a size for the struct and not each of the individual elements
    writeSize(s,uint32(sizeof(src)))
    write(s,src)
proc writeField[T](s; src: Option[T]) =
    if isSome(src):
        writeField(s,get(src))
# proc writeField[T](s;dst: var tuple[T,T,T]) = discard
# need to take writing tags into account....
proc writeField[T](s; src: seq[T]) = discard

proc writeField[S, T](s; src: array[S, T]) =
    for i in countup(len(src)-1):
        writeField(s, src[i])

proc writeField[T: object|tuple](s; dst: var T) = discard