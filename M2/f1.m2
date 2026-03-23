--- For a ring R = k[x,y] or k[x,y,z], where k has PRIME characteristic p, and a given homogeneous polynomial f.
--- Computes the F-signature for a specific value a/p^e
--- Input:
---	e - some positive integer
---	a - some positive integer between 0 and p^e
---	f - some HOMOGENEOUS polynomial in two or three variables in a ring of PRIME characteristic
---
--- Output:
---	returns value of the F-signature of the pair (R, f^{a/p^e})

Fsig = (e, a, f) -> (
if (dim (ring f)) == 2 then(
lenR = 1-(1/(char (ring f))^(2*e))*degree((ring f)^1/(ideal(x^((char (ring f))^e), y^((char (ring f))^e), f^a))));

if (dim (ring f)) == 3 then(
lenR = 1-(1/(char (ring f))^(3*e))*degree((ring f)^1/(ideal(x^((char (ring f))^e), y^((char (ring f))^e), z^((char (ring f))^e), f^a))));
lenR
)

------------------------------------------------------------------------------------------------------------------------

--- For a ring R = k[x,y] or k[x,y,z], where k has PRIME characteristic p, and a given homogeneous polynomial f.
--- Computes the F-signature using the Fsig function for the pair (R, f^{a/p^e}) for all a/p^e between 0 and the F-pure threshold of f, 
--- meaning the function GenPlot stops once Fsig(e, a, f) = 0
--- Writes data in real-number form to a file named "data".
--- The save file is formatted for display in gnuplot
--- Input:
---	e    - a positive integer
---	f    - some HOMOGENEOUS polynomial in TWO or THREE variables from a ring in PRIME characteristic
---	data - a string; the values of the F-signature are written (in real number form) to a file with this name
--- Output:
---	cL - a list of the values produced by Fsig, stored in rational (Macaulay2) form
---	Fsig(e, a, f) is computed for each a, the value returned printed to the screen
---	The values produced by Fsig are written to a file formatted for display in gnuplot

GenPlot = (e, f, data)->
(
cL = for i from 0 to (char (ring f))^e list
q:= Fsig(e, i, f) do (stdio<<i<<",   "<<q<<endl<<"============="<<endl; if q==0 then break);

fp=toString(data)<<"";
for i from 0 to (length cL)-1 do
fp<<toRR(i/(char (ring f))^e)<<" "<<toRR(cL#i)<<endl;
fp<<close;
)

---------------------------------------------------------------------------------------------------------------------------

--- Computes the F-signature for fixed e between certain values a/p^e and b/p^e
--- Input:
---	startA - the first value of the form a/p^e for which the F-signature is computed
---	endA   - the last value of the form a/p^e for which the F-signature is computed
---	e      - some positive integer
---	f      - some HOMOGENEOUS polynomial in TWO or THREE variables over a ring in PRIME characteristic
---	data   - a string; computed values of F-signature are written to a file with this name
---
--- Output:
---	cL     - a list containing, in rational form, the F-signatures computed
---	data   - the values of Fsig (in real valued form) are written to a file whose name is "data" formatted for display using gnuplot.

GenPlotPart = (startA, endA, e, f, data) ->
(
cL = for i from startA to endA list
q:= Fsig(e, i, f) do (stdio<<i<<",   "<<q<<endl<<"============="<<endl; if q == 0 then break);

fp:= toString(data)<<"";
for i from 0 to (length cL)-1 do
fp<<toRR((i+startA)/(char (ring f))^e)<<" "<<toRR(cL#i)<<endl;
fp<<close;
)
