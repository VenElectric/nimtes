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
        VCLR: Option[array[65,array[65,RGB]]]
        VTEX: Option[array[16,array[16,uint16]]]
        # VTEX: Option[array[16,array[16,uint16]]] shows as array[0..8,array[0..8,uint16]]
        # and causes error in textureIndices accessor. no compile error as far as I'm aware...
        # but the lsp error is a little annoying
        # using a type alias resolves this issue

using
    r:LAND

func coordinates*(r): Coords = r.INTV
func dataTypes*(r):uint32 = r.DATA
func vertexNormals*(r):array[65,array[65,VertexNormal]] = r.VNML
func data*(r): Option[HeightData] = r.VHGT
func offset*(r:HeightData): float32 = r.offset
func heightData*(r:HeightData): array[65,array[65,int8]] = r.height_data
func worldHeights*(r): Option[array[9,array[9,uint8]]] = r.WNAM
func vertexColors*(r): Option[array[65,array[65,RGB]]] = r.VCLR
func textureIndices*(r): Option[array[16,array[16,uint16]]] = r.VTEX

proc `$`*(r): string =
    result = "LAND"
    result.add `T$`(r)
