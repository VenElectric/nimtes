import ../dimension
# NifHeader
# NiNode
# NiStringExtraData
# NiTriShape <-- 
# NiAlphaProperty
# NiTexturingProperty
# NiSourceTexture
# NiMaterialProperty
# NiTriShapeData <-- 

# what is the difference


# NiGeometryDataFlags
type
  NiGeometryDataFlags* = enum
    NumUVSets,
    HavokMaterial,
    NBTMethod
  AlphaFlags* = enum
    BlendAlpha,
    BlendSource,
    BlendDestination,
    AlphaTest,
    FuncTest,
    NoSorter,
    CloneUnique,
    AlphaThreshold
  TexturingMapFlags* = enum 
    TextureIndex,
    FilterMode,
    CampMode
  ApplyMode* = enum
    APPLY_REPLACE,
    APPLY_DECAL,
    APPLY_MODULATE,
    APPLY_HILIGHT,
    APPLY_HILIGHT2,
  TexType* = enum
    BASE_MAP,
    DARK_MAP,
    DETAIL_MAP,
    GLOSS_MAP,
    GLOW_MAP,
    BUMP_MAP,
    NORMAL_MAP,
    PARALLAX_MAP,
    DECAL_0_MAP,
    DECAL_1_MAP,
    DECAL_2_MAP,
    DECAL_3_MAP,
  KeyType* = enum
    LINEAR_KEY,
    QUADRATIC_KEY,
    TBC_KEY,
    XYZ_ROTATION_KEY,
    CONST_KEY,
  BipedPart* = enum
    P_OTHER,
    P_HEAD,
    P_BODY,
    P_SPINE1,
    P_SPINE2,
    P_L_UPPER_ARM,
    P_L_FOREARM,
    P_L_HAND,
    P_L_THIGH,
    P_L_CALF,
    P_L_FOOT,
    P_R_UPPER_ARM,
    P_R_FOREARM,
    P_R_HAND,
    P_R_THIGH,
    P_R_CALF,
    P_R_FOOT,
    P_TAIL,
    P_SHIELD,
    P_QUIVER,
    P_WEAPON,
    P_PONYTAIL,
    P_WING,
    P_PACK,
    P_CHAIN,
    P_ADDON_HEAD,
    P_ADDON_CHEST,
    P_ADDON_LEG,
    P_ADDON_ARM,
  PlatformID* = enum
    ANY,
    XENON,
    PS3,
    DX9,
    WII,
    D3D10,
    UNKNOWN_6,
    UNKNOWN_7,
    UNKNOWN_8,
  RendererID* = enum
    XBOX360,
    PS3,
    DX9,
    D3D10,
    WII,
    GENERIC,
    D3D11,
  PixelFormat* = enum
    FMT_RGB,
    FMT_RGBA,
    FMT_PAL,
    FMT_PALA,
    FMT_DXT1,
    FMT_DXT3,
    FMT_DXT5,
    FMT_RGB24NONINT,
    FMT_BUMP,
    FMT_BUMPLUMA,
    FMT_RENDERSPEC,
    FMT_1CH,
    FMT_2CH,
    FMT_3CH,
    FMT_4CH,
    FMT_DEPTH_STENCIL,
    FMT_UNKNOWN,
  PixelTiling* = enum
    TILE_NONE,
    TILE_XENON,
    TILE_WII,
    TILE_NV_SWIZZLED,
  PixelComponent* = enum
    COMP_RED,
    COMP_GREEN,
    COMP_BLUE,
    COMP_ALPHA,
    COMP_COMPRESSED,
    COMP_OFFSET_U,
    COMP_OFFSET_V,
    COMP_OFFSET_W,
    COMP_OFFSET_Q,
    COMP_LUMA,
    COMP_HEIGHT,
    COMP_VECTOR_X,
    COMP_VECTOR_Y,
    COMP_VECTOR_Z,
    COMP_PADDING,
    COMP_INTENSITY,
    COMP_INDEX,
    COMP_DEPTH,
    COMP_STENCIL,
    COMP_EMPTY,
  PixelRepresentation* = enum
    REP_NORM_INT,
    REP_HALF,
    REP_FLOAT,
    REP_INDEX,
    REP_COMPRESSED,
    REP_UNKNOWN,
    REP_INT,
  PixelLayout* = enum
    LAY_PALETTIZED_8,
    LAY_HIGH_COLOR_16,
    LAY_TRUE_COLOR_32,
    LAY_COMPRESSED,
    LAY_BUMPMAP,
    LAY_PALETTIZED_4,
    LAY_DEFAULT,
    LAY_SINGLE_COLOR_8,
    LAY_SINGLE_COLOR_16,
    LAY_SINGLE_COLOR_32,
    LAY_DOUBLE_COLOR_32,
    LAY_DOUBLE_COLOR_64,
    LAY_FLOAT_COLOR_32,
    LAY_FLOAT_COLOR_64,
    LAY_FLOAT_COLOR_128,
    LAY_SINGLE_COLOR_4,
    LAY_DEPTH_24_X8,
  MipMapFormat* = enum
    MIP_FMT_NO,
    MIP_FMT_YES,
    MIP_FMT_DEFAULT,
  AlphaFormat* = enum
    ALPHA_NONE,
    ALPHA_BINARY,
    ALPHA_SMOOTH,
    ALPHA_DEFAULT,
  TexClampMode* = enum
    CLAMP_S_CLAMP_T,
    CLAMP_S_WRAP_T,
    WRAP_S_CLAMP_T,
    WRAP_S_WRAP_T,
  TexFilterMode* = enum
    FILTER_NEAREST,
    FILTER_BILERP,
    FILTER_TRILERP,
    FILTER_NEAREST_MIPNEAREST,
    FILTER_NEAREST_MIPLERP,
    FILTER_BILERP_MIPNEAREST,
    FILTER_ANISOTROPIC,
  SourceVertexMode* = enum
    VERT_MODE_SRC_IGNORE,
    VERT_MODE_SRC_EMISSIVE,
    VERT_MODE_SRC_AMB_DIF,
  LightingMode* = enum
    LIGHT_MODE_EMISSIVE,
    LIGHT_MODE_EMI_AMB_DIF,
  CycleType* = enum
    CYCLE_LOOP,
    CYCLE_REVERSE,
    CYCLE_CLAMP,
  FieldType* = enum
    FIELD_WIND,
    FIELD_POINT,
  BillboardMode* = enum
    ALWAYS_FACE_CAMERA,
    ROTATE_ABOUT_UP,
    RIGID_FACE_CAMERA,
    ALWAYS_FACE_CENTER,
    RIGID_FACE_CENTER,
    BSROTATE_ABOUT_UP,
    ROTATE_ABOUT_UP2,
    UNKNOWN_8,
    UNKNOWN_10,
    UNKNOWN_11,
    UNKNOWN_12,
  StencilTestFunc* = enum
    TEST_NEVER,
    TEST_LESS,
    TEST_EQUAL,
    TEST_LESS_EQUAL,
    TEST_GREATER,
    TEST_NOT_EQUAL,
    TEST_GREATER_EQUAL,
    TEST_ALWAYS,
  StencilAction* = enum
    ACTION_KEEP,
    ACTION_ZERO,
    ACTION_REPLACE,
    ACTION_INCREMENT,
    ACTION_DECREMENT,
    ACTION_INVERT,
  StencilDrawMode* = enum
    DRAW_CCW_OR_BOTH,
    DRAW_CCW,
    DRAW_CW,
    DRAW_BOTH,
  TestFunction* = enum
    TEST_ALWAYS,
    TEST_LESS,
    TEST_EQUAL,
    TEST_LESS_EQUAL,
    TEST_GREATER,
    TEST_NOT_EQUAL,
    TEST_GREATER_EQUAL,
    TEST_NEVER,
  AlphaFunction* = enum
    ONE,
    ZERO,
    SRC_COLOR,
    INV_SRC_COLOR,
    DEST_COLOR,
    INV_DEST_COLOR,
    SRC_ALPHA,
    INV_SRC_ALPHA,
    DEST_ALPHA,
    INV_DEST_ALPHA,
    SRC_ALPHA_SATURATE,
  ForceType* = enum
    FORCE_PLANAR,
    FORCE_SPHERICAL,
    FORCE_UNKNOWN,
  TransformMember* = enum
    TT_TRANSLATE_U,
    TT_TRANSLATE_V,
    TT_ROTATE,
    TT_SCALE_U,
    TT_SCALE_V,
  DecayType* = enum
    DECAY_NONE,
    DECAY_LINEAR,
    DECAY_EXPONENTIAL,
  SymmetryType* = enum
    SPHERICAL_SYMMETRY,
    CYLINDRICAL_SYMMETRY,
    PLANAR_SYMMETRY,
  VelocityType* = enum
    VELOCITY_USE_NORMALS,
    VELOCITY_USE_RANDOM,
    VELOCITY_USE_DIRECTION,
  EmitFrom* = enum
    EMIT_FROM_VERTICES,
    EMIT_FROM_FACE_CENTER,
    EMIT_FROM_EDGE_CENTER,
    EMIT_FROM_FACE_SURFACE,
    EMIT_FROM_EDGE_SURFACE,
  TextureType* = enum
    TEX_PROJECTED_LIGHT,
    TEX_PROJECTED_SHADOW,
    TEX_ENVIRONMENT_MAP,
    TEX_FOG_MAP,
  CoordGenType* = enum
    CG_WORLD_PARALLEL,
    CG_WORLD_PERSPECTIVE,
    CG_SPHERE_MAP,
    CG_SPECULAR_CUBE_MAP,
    CG_DIFFUSE_CUBE_MAP,
  EndianType* = enum
    ENDIAN_BIG,
    ENDIAN_LITTLE,
  MaterialColor* = enum
    TC_AMBIENT,
    TC_DIFFUSE,
    TC_SPECULAR,
    TC_SELF_ILLUM,
  LightColor* = enum
    LC_DIFFUSE,
    LC_AMBIENT,
  ConsistencyType* = enum
    CT_MUTABLE,
    CT_STATIC,
    CT_VOLATILE,
  SortingMode* = enum
    SORTING_INHERIT,
    SORTING_OFF,
  PropagationMode* = enum
    PROPAGATE_ON_SUCCESS,
    PROPAGATE_ON_FAILURE,
    PROPAGATE_ALWAYS,
    PROPAGATE_NEVER,
    PROPAGATE_UNKNOWN_6,
  CollisionMode* = enum
    USE_OBB,
    USE_TRI,
    USE_ABV,
    NOTEST,
    USE_NIBOUND,
  BoundVolumeKind* = enum
    BVBASE,
    BVSPHERE, # 0
    BVBOX, # 1
    BVCAPSULE, # 2
    BVUNION, # 4
    BVHALFSPACE,# 5
  FogFunction* = enum
    FOG_Z_LINEAR,
    FOG_RANGE_SQ,
    FOG_VERTEX_ALPHA,
  AnimType* = enum
    APP_TIME,
    APP_INIT,
  DitherFlags* = enum
    DITHER_DISABLED,
    DITHER_ENABLED,
  ShadeFlags* = enum
    SHADING_HARD,
    SHADING_SMOOTH,
  SpecularFlags* = enum
    SPECULAR_DISABLED,
    SPECULAR_ENABLED,
  WireframeFlags* = enum
    WIREFRAME_DISABLED,
    WIREFRAME_ENABLED,
  GeomMorpherFlags* = enum
    UPDATE_NORMALS_DISABLED,
    UPDATE_NORMALS_ENABLED,
  AGDConsistencyType* = enum
    AGD_MUTABLE,
    AGD_STATIC,
    AGD_VOLATILE,
  NiNBTMethod* = enum
    NBT_METHOD_NONE,
    NBT_METHOD_NDL,
    NBT_METHOD_MAX,
    NBT_METHOD_ATI,
  TransformMethod* = enum
    Maya_Deprecated,
    Max,
    Maya,
  ImageType* = enum
    IMRGB = "RGB",
    IMRGBA = "RGBA",
  NiPSysModifierOrder* = enum
    ORDER_KILLOLDPARTICLES,
    ORDER_BSLOD,
    ORDER_EMITTER,
    ORDER_SPAWN,
    ORDER_FO3_BSSTRIPUPDATE,
    ORDER_GENERAL,
    ORDER_FORCE,
    ORDER_COLLIDER,
    ORDER_POS_UPDATE,
    ORDER_POSTPOS_UPDATE,
    ORDER_WORLDSHIFT_PARTSPAWN,
    ORDER_BOUND_UPDATE,
    ORDER_SK_BSSTRIPUPDATE,
  hkWeldingType* = enum
    ANTICLOCKWISE,
  bhkCMSMatType* = enum
    SINGLE_VALUE_PER_CHUNK,

type
    RGB*[T:float32|byte] = object 
      r,g,b:T
    RGBA*[T:float32|byte] = object
      r,g,b,a:T
    MipMap* = object
      width,height,offset:uint16
    LODRange* = object
        nearextent:float32
        farextent: float32
        unknown: array[3,uint]
    NIFFooter* = object
      numRoots:uint
      roots: seq[uint32] # fix
    MatchGroup* = seq[uint16] # might not be necessary
    BoneVertData* = object
      index:uint16
      weight:float
    TBC* = object 
      tension,bias,cont:float32
    KeyFrame*[T] = object
      time:float32
      value: T
      case kind*:KeyType
      of QUADRATIC_KEY:
        forward:T
        backward:T
      of TBC_KEY:
        tbc:TBC
      else:
        discard
    KeyGroup*[T] = object
      numKeys:uint
      kind: KeyType
      keys: seq[KeyFrame[T]]
    QuatKey*[T] = object # @.@ so confusing
      time:float32
      case kind*:KeyType
      of LINEAR_KEY,QUADRATIC_KEY,CONST_KEY:
        value: T
      of TBC_KEY:
        tbcVal:T
        tbc:TBC
      else: discard
    TexCoord* = object
      u,v:float32
    TexDesc* = object # is this right?
      source: uint32 # nisourctexture fix
      clampMode: TexClampMode
      filterMode: TexFilterMode
      uvSet: uint
      ps2L: uint # fix
      ps2K: uint # fix
      unkonwn:uint # fix
    Triangle* = object
      v1,v2,v3:uint16
    NiPlane* = object
      normal:Vector3[float32]
      constant:float32
    NiBoundAABB* = object
      numCorners:int16 = 2
      corners:seq[Vector3[float32]]
    NiBound* = object
      center:Vector3[float32]
      radius:float32
    NiCurve3* = object
      degree:uint32
      numControlPts:uint32
      controlPts:seq[Vector3[float32]]
      numKnots:uint32
      knots:seq[float]
    NiQuatTransform* = object
      translation:Vector3[float32]
      rotation:Quaternion[float32]
      scale: float32 = 1.0
      trsValid:array[3,bool]
    NiTransform* = object
      rotation:Matrix[3,3,float32]
      translation:Vector3[float32]
      scale: float32 = 1.0
    Morph* = object
      numKeys:uint32
      interpolation:KeyType
      keys:seq[KeyFrame[float32]]
      vectors:seq[Vector3[float32]] # maybe fix?
    NiParticleInfo* = object
      velocity:Vector3[float32]
      rotAxis:Vector3[float32]
      age:float32
      lifeSpan:float32
      lastUpdate:float32
      spawnGen:uint16
      code:uint16
    BoneData* = object
      skinXform:NiTransform
      boundSphere:NiBound
      numVerts:uint16
      vertWeights:seq[BoneVertData]
    OldSkinData* = object
      vertWeight: float32
      vertIdx: uint16
      unknown:Vector3[float32] ######
    BoxBV* = object
      center,extent:Vector3[float32]
      axis: array[3,Vector3[float32]]
    CapsuleBV* = object 
      center,origin:Vector3[float32]
      extent,radius:float32
    HalfSpaceBV* = object
      plane:NiPlane
      center:Vector3[float32]
    UnionBV* = object
      numBV: uint32
      boundingVols:seq[BoundingVolume]
    BoundingVolume* = object 
      case kind*:BoundVolumeKind
      of BVSPHERE: sphere:NiBound
      of BVBOX: box:BoxBV
      of BVCAPSULE: capsule:CapsuleBV
      of BVUNION:ubv: UnionBV
      of BVHALFSPACE:halfspace:HalfSpaceBV
      else:discard # the other enum types may be useless???
    MorphWeight* = object
      interpolater:uint8 # fix NiInterpolater (maybe a linked list?)
      weight: float32
    InterpBlendItem* = object
      interpolater:uint8 # fix NiInterpolater (maybe a linked list?)
      weight: float32
      normWeight: float32
      priority:int32
      easeSpinner:float32
    PixelFormatComponent* = object

export Vector3,Vector4,Matrix,Quaternion
    
# <option value="0xffffffff" name="BASE_BV">Default</option>
#         <option value="0" name="SPHERE_BV">Sphere</option>
#         <option value="1" name="BOX_BV">Box</option>
#         <option value="2" name="CAPSULE_BV">Capsule</option>
#         <option value="4" name="UNION_BV">Union</option>
#         <option value="5" name="HALFSPACE_BV">Half Space</option>

# ushort: uint16
# short: int16
# ulittle32: uint32 (little endian)
# sbyte:int8
# byte: uint8
# BlockTypeIndex: int16
# Vector3: float32
# uint: uint32

#  <field name="Time" type="float" until="10.1.0.0">Time the key applies.</field>
#         <field name="Time" type="float" cond="#ARG# != 4" since="10.1.0.106">Time the key applies.</field>
#         <field name="Value" type="#T#" cond="#ARG# != 4">Value of the key.</field>
#         <field name="TBC" type="TBC" cond="#ARG# == 3">The TBC of the key.</field>
#     </struct>