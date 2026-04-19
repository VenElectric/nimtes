import std/[tables,strformat,paths,files,dirs,options]
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

func missingFile(what,path:string): string = fmt"{what} file missing: {path}"
func missingMeshFile*(path:string): string = missingFile("Mesh",path)
func missingMusicFile*(path:string): string = missingFile("Music",path)
func missingIconFile*(path:string): string = missingFile("Icon",path)
func missingTextureFile*(path:string): string = missingFile("Texture",path)
func missingFontFile*(path:string): string = missingFile("Font",path)
func missingSoundFile*(path:string): string = missingFile("Sound",path)


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

proc check*[T:SomeFloat|SomeInteger|string|bool](l,r:Option[T],what:string,msgs:var seq[string])
proc check*[T:object](l,r:Option[T],what:string,msgs:var seq[string])
proc check(one,two:BipedObject,msgs:var seq[string]): seq[string]

proc check*(l,r:SomeInteger,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add createMessage(what,$l,$r)
proc check*(l,r:SomeFloat,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add createMessage(what,$l,$r)
proc check*(l,r,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add createMessage(what,l,r)

proc check*[T:enum](l,r:T,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add createMessage(what,$l,$r)

proc check*[T:enum](l,r:set[T],what:string,msgs:var seq[string]) =
    for v in l:
        if not r.contains(v):
            msgs.add fmt"{v} not found in {what} for this plugin"

# what, from, to
#(string,string,string)
proc check*[T:object](l,r:T,what:string,msgs:var seq[string]) = 
    for lkey,lvalue in fieldPairs(l):
        for rkey,rvalue in fieldPairs(r):
            if lkey == rkey:
                check(lvalue,rvalue,what & "." & lkey,msgs)
                break


proc check*[T:SomeFloat|SomeInteger|string|bool](l,r:Option[T],what:string,msgs:var seq[string]) =
    if l != r:
        if isSome(l) and isNone(r):
            msgs.add createMessage(what,get(l),"None")
        elif isNone(l) and isSome(r):
            msgs.add createMessage(what,"None",get(r))
        elif isSome(l) and isSome(r):
            msgs.add createMessage(what,get(l),get(r))

proc check*[T:object](l,r:Option[T],what:string,msgs:var seq[string]) =
    if l != r:
        if isSome(l) and isNone(r):
            msgs.add createMessage(what,get(l),"None")
        elif isNone(l) and isSome(r):
            msgs.add createMessage(what,"None",get(r))
        elif isSome(l) and isSome(r):
            check(get(l),get(r),what,msgs)

proc simpleCheck[T:TES3Record](one,two:T):seq[string] =
    result = @[]
    for okey,ovalue in fieldPairs(one[]):
        for tkey,tvalue in fieldPairs(two[]):
            when okey == tkey:
                when hasCustomPragma(ovalue,dtag):
                    check(ovalue,tvalue,getCustomPragmaVal(ovalue,dtag),result)
                break

proc check(one,two:BipedObject,msgs:var seq[string]): seq[string] = 
    check(itemSlot(one),itemSlot(two),"Biped Item Slot",msgs)
    check(maleName(one),maleName(two),"Male Name for Item",msgs)
    check(femaleName(one),femaleName(two),"Female Name for Item",msgs)

proc bipedMatch(one,two:BipedObject): bool = result = itemSlot(one) == itemSlot(two)

proc check*(one,two:ACTI): seq[string] = simpleCheck(one,two)
proc check*(one,two:ALCH): seq[string] = simpleCheck(one,two)
proc check*(one,two:APPA): seq[string] = simpleCheck(one,two)
proc check*(one,two:ARMO): seq[string] = 
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
    for bp in bodyData(one):
        let twoBD = bodyData(two)
        let res = filter(twoBD,proc(b:BipedObject): bool = bipedMatch(bp,b))
        



proc `$`*(cd:RecordConflicts): string = 
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







    