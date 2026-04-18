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

func master_files*(r): seq[MasterFile] = seq[MasterFile](r.MAST)
func file_name*(r: MasterFile): string = r.MAST
func data_size*(r: MasterFile): uint64 = r.DATA
func header*(r): HeaderData = r.HEDR
func version*(r): float32 = r.HEDR.version
proc is_master*(r): bool = has_flag(r.HEDR.flags, MASTER_FLAG)
func author*(r): string = r.HEDR.author
func file_desc*(r): string = r.HEDR.fileDesc
func num_records*(r): uint32 = r.HEDR.numRecords




proc `$`*(r): string =
    result = "TES3"
    result.add `T$`(r)


