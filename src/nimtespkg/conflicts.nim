import std/[tables,strformat,paths,files,dirs,options,colors]
import util,tescfg,testypes
from macros import getCustomPragmaVal,hasCustomPragma
from strutils import replace,endsWith,indent

type

    RecordConflicts* = object
        id: string
        messages: seq[string]
    PluginData* = Table[string,seq[RecordConflicts]] # TAG (i.e. CELL),Conflicts
    CompareResult* = object
        masters: seq[string]
        records*: CountTable[string]
        plugin*: string
        checked_plugins: seq[string]
        conflicts: Table[string,PluginData] # Plugin,Conflicts


const DATA_FILES* = Path("Data Files")
const FONTS* = Path("Fonts")
const ICONS* = Path("Icons")
const MESHES* = Path("Meshes")
const MUSIC* = Path("Music")
const SOUNDS* = Path("Sound")
const SPLASH* = Path("Splash")
const TEXTURES* = Path("Textures")
const VIDEOS* = Path("Video")

func newCompareResult*(plugin:string): CompareResult =
    result.masters = @[]
    result.plugin = plugin
    result.records = initCountTable[string]()

func newPluginData*(): PluginData = initTable[string,seq[RecordConflicts]]()

func newConflict*(id:string,messages:seq[string]): RecordConflicts =
    result.id = id
    result.messages = messages

proc addMaster*(cv:var CompareResult,master:string) =
    cv.masters.add master

proc setMasters*(cv:var CompareResult,masters:seq[string]) = 
    cv.masters = masters

proc addPluginData*(cv: var CompareResult,key:string,pd:PluginData) =
    cv.conflicts[key] = pd

proc add*(pd:var PluginData,key:string,rc:RecordConflicts) = 
    if not hasKey(pd,key):
        pd[key] = @[]
    add(pd[key],rc)

func len*(rc:RecordConflicts): int = len(rc.messages)

proc add*(rc:var RecordConflicts,message:string) =
    rc.messages.add message

# messages
# X file does not exist
# X.attr changed from A to C
# X1 is missing from X but is in Y

func createMessage*(what,initial,change:string): string = 
    fmt"{what} changed from {initial} to {change}"

func missingFile(what:string,path:Path): string = fmt"{what} file missing: {path}"
func missingMeshFile*(path:Path): string = missingFile("Mesh",path)
func missingMusicFile*(path:Path): string = missingFile("Music",path)
func missingIconFile*(path:Path): string = missingFile("Icon",path)
func missingTextureFile*(path:Path): string = missingFile("Texture",path)
func missingFontFile*(path:Path): string = missingFile("Font",path)
func missingSoundFile*(path:Path): string = missingFile("Sound",path)


proc getPluginFiles*(c:TES3Cfg): seq[string] = 
    let pluginPath = path(c) / DATA_FILES
    for k,p in walkDir(pluginPath):
        if k == pcFile:
            let plugin = string(extractFilename(p))
            if endsWith(plugin,".esp"):
                result.add plugin

proc getMasterFiles*(c:TES3Cfg): seq[string] =
    let pluginPath = path(c) / DATA_FILES
    for k,p in walkDir(pluginPath):
        if k == pcFile:
            let plugin = string(extractFilename(p))
            if endsWith(plugin,".esm"):
                result.add plugin

proc verifyMasters*(r:TES3; c: TES3Cfg): seq[string] =
    result = @[]
    let mf = masterFiles(r)
    if len(mf) > 0:
        for m in mf:
            let filePath = path(c) / DATA_FILES / Path(fileName(m))
            if not fileExists(filePath): # return list of master ifles t
                result.add(fileName(m))



proc createMeshPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createMusicPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createTexturePath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createFontPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createIconPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createSoundPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))

proc checkPath*(p:Path): bool = fileExists(p)

proc checkMeshHelper*(tesPath:Path,file:string,msgs:var seq[string])=
    let p = createMeshPath(tesPath,file)
    if not checkPath(p):
        msgs.add missingMeshFile(p)

proc checkMeshHelper*(tesPath:Path,file:Option[string],msgs:var seq[string]) =
    if isSome(file):
        checkMeshHelper(tesPath,get(file),msgs)

proc checkMusicHelper*(tesPath:Path,file:string,msgs:var seq[string]) =
    let p = createMusicPath(tesPath,file)
    if not checkPath(p):
        msgs.add missingMusicFile(p)

proc checkMusicHelper*(tesPath:Path,file:Option[string],msgs:var seq[string]) = 
    if isSome(file):
        checkMusicHelper(tesPath,get(file),msgs)

proc checkTextureHelper*(tesPath:Path,file:string,msgs:var seq[string]) =
    let p = createTexturePath(tesPath,file)
    if not checkPath(p):
        msgs.add missingTextureFile(p)

proc checkTextureHelper*(tesPath:Path,file:Option[string],msgs:var seq[string]) = 
    if isSome(file):
        checkTextureHelper(tesPath,get(file),msgs)

proc checkIconHelper*(tesPath:Path,file:string,msgs:var seq[string]) =
    let p = createIconPath(tesPath,file)
    if not checkPath(p):
        msgs.add missingIconFile(p)

proc checkIconHelper*(tesPath:Path,file:Option[string],msgs:var seq[string]) = 
    if isSome(file):
        checkIconHelper(tesPath,get(file),msgs)

proc checkSoundHelper*(tesPath:Path,file:string,msgs:var seq[string]) =
    let p = createSoundPath(tesPath,file)
    if not checkPath(p):
        msgs.add missingSoundFile(p)

proc checkSoundHelper*(tesPath:Path,file:Option[string],msgs:var seq[string]) = 
    if isSome(file):
        checkSoundHelper(tesPath,get(file),msgs)




proc check*[T:enum|string|SomeFloat|SomeInteger|Color|bool](l,r:T,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add createMessage(what,$l,$r)

proc check*[T:enum](l,r:set[T],what:string,msgs:var seq[string]) =
    for v in l:
        if not r.contains(v):
            msgs.add fmt"{v} not found in {what} for this plugin"


proc check*[T:SomeInteger](l,r:Grid[T],what:string,msgs:var seq[string]) = 
    if l.x != r.x and l.y != r.y:
        msgs.add createMessage(what,$l,$r)


proc check*[T:enum|string|SomeFloat|SomeInteger|bool](l,r:Option[T],what:string,msgs:var seq[string])
proc check*[T:object](l,r:Option[T],what:string,msgs:var seq[string])
proc check*[T:object](l,r:T,what:string,msgs:var seq[string])

proc check*[T:object](l,r:ref T,what:string,msgs:var seq[string]) = 
    for lkey,lvalue in fieldPairs(l[]):
        for rkey,rvalue in fieldPairs(r[]):
            when lkey == rkey:
                check(lvalue,rvalue,what & "." & lkey,msgs)
                break

# could maybe use tables here instead....
# need to remember to skip over the junk values...maybe label those or 
# use a pragma
proc check*[T:object](l,r:T,what:string,msgs:var seq[string]) = 
    for lkey,lvalue in fieldPairs(l):
        for rkey,rvalue in fieldPairs(r):
            when lkey == rkey:
                check(lvalue,rvalue,what & "." & lkey,msgs)
                break


proc check*[T:enum|string|SomeFloat|SomeInteger|bool](l,r:Option[T],what:string,msgs:var seq[string]) =
    if l != r:
        if isSome(l) and isNone(r):
            msgs.add createMessage(what,$get(l),"None")
        elif isNone(l) and isSome(r):
            msgs.add createMessage(what,"None",$get(r))
        elif isSome(l) and isSome(r):
            msgs.add createMessage(what,$get(l),$get(r))

proc check(l,r:FormRef,what:string,msgs: var seq[string]) = 
    check(refName(l),refName(r),what & ":Reference Name",msgs)
    check(refBlocked(l),refBlocked(r),what & ":Reference Blocked",msgs)
    check(scale(l),scale(r),what & ":Reference Scale",msgs)
    check(npcId(l),npcId(r),what & ":NPC ID",msgs) # hopefully one wouldn't change NPC ids on a ref id???
    check(globalVar(l),globalVar(r),what & ":Global Variable Name",msgs)
    check(factionId(l),factionId(r),what & ":Faction ID",msgs)
    check(factionRank(l),factionRank(r),what & ":Faction Rank",msgs)
    check(soulId(l),soulId(r),what & ":Soul Gem ID",msgs)
    check(soulId(l),soulId(r),what & ":Soul Gem ID",msgs)
    check(charge(l),charge(r),what & ":Soul Gem Charge",msgs)
    check(usageLeft(l),usageLeft(r),what & ":Item Usage Left",msgs)
    check(value(l),value(r),what & ":Item Value",msgs)
    # cell travel destinations
    check(lockDiff(l),lockDiff(r),what & ":Lock Difficulty",msgs)
    check(refDisabled(l),refDisabled(r),what & ":Reference Disabled",msgs)
    # Cell position

proc check(l,r:MovedRef,what:string,msgs: var seq[string]) = 
    check(movedRefCellName(l),movedRefCellName(r),what & ": Cell Name",msgs)
    # coords
    check(movedRef(l),movedRef(r),what,msgs)

proc check[T](l,r:seq[T],what:string,msgs: var seq[string]) = discard

# object equality....probably won't work unless we have defined object equality for each
proc check*[T:object](l,r:Option[T],what:string,msgs:var seq[string]) =
    if l != r:
        if isSome(l) and isNone(r):
            msgs.add "Data removed from plugin"
        elif isNone(l) and isSome(r):
            msgs.add "Data added to plugin"
        elif isSome(l) and isSome(r):
            check(get(l),get(r),what,msgs)

proc simpleCheck[T:TES3Record](one,two:T):seq[string] =
    result = @[]
    for okey,ovalue in fieldPairs(one[]):
        for tkey,tvalue in fieldPairs(two[]):
            when okey == tkey:
                when hasCustomPragma(ovalue,dtag):
                    
                    check(ovalue,tvalue,getCustomPragmaVal(ovalue,dtag),result)
                    # gets messy for seq values...maybe
                break



# need to ensure these simple check ones have dtags
proc check*(tesPath:Path,one,two:ACTI): seq[string] = 
    result = simpleCheck(one,two)
    checkMeshHelper(tesPath,modelPath(two),result)

proc check*(tesPath:Path,one,two:ALCH): seq[string] = 
    result = simpleCheck(one,two)
    checkMeshHelper(tesPath,modelPath(two),result)
    checkIconHelper(tesPath,iconPath(two),result)

proc check*(tesPath:Path,one,two:APPA): seq[string] = 
    result = simpleCheck(one,two)
    checkMeshHelper(tesPath,modelPath(two),result)
    checkIconHelper(tesPath,iconPath(two),result)

proc check*(tesPath:Path,one,two:ARMO): seq[string] = 
    result = @[]
    check(modelPath(one),modelPath(two),"Model Path",result)
    check(name(one),name(two),"Name",result)
    check(scriptName(one),scriptName(two),"Name",result)
    check(armorKind(one),armorKind(two),"Armor Kind",result)
    check(weight(one),weight(two),"Weight",result)
    check(value(one),value(two),"Value",result)
    check(health(one),health(two),"Item Health",result)
    check(enchantPoints(one),enchantPoints(two),"Enchantment Points",result)
    check(rating(one),rating(two),"Armor Rating",result)
    check(iconPath(one),iconPath(two),"Icon Path",result)
    check(enchantName(one),enchantName(two),"Enchantment Name",result)
    if len(bodyData(one)) != len(bodyData(two)):
        result.add fmt"Number of Biped Objects differs: {len(bodyData(one))} -> {len(bodyData(two))}"
    let itemSlotsOne = listItemSlots(one)
    let itemSlotsTwo = listItemSlots(two)
    for slot in itemSlotsOne:
        let f = find(itemSlotsTwo,slot)
        if f == -1:
            result.add fmt"Item slot: {slot} not found in {id(two)} record"
    checkMeshHelper(tesPath,modelPath(two),result)
    checkIconHelper(tesPath,iconPath(two),result)

proc check*(tesPath:Path,one,two:BODY): seq[string] = 
    result = @[]
    checkMeshHelper(tesPath,modelPath(two),result)
    check(modelPath(one),modelPath(two),"Model Path",result)
    check(race(one),race(two),"Race",result)
    check(bodyPart(one),bodyPart(two),"Body Part",result)
    check(isVampire(one),isVampire(two),"Vampire Status",result)
    check(isFemale(one),isFemale(two),"Female Gender Status",result)
    check(isPlayable(one),isPlayable(two),"Playable Status",result)
    check(partKind(one),partKind(two),"Kind of Body Part",result)
    
proc check*(tesPath:Path,one,two:CELL): seq[string] =
    result = @[]
    check(name(one),name(two),"Cell Name",result)
    check(region(one),region(two),"Region Name",result)
    check(cellPos(one),cellPos(two),"Cell Position",result)
    check(cellFlags(one),cellFlags(two),"Cell Flags",result)
    check(mapColor(one),mapColor(two),"Map Color",result)
    check(waterHeight(one),waterHeight(two),"Water Height",result)
    if isSome(ambientLight(one)) and isSome(ambientLight(two)):
        let l = get(ambientLight(one))
        let r = get(ambientLight(two))
        check(ambientColor(l),ambientColor(r),"Ambient Color",result)
        check(sunColor(l),sunColor(r),"Sun Color",result)
        check(fogColor(l),fogColor(r),"Fog Color",result)
        check(fogDensity(l),fogDensity(r),"Fog Density",result)
    elif isNone(ambientLight(one)) and isSome(ambientLight(two)):
        result.add "Plugin adds ambient color values. None were listed prior."
    elif isSome(ambientLight(one)) and isNone(ambientLight(two)):
        result.add "Plugin removes ambient color values."
    let mvrfOne = movedRefs(one)
    let mvrfTwo = movedRefs(two)
    if len(mvrfOne) != len(mvrfTwo):
        result.add "Number of Moved References changed from " & $len(mvrfOne) & " to " & $len(mvrfTwo)
    for mvrf in mvrfOne:
        let rfTwo = findMovedReference(two,movedRefId(mvrf))
        if isSome(rfTwo):
            check(mvrf,get(rfTwo),"Moved Reference: " & $movedRefId(mvrf),result)
    
    let persistOne = persistentChildren(one)
    let persistTwo = persistentChildren(two)
    if len(persistOne) != len(persistTwo):
        result.add "Number of Persistent Children changed from " & $len(persistOne) & " to " & $len(persistTwo)
    for pChld in persistOne:
        let pChldTwo = findPersistReference(two,refId(pChld))
        if isSome(pChldTwo):
            check(pChld,get(pChldTwo ),"Persistent Child: " & $refId(pChld),result)
        else:
            result.add "Persistent child " & "(" & $refId(pChld) & ") removed from plugin."

    let tempOne = temporaryChildren(one)
    let tempTwo = temporaryChildren(two)
    if len(tempOne) != len(tempTwo):
        result.add "Number of Persistent Children changed from " & $len(tempOne) & " to " & $len(tempTwo)
    for tChld in tempOne:
        let tChldTwo = findTempChild(two,refId(tChld))
        if isSome(tChldTwo):
            check(tChld,get(tChldTwo),"Persistent Child: " & $refId(tChld),result)
        else:
            result.add "Persistent child " & "(" & $refId(tChld) & ") removed from plugin."


    



proc `$`(cd:RecordConflicts): string = 
    result = fmt"__{cd.id}__" & "\n"
    for msg in cd.messages:
        result.add indent("- " & msg,INDENTAMT) & "\n"
proc `$`*(pd:PluginData): string = 
    for k,v in pairs(pd):
        result.add indent("### " & k,INDENTAMT) & "\n"
        for cd in v:
            result.add $cd

proc `$`*(cr:CompareResult): string = 
    result = fmt"# {cr.plugin}" & "\n"
    result.add "# Plugins Checked\n"
    for p in cr.checked_plugins:
        result.add fmt"- {p}" & "\n"
    result.add "# Conflicting Plugins\n"
    result.add "## Summary\n"

    for k in cr.conflicts.keys:
        result.add fmt"- {k}" & "\n"
    result.add "## Details\n"
    for _,c in pairs(cr.conflicts):
        result.add $c







    