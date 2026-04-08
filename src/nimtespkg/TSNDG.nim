import std/options
import record,util

type
    SoundKind* = enum
        LeftFoot = (0,"Left Foot"),
        RightFoot = "Right Foot",
        SwimLeft = "Swim Left",
        SwimRight = "Swim Right",
        Moan,
        Roar,
        Scream,
        Land
    SNDG* = ref object of TES3Record
        NAME: string
        DATA: uint32
        CNAM: Option[string]
        SNAM: Option[string]

using 
    r:SNDG

func id*(r): string = r.NAME
proc kind*(r): SoundKind =
    let k = r.DATA
    assert(k < 8,"Sound type value not valid: " & $k)
    SoundKind(k)

func creature_name*(r): Option[string] = r.CNAM
func sound_id*(r): Option[string] = r.SNAM

proc `$`*(r): string =
    result = "SNDG"
    result.add `T$`(r)