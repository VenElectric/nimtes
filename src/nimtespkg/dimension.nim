# calculate the space of an interior cell
# need NIF properties for this I think
# i.e. some cell walls are basically the floor, wall, and ceiling
# we have the central point at the floor, but no dimensions
# need length and width of the floor/ceiling, the height to the ceiling (wall)
# and then use that accumulatively to determine the dimensions of the space. 

# calculate if landscapes overlap each other/clipping
# calculate if structures are clipping/overlap
# ensure that npc/creatures are in visible space
# calculate if pathgrid goes into a wall
# calculate if object is not in visible space
# for interiors, use the dimensions calculated:
    # for pathgrid, ensure that any point is within dimenions calculated 
    # distance between pathgrid point and any interior plane
    # find the closest plane and then calculate point from that.
    # and the same for objects, etc. 
    # will need the dimensions for objects to ensure they are not clipping with another
    # object or the interior dimensions
    # so need object dimensions + interior dimensions
# for exteriors, determine any overlap between structures or landscapes
    # i.e. is ghostgate hidden in a landscape so that you can't access a door?
    # you can visually see a landscape clipping, but those points may not overlap directly in what is 
    # available. 
    # we could start by seeing if any points are under or above an existing landscape.
    # but do landscapes overwrite when they are loaded later?
    # Or do they duplicate? 
    # or does duplication only happen when you have landscapes/structures with different names
    # in the same place? or both?

type
    Vector3*[T:SomeInteger|SomeFloat|byte] = object
        x,y,z:T
    Vector4*[T:SomeInteger|SomeFloat|byte] = object 
        x,y,z,w:T
    Quaternion*[T:SomeInteger|SomeFloat|byte] = object
        w,x,y,z:T
    Matrix*[R,C:Natural,T:SomeInteger|SomeFloat|byte] = array[R,array[C,T]]


