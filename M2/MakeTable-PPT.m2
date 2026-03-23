loadPackage("TestIdeals", Reload => true)
loadPackage("FrobeniusThresholds", Reload => true)

-------------------------
--- SOME FUNCTIONS 
-------------------------


findExp = (p, qq) -> (
    --Given a rational qq whose denom is a power of p, find said power of p.
    --Returns 1 if p does not divide denominator.
    --Infinite loop in every other case!
    d := denominator(qq);
    if d % p != 0 then( return 1);
    found := false;
    e := 0;
    while not found do(
	if d == p^e then(
	    found = true)
	else (e = e + 1);
	);
    e
    )

isSuperGoodPrime = (a,b,p) -> (
    --superGoodPrimes are ones for which fpt0=lct
    R0 := (ZZ/p)[t,x];
    f0 := t^a + x^b;
    fpt0 := fpt(f0);
    if (fpt0 == 1/a + 1/b) then return true;
    return false;
)


modRem = (r,s) -> (
    if (r % s) > 0 then(
	return (r % s);
	) else(
	return s);
    )


-------------------------
--- FOR TABLE 1
-------------------------

isBadPrimeWeak = (a,b,p) -> (
    --A bad prime here is one for which the WEAK test of Cor. 3.2 fails.
    R0 := (ZZ/p)[t,x];
    f0 := t^a + x^b;
    fpt0 := fpt(f0);
    if (fpt0 == 1/a + 1/b) then return true;
    e := findExp(p, fpt0);
    if fpt0 >= (1/a + 1/b - 1/(a*p^e)) then( return false ) else ( return true );
    )

findBadPrimes = (a,b,N) -> (
    --- finds all primes 0<p<N for which
    --- fpt(t^a + x^b) =!= (1/a) + (1/b),
    --- and moreover the WEAK test from Cor. 3.2 for +pt(p^a + x^b) = fpt(t^a + x^b) fails
    p := 2;
    output := {};
    while p < N do(
	if ( not isSuperGoodPrime(a,b,p) ) and  isBadPrimeWeak(a,b,p) then(
	    output = append(output, p);
	    );
	p = nextPrime(p+1);
	);
    output
    )

for a in 2..5 do(
    for b in 2..5 do(
	badPs = findBadPrimes(a,b,1000);
	print "----------";
	print ("a="|toString(a)|", b="|toString(b));
	print(badPs);
	print(apply(badPs, xx -> (xx%(a*b)) ) );
	);
    )

-- note: a few sporadic cases are removed from Table 1 by using the full 
-- strength of Cor 3.2, i.e., by using the function
-- isBadPrimeStrong below. These cases are:
-- (a,b,p) = (2,2,2), (2,3,2), (3,2,3), (4,2,2), (5,4,5)

-------------------------
--- FOR FIGURE 1
-------------------------

optimalBound = (a,b,p,e) -> (
    c := a - floor(a/p);
    remA := modRem(c*p^e, a);
    remB := modRem(c*p^e, b);
    done := false;
    smallest := (1/a) + (1/b);
    while not done do(
	newValue := (1/a) + (1/b) - (1/p^e)*( (remA / (a*c)) + (remB / (b*c)) );
	if newValue < smallest then(
	    smallest = newValue;
	    );
	if (remA == a) and (remB == b) then( done = true; );
	c = c + 1;
	remA = modRem( remA + p^e, a);
	remB = modRem( remB + p^e, b);
	);
    return smallest
    )

isBadPrimeStrong = (a,b,p) -> (
    --badPrimes are ones for which fpt0=lct, or
    --the STRONG test from Cor 3.2 does NOT apply
    --i.e. for notBadPrimes, one has fpt=ppt
    R0 := (ZZ/p)[t,x];
    f0 := t^a + x^b;
    fpt0 := fpt(f0);
    if (fpt0 == 1/a + 1/b) then return true;
    e := findExp(p, fpt0);
    if fpt0 >= (1/a + 1/b - 1/(a*p^e)) then( return false );
    bound := optimalBound(a,b,p,e);
    if fpt0 > bound then( return false ) else ( return true );
    )


 -- remove before loading to actually produce files

-------------------------
--- WRITING OUTPUT FILES FOR FIGURE 1
-------------------------

p = 3;
i = 2;
j= 2;
outputList = {};--primes where ppt = fpt but not lct
outputList2 = {};--primes where fpt = ppt = lct

n = 30;
while (i < n) do (
   print i;
   j = 2;
   while (j < n) do (
       if not isBadPrimeStrong(i,j,p) then outputList = append(outputList, (i,j));
       if isSuperGoodPrime(i,j,p) then outputList2 = append(outputList2, (i,j));
       j = j+1;
   );
   i = i+1;
);



myFile = "output"|toString(n)|".txt" << toString(outputList) << endl << toString(outputList2)
myFile << close


k = 0;
myFile = "v2-formattedOutput"|toString(n)|"p"|toString(p)|".csv" << "";
while (k < max(#outputList, #outputList2) ) do (
    if (k < #outputList) then (
        myFile << outputList#k#0 << "," << outputList#k#1;
    )
    else (
        myFile << " , ";
    );
    myFile << " , ";
    if (k < #outputList2) then (
        myFile << outputList2#k#0 << "," << outputList2#k#1;
    )
    else (
        myFile << " , ";
    );
    myFile << endl;
    k = k+1;    
);
myFile << close

