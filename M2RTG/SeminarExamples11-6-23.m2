--------------------------------
--an interesting non-normal ring.  On my computer integral closure is very fast.  Geometrically this replaces an elliptic curve unioned with a line in A^2 by an affine line
--------------------------------
B = (ZZ/101)[IGen1, CGensInA1,KGens1, KGens2]/ideal(KGens1^2- IGen1*KGens2,IGen1*CGensInA1^4 *KGens1+IGen1*CGensInA1^3* KGens2+IGen1*CGensInA1^2* KGens1-IGen1^2*KGens1+IGen1* CGensInA1*KGens2-CGensInA1* KGens1*KGens2-KGens2^2,IGen1^2 *CGensInA1^4+IGen1*CGensInA1^3 *KGens1+IGen1^2*CGensInA1^2- IGen1^3+IGen1*CGensInA1*KGens1 -IGen1*CGensInA1*KGens2-KGens1 *KGens2);
icMap B

--this was constructed by 
needsPackage "Pullback";
R = ZZ/101[x,y];
I = ideal((y^2 - x^3 - x)*(x+y));
S = R/I;
f = map(S, R);
T = ZZ/101[t];
g = map(S, T, {x});
B = (pullback(f,g))#0;
toString describe B

--------------------------------
--A three dimensional example, this replaces a quartic surface in A^3 by a copy of A^2.  It runs quite quickly on my computer.
--------------------------------

A = (ZZ/11)[IGen1, CGensInA1, CGensInA2, KGens1, KGens2,  KGens3]/(KGens2^2-KGens1*KGens3,KGens1*KGens2+IGen1*KGens3,KGens1^2+IGen1*KGens2,IGen1*CGensInA1^4*KGens2+IGen1*  CGensInA2^4*KGens2-4*IGen1*CGensInA2^3*KGens3+5*CGensInA2^2*KGens1*KGens3-IGen1^2*KGens2+4*CGensInA2*KGens2*KGens3-2*  KGens3^2,IGen1*CGensInA1^4*KGens1+IGen1*CGensInA2^4*KGens1-4*IGen1*CGensInA2^3*KGens2-5*IGen1*CGensInA2^2*KGens3-IGen1  ^2*KGens1+4*CGensInA2*KGens1*KGens3-2*KGens2*KGens3,IGen1^2*CGensInA1^4+IGen1^2*CGensInA2^4+4*IGen1*CGensInA2^3*KGens1  +5*IGen1*CGensInA2^2*KGens2-IGen1^3+4*IGen1*CGensInA2*KGens3+2*KGens1*KGens3)
icMap A

--this was constructed by
R = ZZ/11[x,y,z];
I = ideal(x^4 + y^4 + z^4);
S = R/I;
f = map(S,R);
T = ZZ/11[u,v];
g = map(S, T, {x,y+z});
A = (pullback(f,g))#0;
toString describe A

--------------------------------
--A three dimensional example.  On my computer computing its integral closure is very slow.  Geometrically this replaces the three coordinate axes in A^3 by a single A^1
--------------------------------
C = (ZZ/103)[IGen1, IGen2, IGen3, CGensInA1, KGens1, KGens2, KGens3, KGens4]/(KGens2^2-KGens1*KGens4,IGen2*KGens2-IGen3*KGens4,IGen1*KGens2-IGen2*KGens3,IGen2*KGens1-IGen3*KGens2,IGen1* KGens1-IGen3*KGens3,IGen1*IGen2+IGen1*IGen3+IGen2*IGen3+CGensInA1*KGens2,IGen3*CGensInA1*KGens3+KGens1*KGens2+KGens1* KGens3+KGens2*KGens3,IGen2*CGensInA1*KGens3+KGens2*KGens3+KGens1*KGens4+KGens3*KGens4,IGen2*IGen3*KGens3+IGen1*IGen3* KGens4+IGen3^2*KGens4+CGensInA1*KGens1*KGens4,IGen1*IGen3*KGens3+CGensInA1*KGens2*KGens3-IGen1^2*KGens4-2*IGen1*IGen3* KGens4-IGen3^2*KGens4-CGensInA1*KGens1*KGens4-CGensInA1*KGens3*KGens4,IGen2^2*KGens3-IGen1*IGen3*KGens4,IGen3^2*KGens2+ CGensInA1*KGens1*KGens2+IGen3^2*KGens3-IGen1*IGen3*KGens4-IGen3^2*KGens4-CGensInA1*KGens1*KGens4,IGen2*IGen3*CGensInA1+ CGensInA1^2*KGens2-IGen3*KGens2-2*IGen2*KGens3-IGen3*KGens3-IGen1*KGens4-IGen3*KGens4,IGen1*IGen3*CGensInA1+IGen3* KGens2+IGen2*KGens3+IGen3*KGens3,IGen3^3+IGen3*CGensInA1*KGens1+KGens1^2+KGens1*KGens2,IGen2*IGen3^2+IGen3*CGensInA1* KGens2+KGens1*KGens2+KGens1*KGens4,IGen1*IGen3^2-KGens1*KGens2,IGen2^2*IGen3+IGen3*CGensInA1*KGens4+KGens1*KGens4+ KGens2*KGens4,IGen1^2*IGen3-KGens2*KGens3,IGen2^3+IGen2*CGensInA1*KGens4+KGens2*KGens4+KGens4^2,IGen1^3+IGen1*CGensInA1 *KGens3+KGens2*KGens3+KGens3^2,IGen3^2*CGensInA1*KGens4+CGensInA1^2*KGens1*KGens4-IGen3*KGens2*KGens3-IGen3*KGens1* KGens4-IGen3*KGens2*KGens4-IGen2*KGens3*KGens4-2*IGen3*KGens3*KGens4,IGen1^2*CGensInA1*KGens4+CGensInA1^2*KGens3*KGens4 -IGen2*KGens3^2-IGen3*KGens2*KGens4-IGen1*KGens3*KGens4-IGen2*KGens3*KGens4-2*IGen3*KGens3*KGens4,CGensInA1*KGens1* KGens2*KGens3+IGen3^2*KGens3^2-IGen3^2*KGens1*KGens4-CGensInA1*KGens1^2*KGens4-2*IGen3^2*KGens3*KGens4-CGensInA1*KGens1 *KGens3*KGens4+CGensInA1*KGens2*KGens3*KGens4-IGen1^2*KGens4^2-2*IGen1*IGen3*KGens4^2-IGen3^2*KGens4^2-CGensInA1*KGens1 *KGens4^2-CGensInA1*KGens3*KGens4^2,CGensInA1^2*KGens2*KGens3-2*IGen3*KGens2*KGens3-2*IGen2*KGens3^2-IGen3*KGens3^2- IGen3*KGens1*KGens4-IGen1*KGens3*KGens4-2*IGen3*KGens3*KGens4,CGensInA1^2*KGens1*KGens3*KGens4-IGen3*KGens2*KGens3^2- IGen3*KGens1*KGens2*KGens4-2*IGen3*KGens1*KGens3*KGens4-2*IGen3*KGens2*KGens3*KGens4-IGen2*KGens3^2*KGens4-2*IGen3* KGens3^2*KGens4)
icMap C

--this was constructed by
needsPackage "Pullback";
R = ZZ/103[x,y,z];
I = ideal(x*y,x*z,y*z);
S = R/I;
f = map(S, R);
T = ZZ/103[t];
g = map(S, T, {x+y+z});
C = (pullback(f,g))#0;
toString describe C

--------------------------------
--Other random examples
--------------------------------

restart
R = QQ[x,y,z]/ideal(x^7-z^7-y^2*z^5);
time conductor icMap R
S = QQ[x,y,z]/ideal(x^11-z^11-y^2*z^9);
time conductor icMap S

R = QQ[x,y,z];
I = ideal(x^4+y^4+z^4+x*y*z);
J = ideal jacobian I
J1 = integralClosure J
J1 == J