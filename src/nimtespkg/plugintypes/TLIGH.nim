import std/options
import record



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

const FTDynamic: (uint32,LightFlags) = (0x0001,LDyanmic)
const FTCancarry: (uint32,LightFlags) = (0x0002,LCanCarry)
const FTNegative: (uint32,LightFlags) = (0x0004,LNegative)
const FTFlicker: (uint32,LightFlags) = (0x0008,LFlicker)
const FTFire: (uint32,LightFlags) = (0x0010,LFire)
const FTOffDefault: (uint32,LightFlags) = (0x0020,LOffDefault)
const FTFlickerSlow: (uint32,LightFlags) = (0x0040,LFlickerSlow)
const FTPulse: (uint32,LightFlags) = (0x0080,LPulse)
const FTPulseSlow: (uint32,LightFlags) = (0x0100,LPulseSlow)

let lightFlagLookup = [FTDynamic,FTCancarry,FTNegative,FTFlicker,FTFire,FTOffDefault,FTFlickerSlow,FTPulse,FTPulseSlow]

func id*(r): string = r.NAME
func model_path*(r): Option[string] = r.MODL
func name*(r): Option[string] = r.FNAM
func iconPath*(r): Option[string] = r.ITEX
func data(r): LightData = r.LHDT
func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func time*(r): int32 = data(r).time
func radius*(r): uint32 = data(r).radius
func color*(r): RGBA = data(r).color
proc lightFlags*(r): set[LightFlags] =
    let flgs = data(r).flags
    for f in lightFlagLookup:
        let (check,incl) = f
        if hasFlag(flgs,check):
            result.incl incl

func soundPath*(r): Option[string] = r.SNAM
func scriptName*(r): Option[string] = r.SCRI

proc `$`*(r): string = 
    result = "LIGH"
    result.add `T$`(r)