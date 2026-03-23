restart
T = ZZ/101[a_0..a_8]
S = ZZ/101[x,y,z,u,v,w]/ideal(x^3 + y^3 + z^3, u^3 + v^3 + w^3 + u*v*w)
phi = map(S, T, {x*u, y*u, z*u, x*v, y*v, z*v, x*w, y*w, z*w})
J = ker phi
R = T/J
jacobian J
time singularLocus J
prune R 
--this ring should be regular except the origin
needsPackage "FastMinors"
elapsedTime regularInCodimension(1, R)
elapsedTime regularInCodimension(1, R)
elapsedTime regularInCodimension(1, R)
elapsedTime regularInCodimension(1, R)
elapsedTime regularInCodimension(1, R)
--let's see what was happening in the mistaken version
S2 = ZZ/101[x,y,z,u,v,w]/ideal(x^3 + y^3 + z^3, u^3 + v^3 + u*v*w)
phi2 = map(S2, T, {x*u, y*u, z*u, x*v, y*v, z*v, x*w, y*w, z*w})
J2 = ker phi2
R2 = T/J2
prune R2
elapsedTime regularInCodimension(1, R2)
--note the return value
elapsedTime regularInCodimension(1, R, Verbose=>true)
elapsedTime regularInCodimension(1, R, Verbose=>true)
elapsedTime regularInCodimension(1, R, Verbose=>true)
elapsedTime regularInCodimension(1, R, Verbose=>true, Strategy=>StrategyRandom)

elapsedTime regularInCodimension(1, R, Strategy=>StrategyDefaultNonRandom)
elapsedTime regularInCodimension(1, R, Strategy=>StrategyDefaultNonRandom)
elapsedTime regularInCodimension(1, R, Strategy=>StrategyDefaultNonRandom)
elapsedTime regularInCodimension(1, R, Strategy=>StrategyDefaultNonRandom, Verbose=>true)
elapsedTime regularInCodimension(1, R, Strategy=>StrategyDefaultWithPoints, Verbose=>true)

elapsedTime regularInCodimension(2, R)
elapsedTime regularInCodimension(2, R)
elapsedTime regularInCodimension(2, R)
elapsedTime regularInCodimension(2, R)
elapsedTime regularInCodimension(2, R, Verbose=>true)
elapsedTime regularInCodimension(2, R, Strategy=>StrategyDefaultNonRandom)
elapsedTime regularInCodimension(2, R, Strategy=>StrategyDefaultNonRandom)
elapsedTime regularInCodimension(2, R, Strategy=>StrategyDefaultNonRandom, Verbose=>true)
elapsedTime regularInCodimension(2, R, Strategy=>StrategyDefaultWithPoints, Verbose=>true)

--we can do it manually too
dim R
J1 := J
J1 = chooseGoodMinors(1, 6, jacobian J, J1, Strategy=>StrategyPoints) + J1; dim J1
#(associatedPrimes J1)
#(associatedPrimes radical J1)
loadPackage("Divisor", Reload=>true)
#( associatedPrimes reflexify (sub(J1, T/J)))
radical J1
--What else can you do?  Finding minors is useful for lots of other things too.  
--We use it when determining if a map is birational, at least for some strategies.
--pdim vs projDim
--pdim does not always give the right answer when something is non-graded.
--however, if the ideal of (correct) sized minors of a map in free res generates the unit ideal
--then you can stop there.
R = QQ[x,y];
I = ideal((x^3+y)^2, (x^2+y^2)^2, (x+y^3)^2, (x*y)^2);
pdim(module I)
--note, by default M2 stops the resolution at dimension.
--that one has pdim 1 in actuality in this case.  
time projDim(module I)
  
time projDim(module I, Strategy=>StrategyDefaultNonRandom)
time projDim(module I, MinDimension=>1) --this way we don't try to check if pdim = 0.
