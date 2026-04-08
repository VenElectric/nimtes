import std/[unicode,options]

const NULLRUNE* = toRunes("\u0000")

const INDENTAMT* = 2

proc has_flag*(flags,value: uint32): bool = result = (value and (not flags)) == 0

proc stripNull*(s:string):string = strip(s,true,true,NULLRUNE)

func unwrap_str*(s:Option[string]): string = 
    result = stripNull(get(s,""))

template zsize*(sz:int) {.pragma.}
template data_tag*(d:string) {.pragma.}



