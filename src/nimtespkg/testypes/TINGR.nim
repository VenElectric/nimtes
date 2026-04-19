import std/options
import record

type
    IngredientLevel* = tuple[effect:EffectIndex,skill:int32,attribute:int32]
    IngredientData* = ref object of DataField
        weight: float32
        value: uint32
        effects: array[4,int32]
        skills: array[4,int32]
        attrs: array[4,int32]
    INGR* = ref object of TES3Record
        NAME: string
        MODL: string
        FNAM: Option[string]
        IRDT: IngredientData
        SCRI: Option[string]
        ITEX: Option[string]

using
    r:INGR

func id*(r): string = r.NAME
func model_path*(r): string = r.MODL
func name*(r): Option[string] = r.FNAM
func data*(r): IngredientData = r.IRDT

func weight*(r): float32 = data(r).weight
func value*(r): uint32 = data(r).value
func effects*(r): array[4,EffectIndex] = to_effects(data(r).effects) 
func skills*(r): array[4,int32] = data(r).skills # this and attributes are sucky, because a "none" value can be 0 or -1, 
# while other records use -1 to mean no value.
func attrs*(r): array[4,int32] = data(r).attrs # ^^^^^^^

# cross lookup effect with MGEF for comparison. or not...idk
# do we even need this?
func ingredientLevelData*(r): array[4,IngredientLevel] = 
    let e = effects(r)
    let s = skills(r)
    let a = attrs(r)
    for idx in 0..3:
        result[idx] = (effect:e[idx],skill:s[idx],attribute:a[idx])

func scriptName*(r): Option[string] = r.SCRI
func iconPath*(r): Option[string] = r.ITEX

proc `$`*(r): string =
    result = "INGR"
    result.add `T$`(r)