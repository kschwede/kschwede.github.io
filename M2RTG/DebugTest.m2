f = method();
f(ZZ,ZZ) := (n,m) ->(
    v := n / m;
    v = 5*v;
    v
);

g = method();
g(ZZ) := (q) ->(
    u := f(q, random(3));
    u = u*10;
    u*100
);



