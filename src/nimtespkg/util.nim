import std/[unicode,options,paths]

type
    CheckKind* = enum 
        CHMesh,
        CHMusic,
        CHTexture,
        CHFont,
        CHIcon,
        CHSound

const NULLRUNE* = toRunes("\u0000")

const INDENTAMT* = 2

proc has_flag*(flags,value: uint32): bool = result = (value and (not flags)) == 0

proc stripNull*(s:string):string = strip(s,true,true,NULLRUNE)

proc bothSome*[T](l,r:Option[T]): bool = isSome(l) and isSome(r)

converter toPath*(v:string): Path = Path(v)

template zsize*(sz:int) {.pragma.}
template dtag*(d:string) {.pragma.}
template check*(c:CheckKind) {.pragma.}



