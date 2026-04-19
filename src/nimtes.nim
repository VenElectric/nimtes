
import nimtespkg/testypes

when isMainModule:
   type 
      MyObject = object

   var x = MyObject()
   echo $MyObject
   
