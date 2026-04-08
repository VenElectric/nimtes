import std/[streams, options,paths,sugar,sequtils,tables,colors]
import nimtespkg/[read,TCELL,conflicts,TTES3,tescfg]

proc filter_cell(tp:TagPos): bool = tp.name == "CELL"

when isMainModule:
    let tcfg = tes3Load()
    let pg = "files/Barabus' fireplaces 2 - Vanilla Chimneys v2.2.ESP"
    let pgr = "files/Morrowind Rebirth [Main].ESP"
    var b = newFileStream(pg)
    var r = newFileStream(pgr)
    let bTags = get_record_offsets(b)
    let rTags = get_record_offsets(r)
    var barCells:seq[CELL] = @[]
    
    let bCellTags = filter(bTags,filter_cell)

    let conflictFile = open("conflicts.txt",fmWrite)
    
    setPosition(b,0)
    let head = readRecord(b,TES3)
    let missingMstrs = verify_masters(head,tcfg)
    echo "Missing Masters: ",$missingMstrs
    let mstrs = map(master_files(head),proc(m:MasterFile): string = file_name(m))
    var cmpRes = new_result(pg,@[],@[pgr])
    set_masters(cmpRes,mstrs)
    
    for t in items(bCellTags):
        setPosition(b,t.pos - 8)
        barCells.add readRecord(b,CELL)

    let rCellTags = filter(rTags,filter_cell)

    var cellMap = initTable[string,tuple[main:CELL,cmp:CELL]]()

    
    for t in items(rCellTags):
        setPosition(r,t.pos-8)
        let record = readRecord(r,CELL)
        for cell in barCells:
            if cell_name(cell) == cell_name(record):
                cellMap[cell_name(cell)] = (main:cell,cmp:record)
    
    var pgData:PluginData = initTable[string,seq[RecordConflicts]]()
    pgData["CELL"] = @[]
    for k,v in pairs(cellMap):
        var msgs:seq[string] = @[]
        let (main,cmp) = v
        let mData = data(main)
        let cData = data(cmp)
        if flags(main) != flags(cmp):
            msgs.add create_message("Flags",$flags(main),$flags(cmp))

        let mAmbi = ambient_light(main)
        let cAmbi = ambient_light(cmp)

        if isSome(mAmbi) and isSome(cAmbi):
            let ambim = get(mAmbi)
            let ambic = get(cAmbi)
            if ambient_color(ambim) != ambient_color(ambic):
                msgs.add create_message("Ambient Color",$ambient_color(ambim),$ambient_color(ambic))
            if sun_color(ambim) != sun_color(ambic):
                msgs.add create_message("Sun Color",$sun_color(ambim),$sun_color(ambic))
            if fog_color(ambim) != fog_color(ambic):
                msgs.add create_message("Fog Color",$fog_color(ambim),$fog_color(ambic))
            if fog_density(ambim) != fog_density(ambic):
                msgs.add create_message("Fog Density",$fog_density(ambim),$fog_density(ambic))
        elif (isSome(mAmbi) and isNone(cAmbi)):
            msgs.add create_message("Ambient Light","Some","None")
        elif (isNone(mAmbi) and isSome(cAmbi)):
            msgs.add create_message("Ambient Light","None","Some")
        
        if len(msgs) > 0:
            add(pgData,"CELL",new_conflict(k,msgs))
    
    let cellCon = pgData["CELL"]
    echo len(cellCon)
    conflictFile.write $cellCon
    
    

    close(b)
    close(r)
    close(conflictFile)
    

