import std/options
import record

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


# proc readField*(s;dst: var WeatherChances;tags: var TagFields) =
#     let size = peek(tags).size
#     read(s,dst.clear)
#     read(s,dst.cloudy)
#     read(s,dst.foggy)
#     read(s,dst.overcast)
#     read(s,dst.rain)
#     read(s,dst.thunder)
#     read(s,dst.ash)
#     read(s,dst.blight)
#     if size == 10:
#         read(s,dst.snow)
#         read(s,dst.blizzard)
#     next(tags)

proc `$`*(r): string =
    result = "REGN"
    result.add `T$`(r)