--************************
--This function returns true if the ring is F-injective.  It returns false otherwise.  It only works for graded rings right now since it relies on pushForward.
--You may call
--isFInjective("ring")
--isFinjective("ring")
--isFInj("ring")
--isFinj("ring")
--isFInjectiveDebug("ring", bool) where bool is "true" if you want debug information
--************************

isFInjectiveDebug = (R, myDebug) -> (

--**************
--start with some sanity checking
--**************
	if isRing(R) == false then (print "You must input a ring";) else(
	if isHomogeneous(R) == false then (print "We currently require the ring to be Homogeneous"; ) else(

--**************
--some initial definitions
--**************
	J := ideal R;	
	S := ring J;
--**************
--more sanity checking
--**************
	p := char S;
	if (p == 0) then (print "You must supply a ring of positive characteristic";) else(
	if (J == ideal(0_S)) then (true) else( 
--**************
--now define a couple small functions
--**************
	multP := x -> x*p;
	Frob := x -> x^p;
	n := numColumns vars R;
	varList := gens R;
	if (myDebug == true) then (print "Done definitions");
	
--*****************
--I create two new rings to do the computations with (one I definitely need to create, the other is not so critical).  Thus I first create a list of the new variables
--******************

	newVarList1 := for i from 0 to (n-1) list concatenate((toString(gens S)#i), "k");

	newVarList2 := for i from 0 to (n-1) list concatenate((toString(gens S)#i), "l"); 
	if (myDebug == true) then (print "Initial VariableLists Created");

--****************
--Now I add the Degree info to the variables
--****************

	varArray1 := flatten [ newVarList1 ] | [Degrees=>flatten(degrees S)];
	varArray2 := flatten [ newVarList2 ] | [Degrees=>flatten(multP\(flatten (degrees S)))];
	if (myDebug == true) then (print "Actual VariableLists Created"; print varArray1; print varArray2;);	
	
--*****************
--actually create the rings
--*****************

	S1 := (ZZ/p)varArray1;
	S2 := (ZZ/p)varArray2;

--*****************
--define the Frobenius map between the rings
--*****************

	F := map(S1, S2, Frob\(gens S1));
	id1 := map(S1, S, (gens S1));
	id2 := map(S2, S, (gens S2));
	J1 := id1(J);
	J2 := id2(J);

--*****************
--pushforward the module in question and construct the Frobenius map as a module map
--*****************
	if (myDebug == true) then (print "Frobenius map defined");
	M := pushForward(F, (S1^1/J1));
	if (myDebug == true) then (print "Frobenius pushedForward");
	
	s := numgens M;
	
	matrixList := {{1}}|(for j from 1 to (s-1) list {0});

	FMatrix := map(M, (S2^1/J2), matrixList);
	if (myDebug == true) then (print "Frobenius defined as map of modules");

--*****************
--do the actual computation if the maps are surjective
--*****************

	--returnVal := true;

	if (myDebug == true) then (print "Below are the lists of cokernel Ext dimensions:");
	outputList := for i from 1 to (dim S) list 1 + (dim coker Ext^i(FMatrix, S2^1)) do(
		if (myDebug == true) then (print dim coker Ext^i(FMatrix, S2^1));
		--if (-1 < dim coker Ext^i(FMatrix, S2^1)) then print false;
	);
	if (myDebug == true) then (print "Here is the list of 1 + the cokernel Ext dimensions"; print outputList);

	mySum := sum outputList;
	if (mySum == 0) then true else false
	--if (returnVal == false) then false else true
))))
)

isFInjective = (R) -> (isFInjectiveDebug(R, false))

isFinjective = (R) -> (isFInjective(R))

isFinj = (R) -> (isFInjective(R))

isFInj = (R) -> (isFInjective(R))
