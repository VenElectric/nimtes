import std/options
import record

type
    InfoData* = ref object of DataField
        kind: uint8
        unused: array[3,uint8]
        disposition_journal: uint32
        rank: int8
        gender: int8
        pcrank: int8
        unused2: int8
    ScriptVar* = object
        SCVR: string
        INTV: uint32
        FLTV: float32
    INFO* = ref object of TES3Record
        INAM: string
        PNAM: string
        NNAM: string
        DATA:Option[InfoData]
        ONAM: Option[string]
        RNAM: Option[string]
        CNAM: Option[string]
        FNAM: Option[string]
        ANAM: Option[string]
        DNAM: Option[string]
        SNAM: Option[string]
        NAME: Option[string]
        SCVR: TagList[ScriptVar]
        BNAM: Option[string]
        QSTN: Option[int8]
        QSTF: Option[int8]
        QSTR: Option[int8]

using
    r:INFO

# dialogue/info for journals is set up like this:
    # DIAL record
    # seq[INFO] records...
    # where info records related to the DIAL record come right after it. 
    # could use table to grab DIAL->INFO records
    # and then use that to compare. maybe?

func id*(r): string = r.INAM
func prevId*(r): string = r.PNAM
func nextId*(r): string = r.NNAM
func data*(r):Option[InfoData] = r.DATA
proc dialogueKind*(r: InfoData): DialogueKind = DialogueKind(r.kind)

func disposition_or_journal*(r:InfoData): uint32 =
    result = r.disposition_journal

func rank*(r: InfoData): int8 = r.rank

func maleGender*(r:InfoData): bool = r.gender == 0
func femaleGender*(r:InfoData): bool = r.gender == 1
func noGender*(r:InfoData): bool = r.gender == -1

func playerRank*(r:InfoData): int8 = r.pcrank

func actorName*(r): Option[string] = r.ONAM
func raceName*(r): Option[string] = r.RNAM
func className*(r): Option[string] = r.CNAM
func factionName*(r): Option[string] = r.FNAM
func cellName*(r): Option[string] = r.ANAM
func pcFactionName*(r): Option[string] = r.DNAM
func soundName*(r): Option[string] = r.SNAM
func responseText*(r): Option[string] = r.NAME
func resultText*(r): Option[string] = r.BNAM

func scriptVars*(r): seq[ScriptVar] = seq[ScriptVar](r.SCVR)

func questName*(r): Option[int8] = r.QSTN

func questFinished*(r): Option[int8] = r.QSTF

func questRestart*(r): Option[int8] = r.QSTR

# seems to be set to false in all cases....
func questEnum*(r): Option[int8] =
    if isSome(r.QSTN):
        return r.QSTN
    elif isSome(r.QSTF):
        return r.QSTF
    else:
        return r.QSTR

# want to make this a little more readable/etc
func scrStr*(r:ScriptVar): string = r.SCVR
func scriptVarIdx*(r:ScriptVar): char = scrStr(r)[0]
func scriptKind*(r:ScriptVar): char = scrStr(r)[1]
func scriptDetails*(r:ScriptVar): string = scrStr(r)[2..3]
func scriptOp*(r:ScriptVar): char = scrStr(r)[4]
func scriptName*(r:ScriptVar): string =
    let scr = scrStr(r)
    result = scr[5..high(scr)]
func scriptIntv*(r:ScriptVar): uint32 = r.INTV
func scriptFltv*(r:ScriptVar): float32 = r.FLTV

proc `$`*(r): string =
    result = "INFO"
    result.add `T$`(r)