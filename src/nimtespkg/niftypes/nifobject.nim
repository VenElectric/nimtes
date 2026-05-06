import std/options
import common
# NifHeader
# NiNode
# NiStringExtraData
# NiTriShape <--
# NiAlphaProperty
# NiTexturingProperty
# NiSourceTexture
# NiMaterialProperty
# NiTriShapeData <--
#
# translation*:Vector3[float32]
# rotation*:Matrix[3,3,float32]
# scale*:float32 = 1.0
# velocity*:Vector3[float32]
# hasBoundingVolume*:bool
# boundingVolume*:Option[BoundingVolume]
type
    NiObject = ref object of RootObj
    NiObjectNET* = ref object of NiObject
        name*: string
        extraData*: int32
        extraDataList*: seq[int32]
        controller*: int32
    NiAVObject* = ref object of NiObjectNET
        translation*: Vector3[float32]
        rotation*:Matrix[3,3,float32]
        scale*:float32 = 1.0
        velocity*:Vector3[float32]
        hasBoundingVolume*:bool
        boundingVolume*:Option[BoundingVolume]
    NiHeader* = object
        headerStr*: string
        fileVersion*: int32
        numBlocks*: uint32
    NiNode* = ref object of NiAVObject
        numChildren*: uint32
        children*: seq[int32]
    NiTriShape* = ref object of NiAVObject
    NiAlphaProperty* = ref object of NiObjectNET
        flags: set[AlphaFlags]
        threshold: uint8
    NiTexturingProperty* = ref object of NiObjectNET
        flags: uint16
        applyMode: ApplyMode
        textureCount: uint32
        hasBaseTexture: bool
    NiSourceTexture* = object
    NiMaterialProperty* = object
    NiGeometryData* = ref object of NiObject
        numVertices: uint16
        hasVertices: bool
        vertices: seq[Vector3[float32]]
        hasNormals: bool
        normals: seq[Vector3[float32]]
        boundingSphere: NiBound
        hasVertexColors: bool
        vertexColors: seq[RGBA[float32]]
        dataFlags: uint16
        hasUv: bool
        uvSets: seq[TexCoord]
    NiTriBasedGeomData* = ref object of NiGeometryData
        numTriangles*: uint16
    NiTriShapeData* = object
        numTrianglePoints*: uint16
        triangles: seq[Triangle]
        numMatchGroups: uint16
        matchGroups: seq[MatchGroup]

# Ref = int32
# Stringoffset = uint32
# NiFixedString = uint32
# PTr = int32
# Vector3 = float32
# Quaternion = float32
# Matrix = float32
# ulittle32 = uint32
# uint = uint32
# int = int32
# ushort = uint16
# short = int16
# sbyte = int8
# byte = uint8
# normbyte = float32
# blocktypeindex = int16
# fileversion = int32
# float = float32
#
