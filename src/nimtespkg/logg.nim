import std/terminal

proc debug*(message:string) = 
    styledEcho "[",bgBlue,"DEBUG" ,resetStyle,"] ", message
proc info*(message:string) = 
    styledEcho "[",bgWhite,fgBlack,"[INFO]",resetStyle,"] " , message
proc warn*(message:string) = 
    styledEcho "[",bgYellow,"WARN" ,resetStyle, "] ",message
proc crit*(message:string) = 
    styledEcho "[",bgRed,"ERROR" ,resetStyle,"] " , message