import record

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

func name*(r): string = stripNull(r.NAME)
func data*(r): PathgridData = r.DATA
func granularity*(r):uint16 = data(r).flags
func pathPointCount*(r): uint16 = data(r).path_pt_count
func pathPoints*(r): seq[PathPoint] = r.PGRP
func connectionList*(r): seq[uint32] = r.PGRC
func coords*(r:PathPoint): (int32,int32,int32) = (r.x,r.y,r.z)
func connectionCount*(r:PathPoint): uint8 = r.conn_count

proc `$`*(r): string = 
    result = "PGRD"
    result.add `T$`(r)