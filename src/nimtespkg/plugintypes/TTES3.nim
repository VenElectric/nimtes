import record

type
    HeaderData* = ref object of DataField
        version: float32
        flags: uint32
        author {.zsize(32).}: string
        fileDesc{.zsize(256).}: string
        numRecords: uint32
    MasterFile* = object
        MAST: string
        DATA: uint64
    TES3* = ref object of TES3Record
        HEDR: HeaderData
        MAST: TagList[MasterFile]

const MASTER_FLAG: uint32 = 0x1

using 
    r:TES3

func masterFiles*(r): seq[MasterFile] = seq[MasterFile](r.MAST)
func fileName*(r: MasterFile): string = r.MAST
func dataSize*(r: MasterFile): uint64 = r.DATA
func header*(r): HeaderData = r.HEDR
func version*(r): float32 = r.HEDR.version
proc isMaster*(r): bool = hasFlag(r.HEDR.flags, MASTER_FLAG)
func author*(r): string = r.HEDR.author
func fileDesc*(r): string = r.HEDR.fileDesc
func numRecords*(r): uint32 = r.HEDR.numRecords




proc `$`*(r): string =
    result = "TES3"
    result.add `T$`(r)


