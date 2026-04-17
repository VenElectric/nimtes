import std/[options, sugar, colors]
import record, util,conflicts,reader,tescfg

type
    CellFlags* = enum 
        Interior = (0,"Interior"),
        HasWater = "Has water",
        IllSleep = "Illegal to sleep here",
        BehaveExt = "Behave like exterior"
    CellData* = ref object of DataField
        flags*: uint32
        gridx*: int32
        gridy*: int32
    AmbientLight* = ref object of DataField
        amcolor: RGBA
        suncolor: RGBA
        fogcolor: RGBA
        fogdens: float32
    MovedRef* = object
        MVRF*: uint32
        CNAM*: Option[string]
        CNDT*: Option[Coords]
        FRMR*: Option[FormRef]
    FormRef* = object
        FRMR*: uint32
        NAME*: string
        UNAM*: Option[uint8]
        XSCL*: Option[float32]
        ANAM*: Option[string]
        BNAM*: Option[string]
        CNAM*: Option[string]
        INDX*: Option[uint32]
        XSOL*: Option[string]
        XCHG*: Option[float32]
        INTV*: Option[float32] # ugh...could be uint32 or float32 depending on "type" however you get that info...
        NAM9*: Option[uint32]
        DODT*: TagList[CellTravelData]
        FLTV*: Option[uint32]
        KNAM*: Option[string]
        TNAM*: Option[string]
        ZNAM*: Option[int8]
        DATA*: Option[CellPosition]
    TemporaryChildren* = object
        NAM0*: uint32
        FRMR*: TagList[FormRef]
    CELL* = ref object of TES3Record
        NAME{.dtag("ID").}: string
        DATA{.dtag("Cell Data").}: CellData
        RGNN{.dtag("Region Name").}: Option[string]
        NAM5{.dtag("Map Color").}: Option[RGBA]
        WHGT{.dtag("Moved References").}: Option[float32]
        INTV{.dtag("Moved References").}: Option[int32]
        AMBI{.dtag("Moved References").}: Option[AmbientLight]
        MVRF{.dtag("Moved References").}: TagList[MovedRef]
        FRMR{.dtag("Persistent Children").}: TagList[FormRef]
        NAM0: Option[TemporaryChildren]
# 0x01 = Interior

# tag definitions
# NAM0 -> FRMR -> temporary children
# NAM0 -> count of temporary children
# CELL -> FRMR -> persistent children
# CELL -> MVRF -> FRMR -> form reference that was moved
# CELL -> MVRF -> moved references
# CELL -> MVRF -> MVRF ->


# COMPARISONS
# LENGTH OF TEMP CHILDREN
# LENGTH OF MOVED REFS
# LENGTH OF PERSIST CHILDREN
# region names????
# cell data pos

const INTR: uint32 = 0x01
const WATER: uint32 = 0x02
const ILLSLP: uint32 = 0x04
const BHVEXT: uint32 = 0x80

using
    r:CELL

proc data*(r): CellData = r.DATA

func map_color*(r): Option[RGBA] = r.NAM5

proc flags*(r): set[CellFlags] =
    if has_flag(data(r).flags,INTR):
        result.incl Interior
    if has_flag(data(r).flags,WATER):
        result.incl HasWater
    if has_flag(data(r).flags,ILLSLP):
        result.incl IllSleep
    if has_flag(data(r).flags,BHVEXT):
        result.incl BehaveExt

func ambient_light*(r): Option[AmbientLight] = r.AMBI

proc ambient_color*(r: AmbientLight): Color = to_color(r.amcolor)
proc sun_color*(r: AmbientLight): Color = to_color(r.suncolor)
proc fog_color*(r: AmbientLight): Color = to_color(r.fogcolor)
func fog_density*(r: AmbientLight): float32 = r.fogdens

proc name*(r: CELL): Option[string] =
    if len(r.NAME) > 1:
        return some(r.NAME)

proc region*(r: CELL): Option[string] = r.RGNN

proc cell_name*(r: CELL): string =
    if len(r.NAME) > 1:
        return stripNull(r.NAME)
    else:
        assert(isSome(region(r)), "Name < 2 and RGNN is none")
        return stripNull(get(region(r)))

func moved_refs*(r: CELL): seq[MovedRef] = seq[MovedRef](r.MVRF)

func moved_ref_id*(r: MovedRef): uint32 = r.MVRF
func moved_ref_cell_name*(r: MovedRef): Option[string] = r.CNAM
func moved_coordiantes*(r: MovedRef): Option[Coords] = r.CNDT
func moved_ref*(r: MovedRef): Option[FormRef] = r.FRMR

proc persistent_children*(r: CELL): seq[FormRef] = seq[FormRef](r.FRMR)


proc temp_children_count*(r: CELL): uint32 =
    result = 0
    if isSome(r.NAM0):
        result = get(r.NAM0).NAM0

proc temporary_children*(r: CELL): seq[FormRef] =
    result = @[]
    if isSome(r.NAM0):
        result = seq[FormRef](get(r.NAM0).FRMR)




func ref_id*(r: FormRef): uint32 = r.FRMR
func ref_name*(r: FormRef): string = stripNull(r.NAME)
func scale*(r: FormRef): float32 =
    if isSome(r.XSCL):
        return get(r.XSCL)
    else:
        return 1.0

func npc_id*(r: FormRef): Option[string] = r.ANAM
func faction_id*(r: FormRef): Option[string] = r.CNAM
func soul_id*(r: FormRef): Option[string] = r.XSOL
func charge*(r: FormRef): Option[float32] = r.XCHG
func usage_left*(r: FormRef): Option[float32] = r.INTV
func value*(r: FormRef): Option[uint32] = r.NAM9
func cell_travel_dests*(r: FormRef): seq[CellTravelData] = seq[CellTravelData](r.DODT)
func lock_diff*(r: FormRef): Option[uint32] = r.FLTV
func key_name*(r: FormRef): Option[string] = r.KNAM
func trap_name*(r: FormRef): Option[string] = r.TNAM
func ref_pos*(r: FormRef): Option[CellPosition] = r.DATA


proc find_moved_reference*(r; id: string): Option[MovedRef] =
    let mvrf = moved_refs(r)
    if len(mvrf) > 0:
        let results = collect(newSeq):
            for m in mvrf:
                if isSome(moved_ref(m)):
                    let r = get(moved_ref(m))
                    if ref_name(r) == id: m
        if len(results) > 0:
            result = some(results[0])

proc find_moved_reference*(r;id: uint32): Option[MovedRef] =
    let mvrf = moved_refs(r)
    if len(mvrf) > 0:
        let results = collect(newSeq):
            for m in mvrf:
                    if moved_ref_id(m) == id: m
        if len(results) > 0:
            result = some(results[0])

proc find_persist_reference*(r; id: string): Option[FormRef] =
    let fr = persistent_children(r)
    if len(fr) > 0:
        let results = collect(newSeq):
            for m in fr:
                if ref_name(m) == id: m
        if len(results) > 0:
            result = some(results[0])

proc find_persist_reference*(r; id: uint32): Option[FormRef] =
    let fr = persistent_children(r)
    if len(fr) > 0:
        let results = collect(newSeq):
            for m in fr:
                if ref_id(m) == id: m
        if len(results) > 0:
            result = some(results[0])

#NAME value
proc find_temp_child*(r; id: string): Option[FormRef] = 
    if temp_children_count(r) > 0:
        let tc = temporary_children(r)
        let results = collect(newSeq):
            for m in tc:
                if ref_name(m) == id: m
        if len(results) > 0:
            result = some(results[0])

#FRMR value
proc find_temp_child*(r; id: uint32): Option[FormRef] = 
    if temp_children_count(r) > 0:
        let tc = temporary_children(r)
        let results = collect(newSeq):
            for m in tc:
                if ref_id(m) == id: m
        if len(results) > 0:
            result = some(results[0])

proc check*(l,r:MovedRef,what:string,msgs:var seq[string]) = discard

proc check*(l,r:FormRef,what:string,msgs:var seq[string]) = discard

proc checkConflict*(c:TES3Cfg,main,toCmp:CELL):seq[string] =
    if cell_name(main) != cell_name(toCmp):
        return

proc `$`*(r: CELL): string =
    result = "CELL"
    result.add `T$`(r)

export travel_dest, prev_dest_name
