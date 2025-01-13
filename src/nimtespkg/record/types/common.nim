type 
    TES3Flags*[T] = set[T]
    TES3Record* = object of RootObj
        size*: uint32
        flags*: TES3Flags[int8]
        dele*: bool = false