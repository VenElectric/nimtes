import std/[streams,strformat,macros,options]
import constants,util
import types/common

using
    s:Stream

proc readTag*(s): string = readStr(s,TAGSIZE)
proc peekTag*(s): string = peekStr(s,TAGSIZE)
proc skip*(s;pos:Natural) = setPosition(s,getPosition(s) + pos)

proc readSize*(s):int = int(readUint32(s))

proc checkTag*(a, b: string) = assert(a == b, fmt"Tag {a} does not match Tag {b}")
proc checkSize*(a, b: int) = assert(a == b,fmt"Size of {a} does not match Size of {b}")

proc consumeTag(s) = discard readTag(s)

proc filter_tags*(s): seq[tuple[start_pos:int,end_pos:int]] = 
    result = @[]
    while not s.atEnd():
        let start = getPosition(s)
        skip(s,4)
        let len = readUint32(s)
        skip(s,len + 8)
        result.add((start_pos:start,end_pos:getPosition(s)))

proc readField*(s;dst: var string)
proc readField*(s;dst: var uint8)
proc readField*(s;dst: var int8)
proc readField*(s;dst: var uint16)
proc readField*(s;dst: var uint32)
proc readField*(s;dst: var int32)
proc readField*(s;dst: var float32)
proc readField[T: object|tuple](s;dst: var T)
proc readField*[T](s;dst: var Option[T])
proc readField*[T:enum](s;dst: var set[T])
proc readField*(s;dst: var set[uint8])

proc readField*(s;dst: var string) =
    let sz = readSize(s)
    dst = stripEverything(readStr(s,sz))

proc readField*(s;dst: var uint8) =
    checkSize(readSize(s),SZ8)
    dst = readUint8(s)

proc readField*(s;dst: var int8) =
    checkSize(readSize(s),SZ8)
    dst = readInt8(s)

proc readField*(s;dst: var uint16) =
    checkSize(readSize(s),SZ16)
    dst = readUint16(s) 

proc readField*(s;dst: var uint32) =
    checkSize(readSize(s),SZ32)
    dst = readUint32(s)

proc readField*(s;dst: var int32) =
    checkSize(readSize(s),SZ32)
    dst = readInt32(s) 

proc readField*(s;dst: var float32) =
    checkSize(readSize(s),SZ32)
    dst = readFloat32(s)

proc readField*[T:enum](s;dst: var set[T]) = discard
proc readField*(s;dst: var set[uint8]) = discard
    

# record
#   fields
#       Type: string,uint8,uint16,uint32,int8,int32,float32,object
# read a field
# read the tag/discard it
# read the size/discard it
# read the value 
# assign the value to the result

proc createObjectReadFields(strm,dst,typeNode,typeSym:NimNode) = 
    case typeNode.kind:
        of nnkEmpty: discard
        of nnkRecList,nnkTupleTy: discard
        of nnkIdentDefs: discard
        of nnkRecCase: discard
        of nnkOfBranch,nnkElse: discard
        of nnkObjectTy: discard
        else: discard

macro readObjectImpl[T: object|tuple](s;dst: var T) = 
    let tsym = getTypeInst(dst)
    result = newStmtList()
    if hasCustomPragma(dst,tag):
        discard
    else:
        discard


proc readField[T: object|tuple](s;dst: var T) = 
    discard readSize(s)
    readObjectImpl(s,dst)

proc readField*[T](s;dst: var Option[T]) = 
    discard readSize(s)
    when T is ref: 
        dst = some(new(T))
    else:
        dst = some(default(T))
    readField(s,dst.get)


proc tagCaseStmt(dstNode,s,kind,impl: NimNode) =
    let caseStmt = newTree(nnkCaseStmt,kind)
    let fields = impl[2]
    for field in fields:
        let fSym = field[0]
        let pTag = getCustomPragmaVal(field,tag)
        let ofBranch = newTree(nnkOfBranch,newLit(pTag))
        ofBranch.add quote do:
            consumeTag(`s`)
            readField(`s`,`impl`.`fSym`)
    caseStmt.add(newTree(nnkElse,newNimNode(nnkBreakStmt)))
    dstNode.add(caseStmt)


macro readRecordImpl[T](s;record:var T) = 
    let typeSym = getTypeInst(record)
    let impl = getTypeImpl(typeSym)
    result = newStmtList()
    result.add quote do:
        `record`.size = readUint32(s)
        skip(s,SZ32)
        skip(s,SZ32)
        # `record`.flags = readFlags(s)
        var kind: string

        while true:
            kind = peekTag(s)
            tagCaseStmt(result,s,kind,impl)

proc recordProxy[T](s;record: var T) = readRecordImpl(s,record)
        

proc readRecord*[T](s;t:typedesc[T]): T = 
    var rec = new(t)
    recordProxy(s,rec)
    return rec
