
import std/[streams,options]
import nimtespkg/[testypes,reader,util]

when isMainModule:
   var s = newFileStream("files/Barabus' fireplaces 2 - Vanilla Chimneys v2.2.ESP")
   var r = newFileStream("files/Morrowind Rebirth [Main].ESP")
   var m = newFileStream("files/Morrowind.esm")
   var outFile = open("MorrowindElmussa.txt",fmWrite)
   const elmussa = "Caldera, Elmussa Damori's House"
   
   let cells = readAllRecordofType(m,CELL)

   for cell in cells:
      let cellNm = name(cell)
      if isSome(cellNm):
         if stripNull(get(cellNm)) == elmussa:
            write(outFile,$cell)
            break
   

   

   close(s)
   close(outFile)
   close(r)
   close(m)
   
# FRMR:165694
#       NAME:furn_de_rug_big_04
#       XSCL:1.3800001
#       DODT:[
#       ]
      
#       DATA:
#         posx:650.989
#         posy:-14.896167
#         posz:381.18677
#         rotx:0.0
#         roty:0.0
#         rotz:0.0},
