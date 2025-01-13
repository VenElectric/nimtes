import ../[util,constants]
import common
import std/options
from ench import Enchantment

type 
    AlchemyData = object
        weight*: float32
        value*: uint32
        flags*: TES3Flags[int8]
    AlchemyRecord* {.tag("ALCH").} = ref object of TES3record
        id* {.tag(NAME).}: string
        model_name* {.tag(MODL).}: Option[string]
        icon_name* {.tag(TEXT).}: Option[string]
        script_name* {.tag(SCRI).}: Option[string]
        name* {.tag(FNAM).}: Option[string]
        data* {.tag(ALDT).}: Option[AlchemyData]
        enchantments* {.tag(ENAM).}: seq[Enchantment]