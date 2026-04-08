import std/[tables,strformat,strutils,sequtils,paths,files,dirs]
import util,tescfg

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

func new_result*(plugin:string,records: seq[string],checked_plugins:seq[string]): CompareResult =
    result.masters = @[]
    result.plugin = plugin
    result.records = records
    result.checked_plugins = checked_plugins

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

func new_conflict*(id:string,messages:seq[string]): RecordConflicts =
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

proc get_plugin_files*(c:TES3Cfg): seq[string] = 
    let pluginPath = path(c) / DATA_FILES
    for k,p in walkDir(pluginPath):
        if k == pcFile:
            let plugin = string(extractFilename(p))
            if endsWith(plugin,".esp"):
                result.add plugin

proc get_master_files*(c:TES3Cfg): seq[string] =
    let pluginPath = path(c) / DATA_FILES
    for k,p in walkDir(pluginPath):
        if k == pcFile:
            let plugin = string(extractFilename(p))
            if endsWith(plugin,".esm"):
                result.add plugin

proc check_mesh_path*(c:TES3Cfg,file:string): bool =
    let p = path(c) / DATA_FILES / MESHES / Path(replace(file,'\\','/'))
    echo p
    result = fileExists(p)

proc check_music_path*(c:TES3Cfg,file:string): bool =
    let p = path(c) / DATA_FILES / MUSIC / Path(replace(file,'\\','/'))
    result = fileExists(p)

proc check_texture_path*(c:TES3Cfg,file:string): bool =
    let p = path(c) / DATA_FILES / TEXTURES / Path(replace(file,'\\','/'))
    result = fileExists(p)

proc check_font_path*(c:TES3Cfg,file:string): bool =
    let p = path(c) / DATA_FILES / FONTS / Path(replace(file,'\\','/'))
    result = fileExists(p)

proc check_icon_path*(c:TES3Cfg,file:string): bool =
    let p = path(c) / DATA_FILES / ICONS / Path(replace(file,'\\','/'))
    result = fileExists(p)

proc check_sound_path*(c:TES3Cfg,file:string): bool =
    let p = path(c) / DATA_FILES / SOUNDS / Path(replace(file,'\\','/'))
    result = fileExists(p)

proc `$`*(cd:RecordConflicts): string = 
    result = fmt"__{cd.id}__" & "\n"
    # if cd.is_conflict:
    #     result.add indent("CONFLICT",INDENTAMT) & "\n"
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

# Table[string,CompareData]
#       PLUGINNAME   , plugin name/id or name/message
# TOP LEVEL ALCH PLUGIN1
    # ids in plugin 1
    # ids in plugin 2
    # MODL
        # 



# Check one file
#   Check to ensure masters match and exist
#   Check to ensure

# missing master files
# collision 
#   pathgrid
#   landsacpe/interior

# TO DO
# esp file comparison
# data files comparison

# compare exterior/interior cell names. based on?
# maybe bring in master file that the esp file references and check that
# get a sense of file path structure, and confirm what other mods do with that?

# want to plot out how to compare things.
# i.e. we may also need a "base" i.e. master file to understand what things were originally
# and then we can say:
# dagoth gilvoth's nif path was:
# r\ashvampire03.nif 
# in Divine Dagoth's it is r\ashvampire03.nif  (which matches the master file)
# but was changed to:
# VD\ashvampire03.nif
# in The Tribe Unmourned
# the issue comes in when something was not in the master file?
# i.e. a new addition
# ABC.esp has creature X at
# VE\creax.nif
# but plugin XYZ 
# VC\creax.nif
# might want to use the ids to compare. i.e. DD.dagoth gilvoth.MODL ==  TTU.dagoth gilvoth.MODL
# instead of just relying on the file paths themselves
# but then also need a way to verify the file paths in pluginless plugins
# i.e. If Divine Dagoth didn't have ESP files, then need to compare those
# this is probably where we would rely on the master file I think...?

# what changed
# how it changed (deleted, updated)
# before and after (might just need to store this as str )
# where it changed?
# CELL
#   CELL NAME: Arrille Tradehouse
#       Persistent Child: Dagoth Ur
#       Before: None
#       After: Dagoth Ur
#       Kind: Addition

# markdown file
# ***CONFLICTS*** 
#   i.e. what has changed,how it changed
#   CELL -> item not in interior
#   CELL -> person removed
#   PGRD -> pathgrid altered
#   LAND -> vertices are different/conflict
#   CREA -> path for nif file is different (v/nif -> VD/nif)
#   WEAP -> weapon health altered from 10 -> 15

# get baseline of file paths in morrowind datafiles
# Morrowind.ini
# DataFiles
    # Textures
    # Splash
    # Music
    # Meshes
    # Fonts
# which base game (i.e. core and dlc) masters are in DataFiles
# Morrowind.esm/bsa
# Bloodmoon.esm/bsa
# Tribunal.esm/bsa

# for mod master (i.e. Tamriel Rebuilt)
# ??? not sure

# for plugin:
# two types of checks:
    # plugin validation
        # check masters (i.e. are masters listed in morrowind file directory?)
        # get sense of records (i.e list of CELL,ACTI,ETC...)
        # for each record, validate paths, validate item name 
    # conflict validation
        # check to see if other plugins change certain paths
        # check interior/exterior to confirm if anything is moved,added
        # check coordinate data. is anything overlapping? 
        # pathgrids etc..
        # etc... (each record will have different checks)






    