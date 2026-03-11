import std/[streams, strformat, macros, options, tables]
import constants

using
    s: Stream

proc readTag*(s): string = readStr(s, TAGSIZE)
proc peekTag*(s): string = peekStr(s, TAGSIZE)
proc skip*(s; pos: Natural) = setPosition(s, getPosition(s) + pos)

proc readSize*(s): uint32 = readUint32(s)


proc checkSize*(a, b: int) = assert(a == b,
        fmt"Size of {a} does not match Size of {b}")

proc consumeTag*(s) = discard readTag(s)

proc filter_tags*(s): seq[tuple[start_pos: int; end_pos: int]] =
    result = @[]
    while not s.atEnd():
        let start = getPosition(s)
        skip(s, 4)
        let len = readUint32(s)
        skip(s, len + 8)
        result.add((start_pos: start, end_pos: getPosition(s)))

proc readField(s; dst: var int8)
proc readField(s; dst: var int16)
proc readField(s; dst: var int32)
proc readField(s; dst: var int64)
proc readField(s; dst: var uint8)
proc readField(s; dst: var uint16)
proc readField(s; dst: var uint32)
proc readField(s; dst: var uint64)
proc readField(s; dst: var float32)
proc readField(s; dst: var float64)
proc readField(s; dst: var string)
proc readField[T](s; dst: var Option[T])
proc readField[S, T](s; dst: var array[S, T])
proc readField[T](s; dst: var seq[T])
proc readField[T: object|tuple](s; dst: var T)

proc readField(s; dst: var int8) =
    dst = s.readInt8()
proc readField(s; dst: var int16) =
    dst = s.readInt16()
proc readField(s; dst: var int32) =
    dst = s.readInt32()
proc readField(s; dst: var int64) =
    dst = s.readInt64()
proc readField(s; dst: var uint8) =
    dst = s.readUint8()
proc readField(s; dst: var uint16) =
    dst = s.readUint16()
proc readField(s; dst: var uint32) =
    dst = s.readUint32()
proc readField(s; dst: var uint64) =
    dst = s.readUint64()
proc readField(s; dst: var float32) =
    dst = s.readFloat32()
proc readField(s; dst: var float64) =
    dst = s.readFloat64()
proc readField(s; dst: var string) =
    let size = readSize(s)
    dst = s.readStr(int(size))
proc readField[T](s; dst: var Option[T]) =
    when T is ref:
        dst = some(new(T))
    else:
        dst = some(default(T))
    readField(s, dst.get)
# proc readField[T](s;dst: var tuple[T,T,T]) = discard
proc readField[T](s; dst: var seq[T]) = discard

proc readField[S, T](s; dst: var array[S, T]) =
    for i in countup(len(dst)-1):
        readField(s, dst[i])


proc foldObject(s; dst, typeNode, tmpSym: NimNode) =
    case typeNode.kind
    of nnkEmpty:
        discard
    of nnkRecList, nnkTupleTy:
        for it in typeNode:
            foldObject(s, dst, it, tmpSym)

    of nnkIdentDefs:
        typeNode.expectLen 3
        let fieldSym = typeNode[0]
        let fieldType = typeNode[1]
        dst.add quote do:
            readField(`s`, `tmpSym`.`fieldSym`)

    of nnkRecCase:
        let kindSym = typeNode[0][0]
        let kindNameLit = newLit(kindSym.strVal)
        let kindPathLit = newLit("." & kindSym.strVal)
        let kindType = typeNode[0][1]
        let kindOffsetLit = newLit(uint(getOffset(kindSym)))

        dst.add quote do:
            var kindTmp: `kindType`
            readField(`s`, kindTmp)
            `tmpSym`.`kindSym` = kindTmp
        dst.add nnkCaseStmt.newTree(nnkDotExpr.newTree(tmpSym, kindSym))
        for i in 1 ..< typeNode.len:
            foldObject(s, dst, typeNode[i], tmpSym)

    of nnkOfBranch, nnkElse:
        let ofBranch = newNimNode(typeNode.kind)
        for i in 0 ..< typeNode.len-1:
            ofBranch.add copyNimTree(typeNode[i])
        let dstInner = newNimNode(nnkStmtListExpr)
        foldObject(s, dstInner, typeNode[^1], tmpSym)

    of nnkObjectTy:
        typeNode[0].expectKind nnkEmpty
        typeNode[1].expectKind {nnkEmpty, nnkOfInherit}
        if typeNode[1].kind == nnkOfInherit:
            let base = typeNode[1][0]
            var impl = getTypeImpl(base)
            while impl.kind in {nnkRefTy, nnkPtrTy}:
                impl = getTypeImpl(impl[0])
                foldObject(s, dst, impl, tmpSym)
        let body = typeNode[2]
        foldObject(s, dst, body, tmpSym)
    else:
        error("unhandled kind: " & $typeNode.kind, typeNode)

macro readObjectImpl[T](s; dst: var T) =
    let typeSym = getTypeInst(dst)
    result = newStmtList()
    if typeSym.kind in {nnkTupleTy, nnkTupleConstr}:
        foldObject(s, result, typeSym, dst)
    else:
        foldObject(s, result, typeSym.getTypeImpl, dst)

# reading objects
# difference between a record and say a data attribute


proc readField[T: object|tuple](s; dst: var T) =
    readObjectImpl(s, dst)

type
    TES3Record[T: object] = object
        size*: uint32
        flags*: uint32
        data*: T
    ActivatorRecord = object
        id*: string
        model_name*: Option[string]
        full_name*: Option[string]
        script_name*: Option[string]

proc readRecord*[T](s; dst: typedesc[T]): TES3Record[T] =
    result = default(TES3Record)
    result.data = default(T)
    consumeTag(s)
    result.size = readSize(s)
    skip(s, 4)
    result.flags = readUint32()
    # readField needs to skip over the preamble fields
    # might be easier to include this in readObjectImpl?
    # or make the preamble fields their own object that is implanted into Records
    readField(s, result.data)

# need to pass in a typedesc with the corresponding tag
# this seems to be overdoing it.
# If we directly use the object, we can then easily use that
# rather than trying to rig TES3 -> dict -> object

