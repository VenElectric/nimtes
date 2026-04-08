import std/options
import record,util

type
    WeatherChances* = object
        clear*:uint8
        cloudy*:uint8
        foggy*:uint8
        overcast*:uint8
        rain*:uint8
        thunder*:uint8
        ash*:uint8
        blight*:uint8
        snow*:uint8 = 0
        blizzard*:uint8 = 0
    SoundChance* = ref object of DataField
        sound_name{.zsize(32).}: string
        chance:uint8
    REGN* = ref object of TES3Record
        NAME: string
        FNAM: string
        WEAT: WeatherChances
        BNAM: Option[string]
        CNAM: RGBA
        SNAM: seq[SoundChance]

using
    r:REGN

proc `$`*(r): string =
    result = "REGN"
    result.add `T$`(r)