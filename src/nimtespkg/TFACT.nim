from std/sequtils import apply
from std/strutils import indent
import record, util


type
    RankAttrMods* = tuple[rank_name: string, attribute: AttributeIndex,
            modifier: uint32]
    NamedRankData* = tuple[name: string, data: RankData]
    RankData* = object
        attribute_mods: array[2, uint32]
        prim_skill_mod: uint32
        fav_skill_mod: uint32
        fact_react_mod: uint32
    FactionData* = ref object of DataField
        attributes: array[2, uint32]
        rank_data: array[10, RankData]
        skills: array[7, int32]
        flags: uint32
    ReactionData* = object
        ANAM: string
        INTV: int32
    FACT* = ref object of TES3Record
        NAME: string
        FNAM: string
        RNAM: seq[string] # could potentially be array[10,string], but size of str is unknown before runtime
        FADT: FactionData
        ANAM: TagList[ReactionData]

using
    r: FACT

func id*(r): string = stripNull(r.NAME)
func name*(r): string = stripNull(r.FNAM)
func rank_names*(r): seq[string] =
    result = r.RNAM
    apply(result, stripNull)
func faction_data*(r): FactionData = r.FADT
proc faction_attrs*(r): array[2, AttributeIndex] = to_attributes(faction_data(r).attributes)
func faction_skills*(r): array[7, SkillIndex] = to_skills(faction_data(r).skills)
func rank_data*(r): array[10, NamedRankData] =
    let names = rank_names(r)
    let rd = faction_data(r).rank_data
    assert(len(names) <= 10, "Rank names in practice should have 10 or less records. This one doesn't: " &
            id(r))
    for idx, rn in names:
        result[idx] = (name: rn, data: rd[idx])
func get_rank_data*(r; rank: range[0..9]): RankData = faction_data(r).rank_data[rank]
proc attr_mods*(r; nrd: NamedRankData): array[2, RankAttrMods] =
    let attrs = faction_attrs(r)
    for idx, a in pairs(nrd.data.attribute_mods):
        result[idx] = (rank_name: nrd.name, attribute: attrs[idx], modifier: a)
proc all_attr_mods*(r): array[10, array[2, RankAttrMods]] =
    for idx, rd in pairs(rank_data(r)):
        result[idx] = attr_mods(r, rd)

proc stripAnam(r: ReactionData): ReactionData =
    result.ANAM = stripNull(r.ANAM)
    result.INTV = r.INTV
func reaction_data*(r): seq[ReactionData] =
    result = seq[ReactionData](r.ANAM)
    apply(result, stripAnam)
func faction_name*(r: ReactionData): string = r.ANAM
func reaction_value*(r: ReactionData): int32 = r.INTV
# attribute_mods: array[2, uint32]
#         prim_skill_mod: uint32
#         fav_skill_mod: uint32
#         fact_react_mod: uint32
proc `$`*(r: RankData): string =
    result.add indent("attribute_mods:" & $r.attribute_mods, INDENT)
    result.add indent("prim_skill_mod:" & $r.prim_skill_Mod, INDENT)
    result.add indent("fav_skill_mod:" & $r.fav_skill_mod, INDENT)
    result.add indent("fact_react_mod:" & $r.fact_react_mod, INDENT)

proc `$`*(r): string =
    result = "FACT"
    result.add `T$`(r)
