import read
from streams import Stream
type
    TES3Record[T: object] = object
        size*: uint32
        flags*: uint32
        data*: T

proc readRecord*[T](s: Stream, dst: typedesc[T]): TES3Record[T] =
    result = default(TES3Record)
    result.data = default(T)
    consumeTag(s)
    result.size = readSize(s)
    skip(s, 4)
    readField(s,result.flags)
    readField(s,result.data)