import record,util

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
func path_point_count*(r): uint16 = data(r).path_pt_count
func path_points*(r): seq[PathPoint] = r.PGRP
func connection_list*(r): seq[uint32] = r.PGRC



proc `$`*(r): string = 
    result = "PGRD"
    result.add `T$`(r)