import std/options
import record, util,conflicts,reader,tescfg
type
    ACTI* = ref object of TES3Record
        NAME {.dtag("ID").}: string
        MODL {.dtag("Model Name").}: Option[string]
        FNAM {.dtag("Name").}: Option[string]
        SCRI {.dtag("Script Name").}: Option[string]

const ACTITAG = "ACTI"

using
    r: ACTI
    s: Stream

func id*(r): string = stripNull(r.NAME)
func model_path*(r):Option[string] = r.MODL
func name*(r): Option[string] = r.FNAM
func script_name*(r): Option[string] = r.SCRI

proc readActivator*(s): ACTI = readRecord(s,ACTI)

proc readAllActivator*(s): seq[ACTI] = readAllRecordofType(s,ACTI,ACTITAG)



proc checkConflict*(c:TES3Cfg,main:ACTI,toCmp:ACTI):seq[string] = 
    if id(main) != id(toCmp):
        return
    result = check(main,toCmp)

    if isSome(model_path(toCmp)):
        let path = createMeshPath(path(c),get(toCmp))
        if not checkPath(path):
            result.add "Invalid mesh path: " & $path


proc checkActi*(c:TES3Cfg,main,other:Stream):seq[RecordConflicts] = 
    result = @[]
    var mainTags = getRecordOffsetsOfType(s,ACTITAG)
    var otherTags = getRecordOffsetsOfType(s,ACTITAG)

    for r in items(mainTags):
        setPosition(main,r.pos - 8)
        let mRec = readActivator(main)
        for o in items(otherTags):
            setPosition(other,o.pos - 8)
            let oRec = readActivator(other)
            if id(mRec) == id(oRec):
                let msgs = checkConflict(mRec,oRec)
                if len(msgs) > 0:
                    result.add newConflict(id,msgs)
                break



proc `$`*(r): string =
    result = "ACTI"
    result.add `$T`(r)
