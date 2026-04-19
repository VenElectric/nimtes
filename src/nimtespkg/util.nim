import std/[unicode]


const NULLRUNE* = toRunes("\u0000")

const INDENTAMT* = 2


proc stripNull*(s:string):string = strip(s,true,true,NULLRUNE)



