import std/[unicode]


const NULLRUNE* = toRunes("\u0000")

const INDENTAMT* = 2

proc hasFlag*(flags,value: uint32): bool = result = (value and (not flags)) == 0

proc stripNull*(s:string):string = strip(s,true,true,NULLRUNE)

template zsize*(sz:int) {.pragma.}
template dtag*(d:string) {.pragma.}



