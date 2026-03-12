import unicode as uni
import strutils as stru

const NULLRUNE* = toRunes("\u0000")

type
     TagError* = object of AssertionDefect

proc stripEverything*(s: string): string =
     result = stru.strip(uni.strip(uni.strip(s, true, true, NULLRUNE)))



# struct can be read by readData
# struct contains a string with 
# AI records (more custom reading)
# extra bits/alignment for struct. i.e. ENDT for enchantment
# skip bit in middle of struct
# skip parent struct and use child struct instead I.E. aidata
# this is a "size" value (for )

template tag*(t:string) {.pragma.}

template skip*(amt:Natural) {.pragma.}

