import std/[tables,parsecfg]
from lexbase import NewLines
from streams import newFileStream

proc readMorrowindIni*(iniPath:string): Config = 
    result = newConfig()
    var cfg = CfgParser()
    open(cfg,newFileStream(iniPath),"Morrowind.ini")
    var evt = next(cfg)
    var currSection:string
    while evt.kind != cfgEof:
        case evt.kind:
        of cfgSectionStart:
            currSection = evt.section
            result[currSection] = newOrderedTable[string,string]()
        of cfgKeyValuePair: 
            var tab = result[currSection]
            tab[evt.key] = evt.value
            result[currSection] = tab
        of cfgOption:
            var tab = result[currSection]
            tab["--" & evt.key] = evt.value
            result[currSection] = tab
        of cfgError:
            let col = getColumn(cfg) + 3
            dec(cfg.bufpos,col)
            while cfg.buf[cfg.bufpos] notin Newlines:
                dec(cfg.bufpos)
            inc(cfg.bufpos)
            var key:string
            while cfg.buf[cfg.bufpos] != '=':
                key.add cfg.buf[cfg.bufpos]
                inc(cfg.bufpos)
            var tab = result[currSection]
            tab[key] = ""
            result[currSection] = tab
            inc(cfg.bufpos)
        else:
            discard # cfgeof unreachable
        evt = next(cfg)
