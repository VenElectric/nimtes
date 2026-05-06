import std/[xmltree,xmlparser,tables,strutils,streams,options]
from sequtils import filter
from algorithm import reversed
import nimtespkg/[reader,testypes]
type
   NINodeRead = ref object
      name: string
      children: seq[NINodeRead]
   NIVersion = tuple[major,minor,patch,inter:uint]

proc newVersion(a,b,c,d:uint): NIVersion = (major:a,minor:b,patch:c,inter:d)

proc toVersion*(v:string): NiVersion =
   let spl = split(v,"_")
   if len(spl) == 2:
      result = newVersion(parseUint(strip(spl[0],true,false,{'V'})),parseUint(spl[1]),0,0)
   else:
      result = newVersion(parseUint(strip(spl[0],true,false,{'V'})),parseUint(spl[1]),parseUint(spl[2]),parseUint(spl[3]))

const MORROVERS = newVersion(4,0,0,2)

proc add(n:var NINodeRead,c:NINodeRead) = n.children.add c

proc newNode(name:string): NINodeRead = 
   result = new NINodeRead
   result.name = name
   result.children = @[]

proc getFilter(objs:seq[XmlNode],parent:string): seq[XmlNode] =
   result = filter(objs,proc(x:XmlNode): bool = attr(x,"inherit") == parent)

proc recurseInheritPath(objs:seq[XmlNode],parent:var NINodeRead) =
   let nodes = getFilter(objs,parent.name)
   if len(nodes) > 0:
      for node in nodes:
         var child = newNode(attr(node,"name"))
         recurseInheritPath(objs,child)
         parent.add child

proc filterMorrowindNodes*(nodes:seq[XmlNode]): seq[XmlNode] = 
   for node in nodes:
      let versStr = attr(node,"versions")
      let untilStr = attr(node,"until")
      let sinceStr = attr(node,"since")
      if versStr == "" and untilStr == "" and sinceStr == "":
         result.add node
      elif versStr != "":
         let versions = split(versStr)
         for v in versions:
            if startsWith(v,"V"):
               let toV = toVersion(v)
               if toV == MORROVERS:
                  result.add node
                  break
      if untilStr != "":
         let versions = split(untilStr)
         for v in versions:
            if startsWith(v,"V"):
               let toV = toVersion(v)
               if MORROVERS <= toV:
                  result.add node
                  break
      if sinceStr != "":
         let toV = toVersion(sinceStr)
         if toV <= MORROVERS:
            result.add node

proc getMorrowindObjects*(root:XmlNode): seq[XmlNode] = 
   result = filterMorrowindNodes(findAll(root,"enum") & findAll(root,"bitfields") & findAll(root,"niobject") & findAll(root,"struct"))


proc getInheritPath(root:XmlNode): NINodeRead = 
   var objs = filterMorrowindNodes(findAll(root,"niobject"))
   result = newNode("NiObject")
   recurseInheritPath(objs,result)

proc recurseNINodeRead(r:NINodeRead,fp:File,nodes:var seq[string]) =
   nodes.add(r.name)
   if len(r.children) > 0:
      for c in r.children:
         recurseNINodeRead(c,fp,nodes)
         discard nodes.pop()
   else:
      for n in reversed(nodes):
         write(fp,n & "\n")
      write(fp,"********\n")

proc recurseNINodeRead(r:NINodeRead,fp:File) = 
   var root: seq[string] = @[]
   recurseNINodeRead(r,fp,root)

proc writeNITypes(r:NINodeRead,fp:File) = 
   if len(r.children) > 0:
      write(fp,"*******" & r.name & "******\n")
      for c in r.children:
         write(fp,c.name & "\n")
      for c in r.children:
         writeNITypes(c,fp)

proc writeInheritLists(r:NINodeRead) =
   let fp = open("MorrowindNifObjects.txt",fmWrite)
   defer: close(fp)
   writeNITypes(r,fp)

proc writeInheritTrees(r:NINodeRead) = 
   let fp = open("MorrowindNifTree.txt",fmWrite)
   defer: close(fp)
   recurseNINodeRead(r,fp)

const OtherChars = {'_','.'}

proc readUntilAscii*(s:Stream) = 
   while not isAlphaNumeric(peekChar(s)) and peekChar(s) notin OtherChars and not atEnd(s):
      discard readChar(s)

proc readUntilNotAscii*(s:Stream):string = 
   while (isAlphaNumeric(peekChar(s)) or peekChar(s) in OtherChars) and not atEnd(s):
      result.add readChar(s)


var y = 10

when defined(CHANGE_Y):
   y = 50
      
when isMainModule:
   echo y