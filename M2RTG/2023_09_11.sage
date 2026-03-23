G = Graph([(0, 1), (1, 2), (0, 2)])
G.plot().show()
V = G.vertices()
print(V)
E = G.edges(labels=False)
print(E)
R = macaulay2('ZZ/2[x_0, x_1, x_2]')
print(R)
x = R.gens()
print(x)
f = x[0] - x[1] * x[2]
print(f)
mons = [x[v] * x[w] for v, w in E]
I = macaulay2.ideal(mons)
C = I.res()
B = I.res().betti()
print(C)
print(B)
print(C.dot('dd'))

def bettiTable(G):
	V = G.vertices(sort=True)
	E = G.edges(labels=False)
	vars = ','.join([f'x_{v}' for v in V])
	R = macaulay2(f'ZZ/2[{vars}]')
	x = R.gens()
	I = macaulay2.ideal([x[v] * x[w] for v, w in E])
	return I.res().betti()

def totalBetti(G):
	B = bettiTable(G)
	B = dict(B)
	tot = {}
	for key in B:
		i = key[0].sage()
		if i not in tot:
			tot[i] = 0
		tot[i] += B[key]

	return [tot[i] for i in range(len(tot))]

for n in range(1, 10):
	print(totalBetti(graphs.CompleteGraph(n)))