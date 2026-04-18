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
func prev_id*(r): string = r.PNAM
func next_id*(r): string = r.NNAM
func data*(r):Option[InfoData] = r.DATA
proc dialogue_kind*(r: InfoData): DialogueKind = DialogueKind(r.kind)

func disposition_or_journal*(r:InfoData): uint32 =
    result = r.disposition_journal

func rank*(r: InfoData): int8 = r.rank

func male_gender*(r:InfoData): bool = r.gender == 0
func female_gender*(r:InfoData): bool = r.gender == 1
func no_gender*(r:InfoData): bool = r.gender == -1

func player_rank*(r:InfoData): int8 = r.pcrank

func actor_name*(r): Option[string] = r.ONAM
func race_name*(r): Option[string] = r.RNAM
func class_name*(r): Option[string] = r.CNAM
func faction_name*(r): Option[string] = r.FNAM
func cell_name*(r): Option[string] = r.ANAM
func pc_faction_name*(r): Option[string] = r.DNAM
func sound_name*(r): Option[string] = r.SNAM
func response_text*(r): Option[string] = r.NAME
func result_text*(r): Option[string] = r.BNAM

func script_vars*(r): seq[ScriptVar] = seq[ScriptVar](r.SCVR)

func quest_name*(r): Option[int8] = r.QSTN

func quest_finished*(r): Option[int8] = r.QSTF

func quest_restart*(r): Option[int8] = r.QSTR

# seems to be set to false in all cases....
func quest_enum*(r): Option[int8] =
    if isSome(r.QSTN):
        return r.QSTN
    elif isSome(r.QSTF):
        return r.QSTF
    else:
        return r.QSTR

# want to make this a little more readable/etc
func scr_str*(r:ScriptVar): string = r.SCVR
func script_var_idx*(r:ScriptVar): char = scr_str(r)[0]
func script_kind*(r:ScriptVar): char = scr_str(r)[1]
func script_details*(r:ScriptVar): string = scr_str(r)[2..3]
func script_op*(r:ScriptVar): char = scr_str(r)[4]
func script_name*(r:ScriptVar): string =
    let scr = scr_str(r)
    result = scr[5..high(scr)]
func script_intv*(r:ScriptVar): uint32 = r.INTV
func script_fltv*(r:ScriptVar): float32 = r.FLTV

proc `$`*(r): string =
    result = "INFO"
    result.add `T$`(r)