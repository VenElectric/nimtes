import std/options
import record,util



type 
    LightFlags* = enum 
        LDyanmic = (0,"Dynamic"),
        LCanCarry = "Can Carry",
        LNegative = "Negative",
        LFlicker = "Flicker",
        LFire = "Fire",
        LOffDefault = "Off by Default",
        LFlickerSlow = "Flicker Slow",
        LPulse = "Pulse",
        LPulseSlow = "Pulse Slow"
    LightData* = ref object of DataField
        weight: float32
        value: uint32
        time: int32
        radius: uint32
        color: RGBA
        flags: uint32
    LIGH* = ref object of TES3Record
        NAME: string
        MODL: Option[string]
        FNAM: Option[string]
        ITEX: Option[string]
        LHDT: LightData
        SNAM: Option[string]
        SCRI: Option[string]

using
    r:LIGH

const FTDynamic = flag_tup(0x0001,LDyanmic)
const FTCancarry = flag_tup(0x0002,LCanCarry)
const FTNegative = flag_tup(0x0004,LNegative)
const FTFlicker = flag_tup(0x0008,LFlicker)
const FTFire = flag_tup(0x0010,LFire)
const FTOffDefault = flag_tup(0x0020,LOffDefault)
const FTFlickerSlow = flag_tup(0x0040,LFlickerSlow)
const FTPulse = flag_tup(0x0080,LPulse)
const FTPulseSlow = flag_tup(0x0100,LPulseSlow)

let lightFlagLookup = [FTDynamic,FTCancarry,FTNegative,FTFlicker,FTFire,FTOffDefault,FTFlickerSlow,FTPulse,FTPulseSlow]

func id*(r): string = r.NAME
func model_path*(r): Option[string] = r.MODL
func name*(r): Option[string] = r.FNAM
func icon_path*(r): Option[string] = r.ITEX
func data(r): LightData = r.LHDT
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func time*(r): int32 = data(r).time
func radius*(r): uint32 = data(r).radius
func color*(r): RGBA = data(r).color
proc light_flags*(r): set[LightFlags] =
    let flgs = data(r).flags
    for f in lightFlagLookup:
        let (check,incl) = f
        if has_flag(flgs,check):
            result.incl incl

func sound_path*(r): Option[string] = r.SNAM
func script_name*(r): Option[string] = r.SCRI

proc `$`*(r): string = 
    result = "LIGH"
    result.add `T$`(r)