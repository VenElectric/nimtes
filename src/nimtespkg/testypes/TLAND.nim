import std/options
import record

type
    VertexNormal* = object
        x,y,z:int8
    HeightData* = ref object of DataField
        offset: float32
        height_data: array[65,array[65,int8]]
        junk: array[3,uint8]
    LAND* = ref object of TES3Record
        INTV:Coords
        DATA: uint32
        VNML: array[65,array[65,VertexNormal]]
        VHGT: Option[HeightData]
        WNAM: Option[array[9,array[9,uint8]]]
        VCLR: Option[array[65,array[65,RGBO]]]
        VTEX: Option[array[16,array[16,uint16]]]

using
    r:LAND

func coordinates*(r): Coords = r.INTV
func data_types*(r):uint32 = r.DATA
func vertex_normals*(r):array[65,array[65,VertexNormal]] = r.VNML
func data*(r): Option[HeightData] = r.VHGT
func offset*(r:HeightData): float32 = r.offset
func height_data*(r:HeightData): array[65,array[65,int8]] = r.height_data
func world_heights*(r): Option[array[9,array[9,uint8]]] = r.WNAM
func vertex_colors*(r): Option[array[65,array[65,RGBO]]] = r.VCLR
func texture_indices*(r): Option[array[16,array[16,uint16]]] = r.VTEX

proc `$`*(r): string =
    result = "LAND"
    result.add `T$`(r)
