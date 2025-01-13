import common
import ../[util,constants]

type
    EnchantmentKind* = enum
        CastOnce = "Cast Once"
        CastOnStrike = "Cast on Strike"
        CastWhenUsed = "Cast When Used"
        ConstantEffect = "Constant Effect"

type
    Enchantment* = object
        effectIdx*: uint16
        skill*: int8
        attribute*: int8
        effectRange*: uint32
        area*: uint32
        duration*: uint32
        magnitudeMin*: uint32
        magnitudeMax*: uint32
    EnchantmentData = object
        kind*: uint32
        cost*: uint32
        charge*: uint32
        flags*: EnchantmentKind # can you have more than one ench kind on an enchantment?
    EnchantmentRecord* = ref object of TES3Record
        id* {.tag(NAME).}: string
        data* {.tag(ENDT).}: EnchantmentData
        enchantments*{.tag(ENAM).}: seq[Enchantment] = @[]