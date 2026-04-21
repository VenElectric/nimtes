
import std/[streams,options]
import nimtespkg/[testypes,reader,util]

when isMainModule:
  
   var m = newFileStream("files/Morrowind.esm")
   # var outFile = open("MorrowindElmussa.txt",fmWrite)
   # const elmussa = "Caldera, Elmussa Damori's House"
   
   let cells = readAllRecordofType(m,CELL)

   echo $cells[0]
   
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
