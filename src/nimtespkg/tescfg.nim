import std/[json,paths]
type 
    TES3Cfg* = object
        morrowind_path: string
    
proc tes3Load*(): TES3Cfg =
    result = to(parseFile("tescfg.json"),TES3Cfg)

func path*(t:TES3Cfg): Path = Path(t.morrowind_path)