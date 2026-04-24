import std/[xmltree,xmlparser,tables,strutils,streams]
from sequtils import filter
from algorithm import reversed

type
   NINode = ref object
      name: string
      children: seq[NINode]
   NIVersion = tuple[major,minor,patch,inter:uint]

proc newVersion(a,b,c,d:uint): NIVersion = (major:a,minor:b,patch:c,inter:d)

proc toVersion*(v:string): NiVersion =
   let spl = split(v,"_")
   if len(spl) == 2:
      result = newVersion(parseUint(strip(spl[0],true,false,{'V'})),parseUint(spl[1]),0,0)
   else:
      result = newVersion(parseUint(strip(spl[0],true,false,{'V'})),parseUint(spl[1]),parseUint(spl[2]),parseUint(spl[3]))

const MORROVERS = newVersion(4,0,0,2)

proc add(n:var NINode,c:NINode) = n.children.add c

proc newNode(name:string): NINode = 
   result = new NINode
   result.name = name
   result.children = @[]

# NiObject
# NiParticleModifier
# NiGravity
proc getFilter(objs:seq[XmlNode],parent:string): seq[XmlNode] =
   result = filter(objs,proc(x:XmlNode): bool = attr(x,"inherit") == parent)

proc recurseInheritPath(objs:seq[XmlNode],parent:var NINode) =
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


proc getInheritPath(root:XmlNode): NINode = 
   var objs = filterMorrowindNodes(findAll(root,"niobject"))
   result = newNode("NiObject")
   recurseInheritPath(objs,result)
      


# NiObject
   # Ni3dsColorAnimator
   # bhkRefObject
      # bhkSerializable
         # bhkWorldObject
            # bhkPhantom
               # bhkAabbPhantom
   # NiParticleModifier
      # NiGravity

# NiObject
   # NiParticleModifier
      # NiGravity
   # ********
   # NiParticleModifier
      # NiParticleBomb
   # ********
   # NiParticleModifier
      # NiParticleColorModifier
   # ********
   # NiParticleModifier
      # NiParticleGrowFade
   # ********
   # NiParticleModifier
      # NiParticleMeshModifier
   # ********
   # NiParticleModifier
      # NiParticleRotation
   # ********
   # NiParticleModifier
      # NiParticleCollider
         # NiPlanarCollider

proc recurseNINode(r:NINode,fp:File,nodes:var seq[string]) =
   nodes.add(r.name)
   if len(r.children) > 0:
      for c in r.children:
         recurseNINode(c,fp,nodes)
         discard nodes.pop()
   else:
      for n in reversed(nodes):
         write(fp,n & "\n")
      write(fp,"********\n")

proc recurseNINode(r:NINode,fp:File) = 
   var root: seq[string] = @[]
   recurseNINode(r,fp,root)

proc writeNITypes(r:NINode,fp:File) = 
   if len(r.children) > 0:
      write(fp,"*******" & r.name & "******\n")
      for c in r.children:
         write(fp,c.name & "\n")
      for c in r.children:
         writeNITypes(c,fp)

proc writeInheritLists(r:NINode) =
   let fp = open("MorrowindNifObjects.txt",fmWrite)
   defer: close(fp)
   writeNITypes(r,fp)

proc writeInheritTrees(r:NINode) = 
   let fp = open("MorrowindNifTree.txt",fmWrite)
   defer: close(fp)
   recurseNINode(r,fp)

const OtherChars = {'_','.'}

proc readUntilAscii*(s:Stream) = 
   while not isAlphaNumeric(peekChar(s)) and peekChar(s) notin OtherChars and not atEnd(s):
      discard readChar(s)

proc readUntilNotAscii*(s:Stream):string = 
   while (isAlphaNumeric(peekChar(s)) or peekChar(s) in OtherChars) and not atEnd(s):
      result.add readChar(s)

when isMainModule:
   let s = newFileStream("Morrowind/Data Files/Meshes/f/Furn_rug_big_04.nif")

   
   while not atEnd(s):
      readUntilAscii(s)
      let str = readUntilNotAscii(s)
      if len(str) > 3:
         echo str
      
   


         
   

