import nimtespkg/TPGRD
import std/streams

when isMainModule:
    var s = openFileStream("files/Morrowind.esm")

    var regns = readAllPGRD(s)

    echo $regns[0]
