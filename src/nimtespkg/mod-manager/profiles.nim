import std/[paths,appdirs,dirs]

type
    ModProfile* = object
        name:string
        path:Path
        

const ProfilePath = Path("profiles")

proc createProfilePath(name:string): Path = getDataDir() / ProfilePath / Path(name)

proc createProfile*(name:string) = 
    # normalize name...remove spaces etc....
    var p = createProfilePath(name)
    normalizePath(p)
    discard existsOrCreateDir(p)
    # save profile identifier and path

proc addModToProfile*(toAdd:string) = discard


