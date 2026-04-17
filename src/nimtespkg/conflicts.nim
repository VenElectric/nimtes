import std/[tables,strformat,paths,files,dirs,options]
import util,tescfg,record
from macros import getCustomPragmaVal,hasCustomPragma
from strutils import replace,endsWith,indent

type

    RecordConflicts* = object
        id: string
        messages: seq[string]
    PluginData* = Table[string,seq[RecordConflicts]] # TAG (i.e. CELL),Conflicts
    CompareResult* = object
        masters: seq[string]
        records*: seq[string]
        plugin*: string
        checked_plugins: seq[string]
        conflicts: Table[string,PluginData] # Plugin,Conflicts

# make sure that plugins checked have record types of the base plugin


# change naming conventions for each of these
# CompareResult.conflicts leads to plugin data...which technically
# idk about what I changed it too. meh
# const BOOK_ART = Path("BookArt")
const DATA_FILES* = Path("Data Files")
const FONTS* = Path("Fonts")
const ICONS* = Path("Icons")
const MESHES* = Path("Meshes")
const MUSIC* = Path("Music")
const SOUNDS* = Path("Sound")
const SPLASH* = Path("Splash")
const TEXTURES* = Path("Textures")
const VIDEOS* = Path("Video")

func new_result*(plugin:string): CompareResult =
    result.masters = @[]
    result.plugin = plugin

func newPluginData*(): PluginData = initTable[string,seq[RecordConflicts]]()

proc add_master*(cv:var CompareResult,master:string) =
    cv.masters.add master

proc set_masters*(cv:var CompareResult,masters:seq[string]) = 
    cv.masters = masters

proc add_conflict*(cv: var CompareResult,key:string,pd:PluginData) =
    cv.conflicts[key] = pd

proc add*(pd:var PluginData,key:string,rc:RecordConflicts) = 
    if not hasKey(pd,key):
        pd[key] = @[]
    add(pd[key],rc)



func len*(rc:RecordConflicts): int = len(rc.messages)

func newConflict*(id:string,messages:seq[string]): RecordConflicts =
    result.id = id
    result.messages = messages

# messages
# X file does not exist
# X.attr changed from A to C
# X1 is missing from X but is in Y

func create_message*(what,initial,change:string): string = 
    fmt"{what} changed from {initial} to {change}"

proc add*(rc:var RecordConflicts,message:string) =
    rc.messages.add message

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

# proc verifyMasters*(r:TES3; c: TES3Cfg): seq[string] =
#     result = @[]
#     let mf = master_files(r)
#     if len(mf) > 0:
#         for m in mf:
#             let filePath = Path(path(c)) / DATA_FILES / Path(file_name(m))
#             if not fileExists(filePath): # return list of master ifles t
#                 result.add(file_name(m))



proc createMeshPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createMusicPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createTexturePath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createFontPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createIconPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
proc createSoundPath*(tesPath:Path,file:string): Path = tesPath / DATA_FILES / MESHES / Path(replace(file,'\\','/'))

proc checkPath*(p:Path): bool = fileExists(p)

proc check*[T:SomeFloat|SomeInteger|string|bool](l,r:Option[T],what:string,msgs:var seq[string])
proc check*[T:object](l,r:Option[T],what:string,msgs:var seq[string])


proc check*(l,r:SomeInteger,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add create_message(what,$l,$r)
proc check*(l,r:SomeFloat,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add create_message(what,$l,$r)
proc check*(l,r,what:string,msgs:var seq[string]) = 
    if l != r:
        msgs.add create_message(what,l,r)

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
            msgs.add create_message(what,get(l),"None")
        elif isNone(l) and isSome(r):
            msgs.add create_message(what,"None",get(r))
        elif isSome(l) and isSome(r):
            msgs.add create_message(what,get(l),get(r))

# update
proc check*[T:object](l,r:Option[T],what:string,msgs:var seq[string]) =
    if l != r:
        if isSome(l) and isNone(r):
            msgs.add create_message(what,get(l),"None")
        elif isNone(l) and isSome(r):
            msgs.add create_message(what,"None",get(r))
        elif isSome(l) and isSome(r):
            check(get(l),get(r),what,msgs)

proc check*[T:TES3Record](one,two:TES3Record):seq[string] =
    result = @[]
    for okey,ovalue in fieldPairs(one):
        for tkey,tvalue in fieldPairs(two):
            if okey == tkey:
                check(ovalue,tvalue,getCustomPragmaVal(ovalue,dtag),result)
                break


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







    