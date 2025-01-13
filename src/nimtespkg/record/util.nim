import std/[unicode]
from strutils import strip

const NULLRUNE* = toRunes("\u0000")

type
     TagError* = object of AssertionDefect

proc stripEverything*(s: string): string =
     result = strutils.strip(unicode.strip(unicode.strip(s, true, true, NULLRUNE)))

template tag*(t:string) {.pragma.}

template skip*(amt:Natural) {.pragma.}

template data*() {.pragma.}

template strSize*(sz:int) {.pragma.}

template iterField*(rng: range) {.pragma.}