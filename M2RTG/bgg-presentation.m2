loadPackage "BGG"
S = GF(5)[x_0, x_1, x_2]
E = GF(5)[e_0, e_1, e_2, SkewCommutative=>true]

use S
M = coker matrix {{x_0^2, x_1^2, x_2^2}}
bgg(2, M, E)

tateResolution(M, E, -5, 5)
tateResolution(presentation M, E, -5, 5)


mm = matrix {{random(3, S)}}
tateResolution(mm, E, -5, 5)
oo.dd
betti tateResolution(mm, E, -5, 5)

cohomologyTable(mm, E, -5, 5)

---

S = GF(5)[x_0 .. x_3]
E = GF(5)[y_0 .. y_3, SkewCommutative => true]

cohomologyTable(matrix{{sub(0,S)}}, E, -5, 5)


mm = matrix{{random(3, S), random(3, S)}}
cohomologyTable(mm, E, -5, 5)

--

S = QQ[x_0 .. x_4]
E = QQ[y_0 .. y_4, SkewCommutative => true]

use S
ff = x_0^5 + x_1^5 + x_2^5 + x_3^5 + x_4^5 - 101*x_0*x_1*x_2*x_3*x_4
R = S / ff

Y = Proj(S)
X = Proj(R)

omegaX = cotangentSheaf(X)
oo.module
presentation oo
sub(oo, S)
cokernel(oo)
oo / (ff*oo)
omegaXmat = presentation oo

time(cohomologyTable(omegaXmat, E, -5, 5))

time for i in 0..3 do(
    for j in -5..10 do(
	print HH^i(omegaX(j))
	)
    )
