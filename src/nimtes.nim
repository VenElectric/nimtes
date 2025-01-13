# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import std/[macros,options,streams,json]
import nimtespkg/record/[read,util,constants]

type
   TES3Flags*[T] = set[T]
   TES3Record* = object of RootObj
        size*: uint32
        flags*: TES3Flags[int8]
        dele*: bool = false
   TestObj = ref object of TES3Record
      fielda: int
      fieldb: Option[string]
   ActivatorRecord* {.tag("ACTI").} = ref object of TES3Record
      id* {.tag(NAME).}: string
      model_name* {.tag(MODL).}: string
      name* {.tag(FNAM).}: Option[string]
      script_name* {.tag(SCRI).}: Option[string]

type
   Person = object
     name*: string
     age*: int
   Data = ref object of Rootobj
      person*: Person
      list*: seq[int]
# get the object itself
# get the object fields

# separate the object field name and field values into their own buckets

proc echoField(field:NimNode) =
   echo len(field)
   echo field[0].repr

proc objectEcho(n:NimNode) = 
   let fields = n[2]
   for field in fields:
      echoField(field)
         

macro testObject[T](n:T) = 
   let typeSym = getTypeInst(n)

   if typeSym.kind in {nnkTupleTy,nnkTupleConstr}:
      discard
   else:
      objectEcho(getTypeImpl(typeSym))

proc runTest(t:typedesc) = 
   let obj = new(t)
   testObject(obj[])

when isMainModule:
   
   let plugin = readPlugin("Morrowind.esm")

   let file = open("Morrowind.json",fmWrite)

   file.write(%*plugin)

  

