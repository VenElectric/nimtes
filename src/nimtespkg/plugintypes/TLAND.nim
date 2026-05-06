import std/options
import record

type
    LandDataKind* = enum
        LDVertexNormals,
        LDVertexHeights,
        LDWorldHeights,
        LDVertexColors,
        LDVertexTextures
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

using
    r:LAND

func coordinates*(r): Coords = r.INTV
func dataKind*(r): uint32 = r.DATA

# for some records, it seems like this is inaccurate. 
# I am getting none(VTEX) when LDVertexTextures is included in flags
func dataIncluded*(r):set[LandDataKind] =
    if hasFlag(r.DATA,0x01):
        result.incl LDVertexNormals
        result.incl LDVertexHeights
        result.incl LDWorldHeights
    if hasFlag(r.DATA,0x02):
        result.incl LDVertexColors
    if hasFlag(r.DATA,0x04):
        result.incl LDVertexTextures
func vertexNormals*(r):array[65,array[65,VertexNormal]] = r.VNML
func data*(r): Option[HeightData] = r.VHGT
func offset*(r:HeightData): float32 = r.offset
func heightData*(r:HeightData): array[65,array[65,int8]] = r.height_data
func worldHeights*(r): Option[array[9,array[9,uint8]]] = r.WNAM
func vertexColors*(r): Option[array[65,array[65,RGB]]] = r.VCLR
func textureIndices*(r): Option[array[16,array[16,uint16]]] = r.VTEX


# VTEX is a 16 x 16 array
# with a total of 256 slots
# if i'm not mistaken, land textures are 256x256
# there are 4,225 vertices (VNML = 65 x 65 vertex normal array)
# and the height data is a 65x65 pixel array of int8 values
# my assumptions here are that the textures are laid out in a 16x16 array
# because there is only one INTV (texture index) value per LTEX record. 
# so there are 256 textures that can be placed? 
# and each land texture has 256x256 pixels
# So the vertices seem to be points within the textures, and not the entire texture?
# It could be that vertex normals and vertex colors apply to each texture individually, 
# but then you would have similar data per each section of this region.

proc `$`*(r): string =
    result = "LAND"
    result.add `T$`(r)
