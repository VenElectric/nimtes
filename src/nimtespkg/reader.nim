import std/[streams, macros, options, strformat,tables,parsecfg]
from lexbase import NewLines
import util
import testypes
using
    s: Stream

type
    TagPos* = object
        pos*: int
        name*: string
        size*: uint32
    TagFields* = object
        current*: TagPos
        prev*: TagPos
        cursor*: int = 0
        tags*: seq[TagPos]
        atEnd*: bool = false
    FilterFunc = proc(tp:TagPos): bool

const TAGSIZE = 4
const PREAMBLE = 16



proc readTag*(s): string = readStr(s, TAGSIZE)
proc peekTag*(s): string = peekStr(s, TAGSIZE)
proc skip*(s; pos: Natural) = setPosition(s, getPosition(s) + pos)
proc skipPreamble*(s) = setPosition(s, getPosition(s)+PREAMBLE)

proc goback*(s; pos: Natural) = setPosition(s, getPosition(s) - pos)

proc readSize*(s): uint32 = readUint32(s)
proc consumeSize*(s) = discard readSize(s)

proc consumeTag*(s) = discard readTag(s)

func peek*(t: TagFields): TagPos = t.current

proc createTag(s): TagPos =
    result.name = readTag(s)
    result.size = readSize(s)
    result.pos = getPosition(s)

proc add(t: var TagFields; v: TagPos) = t.tags.add v

proc atEnd*(t: TagFields): bool = t.atEnd

iterator items*(t:TagFields): TagPos =
    for tag in t.tags:
        yield tag

proc filter*(tf:TagFields,p:FilterFunc): TagFields =
    result = TagFields()
    for t in items(tf):
        if p(t):
            result.add t

proc next*(t: var TagFields) =
    if t.cursor > len(t.tags)-1:
        t.atEnd = true;
        return
    inc(t.cursor)

    t.prev = t.current
    t.current = t.tags[t.cursor-1]

proc getSubLevelOffsets*(s): TagFields =
    result = TagFields()
    result.tags = @[]
    var p = TagPos(name: readTag(s), size: readSize(s))
    skip(s, 8) # flags and unused
    p.pos = getPosition(s)
    result.add p
    let eot = getPosition(s) + int(p.size)
    while getPosition(s) < eot:

        let tag = createTag(s)
        result.add tag
        skip(s, tag.size)

proc getRecordCounts*(s): CountTable[string] = 
    while not atEnd(s):
        let tag = readTag(s)
        let size = readSize(s)
        result.inc tag
        skip(s,size + 8)

proc getRecordOffsets*(s): TagFields = 
    result = TagFields()
    setPosition(s,0)
    while not atEnd(s):
        let tag = createTag(s)
        result.add tag
        skip(s,tag.size+8)

proc getRecordOffsetsOfType*(s;tag:string): TagFields =
    result = TagFields()
    setPosition(s,0)
    while not atEnd(s):
        if peekTag(s) == tag:
            let tag = createTag(s)
            result.add tag
            skip(s,tag.size+8)
        else:
            consumeTag(s)
            let size = readSize(s)
            skip(s,size+8)



proc checkSize*(actual: uint32; tags: TagFields) =
    var calc: uint32 = 0
    for i in 1..len(tags.tags)-1:
        let tag = tags.tags[i]
        calc = calc + tag.size + 8
    assert(actual == calc, fmt"Actual: {actual}, calc {calc}")

proc readField(s; dst: var char; tags: var TagFields)
proc readField(s; dst: var int8; tags: var TagFields)
proc readField(s; dst: var int16; tags: var TagFields)
proc readField(s; dst: var int32; tags: var TagFields)
proc readField(s; dst: var int64; tags: var TagFields)
proc readField(s; dst: var uint8; tags: var TagFields)
proc readField(s; dst: var uint16; tags: var TagFields)
proc readField(s; dst: var uint32; tags: var TagFields)
proc readField(s; dst: var uint64; tags: var TagFields)
proc readField(s; dst: var float32; tags: var TagFields)
proc readField(s; dst: var float64; tags: var TagFields)
proc readField(s; dst: var string; tags: var TagFields)
proc readField[T](s; dst: var Option[T]; tags: var TagFields)
proc readField[S, T](s; dst: var array[S, T];
        tags: var TagFields)
proc readField[T](s; dst: var seq[T]; tags: var TagFields)
proc readField[T: object](s; dst: var T; tags: var TagFields)
proc readField[T: DataField](s; dst: var T; tags: var TagFields)
proc readField[T](s; dst: var TagList[T]; tags: var TagFields)
proc readField(s; dst: var seq[AI_Package]; tags: var TagFields)
proc readField(s; dst: var ActivatePkg; tags: var TagFields)
proc readfield(s; dst: var FollowerData; tags: var TagFields)
proc readField(s;dst: var NPCData;tags: var Tagfields)
proc readField(s;dst: var ScriptData;tags: var TagFields)
proc readField*(s;dst: var WeatherChances;tags: var TagFields)
proc readField(s;dst: var RGB,tags: var TagFields)
proc readField(s;dst: var RGBA,tags: var TagFields)

proc readField(s; dst: var char; tags: var TagFields) =
    dst = s.readChar()
    next(tags)
proc readField(s; dst: var int8; tags: var TagFields) =
    dst = s.readInt8()
    next(tags)
proc readField(s; dst: var int16; tags: var TagFields) =
    dst = s.readInt16()
    next(tags)
proc readField(s; dst: var int32; tags: var TagFields) =
    dst = s.readInt32()
    next(tags)
proc readField(s; dst: var int64; tags: var TagFields) =
    dst = s.readInt64()
    next(tags)
proc readField(s; dst: var uint8; tags: var TagFields) =
    dst = s.readUint8()
    next(tags)
proc readField(s; dst: var uint16; tags: var TagFields) =
    dst = s.readUint16()
    next(tags)
proc readField(s; dst: var uint32; tags: var TagFields) =
    dst = s.readUint32()
    next(tags)
proc readField(s; dst: var uint64; tags: var TagFields) =
    dst = s.readUint64()
    next(tags)
proc readField(s; dst: var float32; tags: var TagFields) =
    dst = s.readFloat32()
    next(tags)
proc readField(s; dst: var float64; tags: var TagFields) =
    dst = s.readFloat64()
    next(tags)
proc readField(s; dst: var string; tags: var TagFields) =
    dst = readStr(s, int(peek(tags).size))
    next(tags)
proc readField[T](s; dst: var Option[T]; tags: var TagFields) =
    var temp: T
    when T is ref:
        temp = new(T)
    else:
        temp = default(T)

    readField(s, temp, tags)
    dst = some(temp)

proc readField[S, T](s; dst: var array[S, T];
        tags: var TagFields) =
    read(s, dst)
    next(tags)


proc getFieldNames[T: object](o: T): seq[string] =
    result = @[]
    for key, value in fieldPairs(o):
        result.add key

# workaround...for some reason readField[T:DataField] makes compiler
# yell that var T is invalid for one of these types

proc readField(s; dst: var ActivatePkg; tags: var TagFields) =
    dst.name = readStr(s, getCustomPragmaVal(dst.name, zsize))
    read(s, dst.unknown)

proc readfield(s; dst: var FollowerData; tags: var TagFields) =
    read(s, dst.x)
    read(s, dst.y)
    read(s, dst.z)
    read(s, dst.duration)
    dst.id = readStr(s, getCustomPragmaVal(dst.id, zsize))
    read(s, dst.unknown)
    read(s, dst.unused)


proc readField(s; dst: var seq[AI_Package]; tags: var TagFields) =
    if atEnd(tags):
        return
    case peek(tags).name
    of "AI_A":
        var temp = ActivatePkg()
        readField(s, temp, tags)
        next(tags)
        dst.add AI_Package(kind: Activate, AI_A: temp)
    of "AI_E":
        var temp = EscortPkg()
        readField(s, temp.AI_E, tags)
        next(tags)
        if peek(tags).name == "CNDT":
            readField(s, temp.CNDT, tags)
            next(tags)
        dst.add AI_Package(kind: Escort, AI_E: temp)
    of "AI_F":
        var temp = FollowPkg()
        readField(s, temp.AI_F, tags)
        next(tags)
        if peek(tags).name == "CNDT":
            readField(s, temp.CNDT, tags)
            next(tags)
        dst.add AI_Package(kind: Follow, AI_F: temp)
    of "AI_T":
        var temp = TravelPkg()
        read(s, temp)
        next(tags)
        dst.add AI_Package(kind: Travel, AI_T: temp)
    of "AI_W":
        var temp = WanderPkg()
        read(s, temp)
        next(tags)
        dst.add AI_Package(kind: Wander, AI_W: temp)
    else: return

proc readField(s;dst: var RGB,tags: var TagFields) = 
    setPosition(s,peek(tags).pos)
    read(s,dst)
    next(tags)

proc readField(s;dst: var RGBA,tags: var TagFields) = 
    setPosition(s,peek(tags).pos)
    read(s,dst)
    next(tags)

proc readField[T: DataField](s; dst: var T; tags: var TagFields) =
    setPosition(s, peek(tags).pos)
    dst = new(T)
    for key, value in fieldPairs(dst[]):
        when value is string:
            assert(hasCustomPragma(value, zsize),
                    fmt"Value does not have zsize pragma {tags.current.name}")
            value = readStr(s, getCustomPragmaVal(value, zsize))
        elif value is DataField:
            readField(s, value, tags)
        else:
            read(s, value)
    next(tags)

proc readField(s;dst: var NPCData;tags: var Tagfields) =
    let size = peek(tags).size
    if size == 12:
        read(s,dst.level)
        read(s,dst.disposition)
        read(s,dst.reputation)
        read(s,dst.rank)
        skip(s,3) #junk
        read(s,dst.gold)
    else:
        var temp = NPCStats()
        read(s,dst.level)
        read(s,temp.attributes)
        read(s,temp.skills)
        skip(s,1) #junk
        read(s,temp.health)
        read(s,temp.spell_pts)
        read(s,temp.fatigue)
        read(s,dst.disposition)
        read(s,dst.reputation)
        read(s,dst.rank)
        skip(s,1) #junk
        read(s,dst.gold)
        dst.stats = some(temp)
    next(tags)


macro readObjectImpl[T: object](s; dst: var T; tags: var TagFields) =
    result = newStmtList()
    let body = getTypeImpl(getTypeInst(dst))[2]
    var csStmt = nnkCaseStmt.newTree()
    csStmt.add quote do:
        peek(`tags`).name
    for it in body:
        let fieldSym = it[0]
        let fieldStr = strVal(fieldSym)

        var ofBranch = nnkOfBranch.newTree()
        if fieldStr == "Pkgs":
            ofBranch.add(newLit("AI_A"), newLit("AI_E"), newLit("AI_F"), newLit(
                    "AI_T"), newLit("AI_W"))
        else:
            ofBranch.add(newLit(fieldStr))
        ofBranch.add quote do:
            readField(`s`, `dst`.`fieldSym`, `tags`)

        csStmt.add(ofBranch)
    csStmt.add(nnkElse.newTree(nnkBreakStmt.newTree(newEmptyNode())))
    result.add(csStmt)


proc readField[T](s; dst: var TagList[T]; tags: var TagFields) =
    if atEnd(tags):
        return
    var temp: T
    when T is ref:
        temp = new(T)
    else:
        temp = default(T)
    let fieldNames = getFieldNames(temp)
    for key in fieldNames:
        if key == peek(tags).name:
            setPosition(s, peek(tags).pos)
            readObjectImpl(s, temp, tags)
    seq[T](dst).add temp

proc readField(s;dst: var ScriptData;tags: var TagFields) =
    if atEnd(tags):
        return
    var temp:uint8
    for _ in countup(1,int(peek(tags).size)):
        read(s,temp)
        seq[uint8](dst).add temp

    next(tags)

proc readField[T](s; dst: var seq[T]; tags: var TagFields) =
    var temp: T
    when T is ref:
        temp = new(T)
    else:
        temp = default(T)

    readField(s, temp, tags)
    dst.add temp

proc readField*(s;dst: var WeatherChances;tags: var TagFields) =
    let size = peek(tags).size
    read(s,dst.clear)
    read(s,dst.cloudy)
    read(s,dst.foggy)
    read(s,dst.overcast)
    read(s,dst.rain)
    read(s,dst.thunder)
    read(s,dst.ash)
    read(s,dst.blight)
    if size == 10:
        read(s,dst.snow)
        read(s,dst.blizzard)
    next(tags)

proc readField[T: object](s; dst: var T; tags: var Tagfields) =
    while not atEnd(tags):
        setPosition(s, peek(tags).pos)
        readObjectImpl(s, dst, tags)

proc readPGRD(s;dst: var PGRD;tags: var TagFields) = 

    assert(peek(tags).name == "DATA","DATA field not found for PGRD")
    setPosition(s,peek(tags).pos)
    read(s,dst.DATA)
    next(tags)
    assert(peek(tags).name == "NAME","Missing Name field for PGRD")
    setPosition(s,peek(tags).pos)
    readField(s,dst.NAME,tags)
    let pathCount = dst.DATA.path_pt_count
    var pathTotal = 0
    if peek(tags).name == "PGRP":
        setPosition(s,peek(tags).pos)
        for _ in countup(1,int(pathCount)):
            var temp = PathPoint()
            read(s,temp.x)
            read(s,temp.y)
            read(s,temp.z)
            read(s,temp.flags)
            read(s,temp.conn_count)
            inc(pathTotal,temp.conn_count)
            skip(s,2) # junk data
            dst.PGRP.add temp
        next(tags)
    if peek(tags).name == "PGRC":
        setPosition(s,peek(tags).pos)
        for _ in countup(1,pathTotal):
            dst.PGRC.add readUint32(s)   

proc readRecord*[T: TES3Record](s; dst: typedesc[T]): T =
    result = new(T)
    let pos = getPosition(s)

    var tags = getSubLevelOffsets(s)

    next(tags) 
    next(tags)

    setPosition(s, pos)
    consumeTag(s)
    result.size = readUint32(s)
    checkSize(result.size, tags)
    skip(s, 4)
    result.flags = readUint32(s)
    
    when T is PGRD:
        readPGRD(s,result,tags)
    else:
        readField(s, result[], tags)

proc readAllRecordofType*[T:TES3Record](s;dst:typedesc[T]): seq[T] =
    setPosition(s,0)
    var key = $dst
    if key == "NPC":
        key = "NPC_"
    while not atEnd(s):
        let tag = peekTag(s)
        if tag == key:
            let sPos = getPosition(s)
            let rec = readRecord(s,dst)
            result.add rec
            setPosition(s,sPos+8)
            skip(s,rec.size+8)
        else:
            consumeTag(s)
            let size = readSize(s)
            skip(s,size+8)

proc readMorrowindIni*(iniPath:string): Config = 
    result = newConfig()
    var cfg = CfgParser()
    open(cfg,newFileStream(iniPath),"Morrowind.ini")
    var evt = next(cfg)
    var currSection:string
    while evt.kind != cfgEof:
        case evt.kind:
        of cfgSectionStart:
            currSection = evt.section
            result[currSection] = newOrderedTable[string,string]()
        of cfgKeyValuePair: 
            var tab = result[currSection]
            tab[evt.key] = evt.value
            result[currSection] = tab
        of cfgOption:
            var tab = result[currSection]
            tab["--" & evt.key] = evt.value
            result[currSection] = tab
        of cfgError:
            let col = getColumn(cfg) + 3
            dec(cfg.bufpos,col)
            while cfg.buf[cfg.bufpos] notin Newlines:
                dec(cfg.bufpos)
            inc(cfg.bufpos)
            var key:string
            while cfg.buf[cfg.bufpos] != '=':
                key.add cfg.buf[cfg.bufpos]
                inc(cfg.bufpos)
            var tab = result[currSection]
            tab[key] = ""
            result[currSection] = tab
            inc(cfg.bufpos)
        else:
            discard # cfgeof unreachable
        evt = next(cfg)