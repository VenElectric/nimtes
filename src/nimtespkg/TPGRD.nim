import record,util,reader

# 0x80 = 128 granularity
# 0x100 = 256 granularity
# 0x200 = 512 granularity
# 0x400 = 1024 granularity (Appears to be the default)
# 0x800 = 2048 granularity
# 0x1000 = 4096 granularity


type
    PathgridData* = object
        x*:int32
        y*:int32
        flags*: uint16
        path_pt_count*:uint16
    PathPoint* = object
        x*:int32
        y*:int32
        z*:int32
        flags*:uint8
        conn_count*:uint8
    PGRD* = ref object of TES3Record
        DATA*: PathgridData
        NAME*: string
        PGRP*: seq[PathPoint]
        PGRC*: seq[uint32]
    
using 
    r:PGRD
    s:Stream

func name*(r): string = stripNull(r.NAME)
func data*(r): PathgridData = r.DATA
func granularity*(r):uint16 = data(r).flags
func path_point_count*(r): uint16 = data(r).path_pt_count
func path_points*(r): seq[PathPoint] = r.PGRP
func connection_list*(r): seq[uint32] = r.PGRC

# PGRD only record that needs this amt of customization 
proc readPGRD*(s): PGRD = 
    result = new PGRD
    let pos = getPosition(s)

    var tags = get_sub_level_offsets(s)

    next(tags) 
    next(tags)

    setPosition(s, pos)
    consumeTag(s)
    result.size = readUint32(s)
    checkSize(result.size, tags)
    skip(s, 4)
    result.flags = readUint32(s)

    assert(peek(tags).name == "DATA","DATA field not found for PGRD")
    setPosition(s,peek(tags).pos)
    read(s,result.DATA)
    next(tags)
    assert(peek(tags).name == "NAME","Missing Name field for PGRD")
    setPosition(s,peek(tags).pos)
    readField(s,result.NAME,tags)
    let pathCount = result.DATA.path_pt_count
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
            result.PGRP.add temp
        next(tags)
    if peek(tags).name == "PGRC":
        setPosition(s,peek(tags).pos)
        for _ in countup(1,pathTotal):
            result.PGRC.add readUint32(s)

proc readAllPGRD*(s): seq[PGRD] = 
    setPosition(s,0)
    while not atEnd(s):
        let tag = peekTag(s)
        if tag == "PGRD":
            let sPos = getPosition(s)
            let rec = readPGRD(s)
            result.add rec
            setPosition(s,sPos+8)
            skip(s,rec.size+8)
        else:
            consumeTag(s)
            let size = readSize(s)
            skip(s,size+8)

proc `$`*(r): string = 
    result = "PGRD"
    result.add `T$`(r)