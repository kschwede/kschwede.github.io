def invMod(a,n):
    #this finds the inverse of a mod n
    r1 = n
    r2 = a
    tempR = 0
    t1 = 0
    t2 = 1
    tempT = 0
    q = 0
    while (r2 > 0):
        q = r1//r2
        tempT = t2
        t2 = t1 - q*t2
        t1 = tempT
        tempR = r2
        r2 = r1 - q*r2
        r1 = tempR
    if (r1 > 1):
        return 0