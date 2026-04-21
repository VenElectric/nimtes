import std/[options, sugar, colors]
import record

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
        NAME: string
        DATA: CellData
        RGNN: Option[string]
        NAM5: Option[RGBA]
        WHGT: Option[float32]
        INTV: Option[int32]
        AMBI: Option[AmbientLight]
        MVRF: TagList[MovedRef]
        FRMR: TagList[FormRef]
        NAM0: Option[TemporaryChildren]

# NAM0.FRMR.0.FRMR
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

proc name*(r: CELL): Option[string] =
    if len(r.NAME) > 1:
        return some(r.NAME)

proc region*(r: CELL): Option[string] = r.RGNN

proc cellName*(r: CELL): string =
    if len(r.NAME) > 1:
        return stripNull(r.NAME)
    else:
        assert(isSome(region(r)), "Name < 2 and RGNN is none")
        return stripNull(get(region(r)))

proc data*(r): CellData = r.DATA
proc cellPos*(r): Grid[int32] = (x:data(r).gridx,y:data(r).gridy)
proc cellFlags*(r): set[CellFlags] =
    if hasFlag(data(r).flags,INTR):
        result.incl Interior
    if hasFlag(data(r).flags,WATER):
        result.incl HasWater
    if hasFlag(data(r).flags,ILLSLP):
        result.incl IllSleep
    if hasFlag(data(r).flags,BHVEXT):
        result.incl BehaveExt

func mapColor*(r): Option[RGBA] = r.NAM5

func waterHeight*(r): Option[float32] = 
    if isSome(r.WHGT):
        result = r.WHGT
    elif isSome(r.INTV):
        result = some(float32(get(r.INTV)))


func ambientLight*(r):Option[AmbientLight] = r.AMBI

proc ambientColor*(r: AmbientLight): Color = toColor(r.amcolor)
proc sunColor*(r: AmbientLight): Color = toColor(r.suncolor)
proc fogColor*(r: AmbientLight): Color = toColor(r.fogcolor)
func fogDensity*(r: AmbientLight): float32 = r.fogdens

func movedRefs*(r: CELL): seq[MovedRef] = seq[MovedRef](r.MVRF)

func movedRefId*(r: MovedRef): uint32 = r.MVRF
func movedRefCellName*(r: MovedRef): Option[string] = r.CNAM
func movedCoordiantes*(r: MovedRef): Option[Coords] = r.CNDT
func movedRef*(r: MovedRef): Option[FormRef] = r.FRMR

func refId*(r: FormRef): uint32 = r.FRMR
func refName*(r: FormRef): string = stripNull(r.NAME)
func refBlocked*(r:FormRef): bool = 
    result = false
    if isSome(r.UNAM):
        result = bool(get(r.UNAM))

func scale*(r: FormRef): float32 =
    if isSome(r.XSCL):
        return get(r.XSCL)
    else:
        return 1.0

func npcId*(r: FormRef): Option[string] = r.ANAM

func globalVar*(r:FormRef): Option[string] = r.BNAM

func factionId*(r: FormRef): Option[string] = r.CNAM

func factionRank*(r:FormRef): Option[uint32] = r.INDX

func soulId*(r: FormRef): Option[string] = r.XSOL
func charge*(r: FormRef): Option[float32] = r.XCHG

func usageLeft*(r: FormRef): Option[float32] = r.INTV # may n
func value*(r: FormRef): Option[uint32] = r.NAM9
func cellTravelDests*(r: FormRef): seq[CellTravelData] = seq[CellTravelData](r.DODT)
func lockDiff*(r: FormRef): Option[uint32] = r.FLTV
func keyName*(r: FormRef): Option[string] = r.KNAM
func trapName*(r: FormRef): Option[string] = r.TNAM
func refDisabled*(r:FormRef): bool = 
    result = false
    if isSome(r.ZNAM):
        result = bool(get(r.ZNAM))
func refPos*(r: FormRef): Option[CellPosition] = r.DATA

proc persistentChildren*(r: CELL): seq[FormRef] = seq[FormRef](r.FRMR)

proc tempChildrenCount*(r: CELL): uint32 =
    result = 0
    if isSome(r.NAM0):
        result = get(r.NAM0).NAM0

proc temporaryChildren*(r: CELL): seq[FormRef] =
    result = @[]
    if isSome(r.NAM0):
        result = seq[FormRef](get(r.NAM0).FRMR)

proc findMovedReference*(r; id: string): Option[MovedRef] =
    let mvrf = movedRefs(r)
    if len(mvrf) > 0:
        let results = collect(newSeq):
            for m in mvrf:
                if isSome(movedRef(m)):
                    let r = get(movedRef(m))
                    if refName(r) == id: m
        if len(results) > 0:
            result = some(results[0])

proc findMovedReference*(r;id: uint32): Option[MovedRef] =
    let mvrf = movedRefs(r)
    if len(mvrf) > 0:
        let results = collect(newSeq):
            for m in mvrf:
                    if movedRefId(m) == id: m
        if len(results) > 0:
            result = some(results[0])

proc findPersistReference*(r; id: string): Option[FormRef] =
    let fr = persistentChildren(r)
    if len(fr) > 0:
        let results = collect(newSeq):
            for m in fr:
                if refName(m) == id: m
        if len(results) > 0:
            result = some(results[0])

proc findPersistReference*(r; id: uint32): Option[FormRef] =
    let fr = persistentChildren(r)
    if len(fr) > 0:
        let results = collect(newSeq):
            for m in fr:
                if refId(m) == id: m
        if len(results) > 0:
            let form = results[0]
            assert(refId(form) == id)
            result = some(form)

#NAME value
proc findTempChild*(r; id: string): Option[FormRef] = 
    if tempChildrenCount(r) > 0:
        let tc = temporaryChildren(r)
        let results = collect(newSeq):
            for m in tc:
                if refName(m) == id: m
        if len(results) > 0:
            result = some(results[0])

#FRMR value
proc findTempChild*(r; id: uint32): Option[FormRef] = 
    if tempChildrenCount(r) > 0:
        let tc = temporaryChildren(r)
        let results = collect(newSeq):
            for m in tc:
                if refId(m) == id: m
        if len(results) > 0:
            result = some(results[0])

proc `$`*(r: CELL): string =
    result = "CELL"
    result.add `T$`(r)

export travelDest, prevDestName
