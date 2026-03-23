newPackage(
        "KHClosure",
        Version => "0.6", 
        Date => "4/2/2025",
        Authors => {
          {Name => "Neil Epstein", 
          Email => "nepstei2@gmu.ed", 
          HomePage => "https://math.gmu.edu/~nepstei2/"},
    
        {Name => "Peter McDonald", 
	     Email => "petermm2@uic.edu",
	     HomePage => "https://sites.google.com/view/petermcdonald/home/"},
          
	     {Name => "Rebecca R.G.", 
	     Email => "rrebhuhn@gmu.edu",
	     HomePage => "https://sites.google.com/site/rebeccargmath/"},

          {Name => "Karl Schwede", 
	     Email => "schwede@math.utah.edu",
	     HomePage => "https://www.math.utah.edu/~schwede/"}
        },

        Headline => "a package for computing Koszul-Hironaka closure, and related operations",
        DebuggingMode => true,
        PackageExports => {"BGG", "Complexes", "ReesAlgebra", "PushForward"},
        Reload => true           
        )

export{
    "koszulHironakaClosure",
    "subHironakaClosure", 
    "cmComplex",
    "hironakaClosure",
    "ComputeInQuotient",
    "CanonicalModule"
}



koszulHironakaClosure = method(Options=>{cache=>true})
-*
koszulHironakaClosure(Ideal, Ideal) := Ideal  => opts -> (I1, m1) -> ( --first ideal is the ideal you want to close, second is the ideal you want to blow up
    R1 := ring I1;
    J1 := ideal R1;
    A1 := ambient R1;
    if not (A1 === ring m1) then (
        if (R1 === ring m1) then m1 = sub(m1, A1);
        error "koszulHironakaClosure: expected the second ideal to be in the ring or ambient ring of the first";
    );
    S1 := reesAlgebra(m1);--blowup of m1
    J2 := saturate(J1*S1, m1*S1);--compute the strict transform
    K1 := complex koszul(gens sub(I1, A1));
    if (debugLevel > 1) then print "koszulHironakaClosure: computing directImageComplex";
    comp1 := complex directImageComplex(S1^1/J2);
    if (debugLevel > 1) then print "koszulHironakaClosure: computed directImageComplex";
    C1 := complex(A1^1);
    myHash1 := hashTable{0 => map(K1_0, C1_0, 1_A1)};
    f1 := map(K1, C1, myHash1);
    (ann image HH^0(f1**comp1))*R1
)
*-
koszulHironakaClosure(Ideal, Ideal) := Ideal  => opts -> (I1, m1) -> (
    C1 := cmComplex(sub(m1, ring I1), cache=>opts.cache);
    koszulHironakaClosure(I1, C1, opts)
)

koszulHironakaClosure(Ideal, Module) := Ideal  => opts -> (I1, M1) -> (
    C1 := cmComplex(M1, cache=>opts.cache);
    koszulHironakaClosure(I1, C1, opts)
)




koszulHironakaClosure(Ideal, Complex) := Ideal => opts -> (I1, comp1) -> ( --the ideal, and a complex over the ambient polynomial ring
    R1 := ring I1;
    J1 := ideal R1;
    A1 := ambient R1;
    --if not (A1 === ring m1) then error "expected the second ideal to be in the ambient ring of the first";
    --S1 := reesAlgebra(m1);--blowup of m1
    --J2 := saturate(J1*S1, m1*S1);--compute the strict transform
    K1 := complex koszul(gens sub(I1, A1));
    C1 := complex(A1^1);
    myHash1 := hashTable{0 => map(K1_0, C1_0, 1_A1)};
    f1 := map(K1, C1, myHash1);
    (ann image HH^0(f1**comp1))*R1
)


cmComplex = method(Options=>{cache=>true, ComputeInQuotient=>false, LengthLimit => null, CanonicalModule => null}); --create a Cohen-Macaulay complex corresponding to RGamma(O_Y).

cmComplex(Module) := Complex => opts -> (M1) -> (    --create it from Gamma(omega_Y)
    R1 := ring M1;
    local N1;
    local myDual;
    if (opts.ComputeInQuotient) then ( --if we do not lift to the ambient ring, ie if we are using the CanonicalModule option.
   
        if (opts.cache) and (R1#?cache) and (R1#cache)#?(cmComplex, Module, ComputeInQuotient) then (
                if (debugLevel > 2) then print "cmComplex: using cached value";
                return (R1#cache)#(cmComplex, Module, ComputeInQuotient);   
        );
        local len;
        if (opts.LengthLimit === null) then len = 2*(dim R1) + 2 else len = opts.LengthLimit;
        N1 = res(M1, LengthLimit => len);
        if (opts.CanonicalModule === null) then myDual = complex (Hom(N1, R1^1)) else myDual = complex (Hom(N1, opts.CanonicalModule));
        if (opts.cache) then (
            if not (R1#?cache) then R1#cache = new CacheTable from {};
            (R1#cache)#(cmComplex, Module, ComputeInQuotient) = myDual;
        );
        myDual
    )
    else (    
        if (opts.cache) and (R1#?cache) and (R1#cache)#?(cmComplex, Module) then (
            if (debugLevel > 2) then print "cmComplex: using cached value";
            return (R1#cache)#(cmComplex, Module);    
        );
        A1 := ambient R1;
        J1 := ideal R1;
        d1 := dim R1;
        pi1 := map(R1, A1);
        if (isFreeModule (ambient M1)) and (rank ambient M1 == 1) then (
            tempMult := sub(ann((ambient M1)/M1), A1);            
            N1 = res prune (tempMult*(A1^1/J1));            
        )
        else (
            N1 = res ((pushFwd(pi1, M1))); --take a resolution     
        );
        --N1 = res prune ((sub(M1, A1))**(A1^1/J1));
        if (debugLevel > 1) then print  "cmComplex: took the resolution";
        if (debugLevel > 2) then print N1;
        myDual =complex (Hom(N1, A1^1))[-(dim A1)+d1];
        if (opts.cache) then (
            if not (R1#?cache) then R1#cache = new CacheTable from {};
            (R1#cache)#(cmComplex, Module) = myDual;
        );
        myDual
    )
)

cmComplex(Ideal) := Complex => opts -> (I1) -> (    --create it from an ideal whose blowup constructs the complex
    if (opts.ComputeInQuotient) then error "cmComplex: cannot compute complex over quotient ring with Ideal input";
    R1 := ring I1;
    if (opts.cache) and (R1#?cache) and (R1#cache)#?(cmComplex, Ideal) then return (R1#cache)#(cmComplex, Ideal);        
    J1 := ideal R1;
    A1 := ambient R1;    
    m1 := sub(I1, A1);
    S1 := reesAlgebra(m1);--blowup of m1
    J2 := saturate(J1*S1, m1*S1);--compute the strict transform
    K1 := complex koszul(gens sub(I1, A1));
    if (debugLevel > 1) then print "koszulHironakaClosure: computing directImageComplex";
    comp1 := complex directImageComplex(S1^1/J2);
    if (opts.cache) then (
        if not (R1#?cache) then R1#cache = new CacheTable from {};
        (R1#cache)#(cmComplex, Ideal) = comp1;
    );
    comp1
)

hironakaClosure = method(Options=>{cache=>true, LengthLimit=>null, CanonicalModule=>null})
--WORK IN PROGRESS
--ONLY WORKS IN GORENSTEIN RINGS (or CM rings via the Canonical Module option)
hironakaClosure(Ideal, Module) := Ideal => opts -> (I1, M1) -> (
    if (debugLevel > 2) then print "hironakaClosure : starting";
    R1 := ring I1;        
    d1 := dim R1;
    C1 := complex(R1^1);
    local K1;
    if (opts.LengthLimit === null) then (K1 = complex res(R1^1/I1), LengthLimit=>d1+1) else (K1 = complex res(R1^1/I1, LengthLimit => opts.LengthLimit));
    if (debugLevel > 2) then print "hironakaClosure : making complex map";
    myHash1 := hashTable{0 => map(K1_0, C1_0, 1_R1)};    
    if (debugLevel > 2) then print "hironakaClosure : computing CM complex";
    comp1 := cmComplex(M1, ComputeInQuotient=>true, cache=>opts.cache, LengthLimit =>null, CanonicalModule => opts.CanonicalModule);
    f1 := map(K1, C1, myHash1);
    (ann image HH^0(f1**comp1))
);



subHironakaClosure = method(Options=>{cache=>true})
subHironakaClosure(Ideal, Ideal) := Ideal  => opts -> (I1, m1) -> ( --first ideal is the ideal you want to close, second is the ideal you want to blow up
    -*R1 := ring I1;
    J1 := ideal R1;
    A1 := ambient R1;
    -*
    if not (A1 === ring m1) then error "expected the second ideal to be in the ambient ring of the first";
    S1 := reesAlgebra(m1);--blowup of m1
    J2 := saturate(J1*S1, m1*S1);--compute the strict transform
    K1 := complex (A1^1/(J1 + sub(I1, A1) ));
    if (debugLevel > 1) then print "koszulHironakaClosure: computing directImageComplex";
    comp1 := complex directImageComplex(S1^1/J2);
    if (debugLevel > 1) then print "koszulHironakaClosure: computed directImageComplex";
    comp1 := cmComplex(sub(m1, R1));
    C1 := complex(A1^1);
    myHash1 := hashTable{0 => map(K1_0, C1_0, 1_A1)};
    f1 := map(K1, C1, myHash1);
    (ann image HH^0(f1**comp1))*R1*-
    R1 := ring I1;
    comp1 := cmComplex(sub(m1, R1), cache=>opts.cache);
    subHironakaClosure(I1, comp1, opts)    
)

subHironakaClosure(Ideal, Module) := Ideal  => opts -> (I1, M1) -> ( --first ideal is the ideal you want to close, second is the ideal you want to blow up
    comp1 := cmComplex(M1, cache=>opts.cache);
    subHironakaClosure(I1, comp1, opts)    
)

subHironakaClosure(Ideal, Complex) := Ideal  => opts -> (I1, comp1) -> ( --first ideal is the ideal you want to close, second is the ideal you want to blow up
    R1 := ring I1;    
    J1 := ideal R1;
    A1 := ambient R1;    
    C1 := complex(A1^1);
    K1 := complex (A1^1/(J1 + sub(I1, A1) ));
    myHash1 := hashTable{0 => map(K1_0, C1_0, 1_A1)};
    f1 := map(K1, C1, myHash1);
    (ann image HH^0(f1**comp1))*R1
)



beginDocumentation()
doc ///
    Key        
        KHClosure
    Headline
        a package for computing the Koszul-Hironaka (KH) closure of an ideal in a ring of characteristic zero
    Description
        Text     
            The KH closure of an ideal in characteristic zero is a tight-closure-like operation for ideals in characteristic zero.  Simply create a quotient of a polynomial ring {\tt R}, specify an ideal {\tt J} whose closure you want to compute, and finally specify an ideal {\tt m} in the ambient polynomial ring whose blowup will resolve the singularities of {\tt R}.  To use it, call the function @TO koszulHironakaClosure@.
        Example
            A = QQ[x,y,z];
            J = ideal(x^5+y^5+z^5);
            m = ideal(x,y,z);
            R = A/J;
            koszulHironakaClosure(ideal(x,y)*R,m)
            koszulHironakaClosure(ideal(x^4,y^4,z^4)*R,m)
        Text
            As this is the cone over a smooth variety, blowing up the irrelevant ideal (the maximal ideal) provides a resolution of singularities.
            Alternately, if you happen to know the multiplier submodule / Grauert-Riemenschneider submodule $\Gamma(Y, \omega_Y)$, you can call the function using that instead.  In more complicated examples, that usage is typically much faster.
        Example
            multModule = sub(m^3,R)*R^1;
            koszulHironakaClosure(ideal(x,y)*R,multModule)
            koszulHironakaClosure(ideal(x^4,y^4,z^4)*R,multModule)
        Text
            This package also provides tools to compute at least a subset of the Hironaka pre-closure with the @TO subHironakaClosure@ command.  It also provides tools to compute the actual Hironaka pre-closure in a Gorenstein  ring of the multiplier ideal is known, or in a Cohen-Macaulay ring if $\Gamma(Y, \omega_Y)$ is known for a resolution of singularities.
        Example
            I = ideal(y,z);
            J1 = koszulHironakaClosure(I^2, m)
            J2 = subHironakaClosure(I^2,m)
            isSubset(J1, J2)
            isSubset(J2, J1)
            IcubedBar = integralClosure(I^3)
            isSubset(IcubedBar, J1) --KH closure can fail generalized Briancon-Skoda
            isSubset(IcubedBar, J2) --we don't know if that's true for Hironaka preclosure
///

doc ///
    Key
        koszulHironakaClosure
        (koszulHironakaClosure, Ideal, Ideal)
        (koszulHironakaClosure, Ideal, Module)
        (koszulHironakaClosure, Ideal, Complex)        
        [koszulHironakaClosure, cache]   
    Headline
        compute the KH-closure of an ideal
    Usage
        koszulHironakaClosure(J, m)
        koszulHironakaClosure(J, M)
        koszulHironakaClosure(J, C)             
    Inputs
        J : Ideal
            the ideal you want to compute the KH closure of
        m : Ideal
            an ideal whose blowup gives a resolution of singularities
        M : Module
            a module representing $\Gamma(Y, \omega_Y)$ for a regular alteration $Y$
        C : Complex
            a complex representing $\mathbb{R}\Gamma(Y, O_Y)$ for a regular alteration $Y$
        cache => Boolean
            passed to calls of @TO cmComplex@
    Outputs
        : Ideal
    Description
        Text
            Use this to compute the KH-closure of an ideal.  You need to provide the ideal {\tt J} of a quotient of a polynomial ring whose closure you want to compute as well as an ideal {\tt m} of the ambient polynomial ring (or the quotient) whose blowup computes the resolution of singularities.
        Example
            A = QQ[x,y,z];
            J = ideal(z*y^2-x^3+x*z^2);
            m = ideal(x,y,z);             
            R = A/J;
            I1 = koszulHironakaClosure(ideal(y,z)*R, m)
            koszulHironakaClosure(I1, m)                
        Text
            In this case, blowing up the maximal ideal computes the KH-closure as we are considering a cone over a smooth curve.  However, if you know the multiplier module / Grauert-Riemenschneider module, you can alternately call it with that module.  In this case, the multiplier module is simply the maximal ideal times a free module as we are taking a cone over an elliptic curve.  Using the Grauert-Riemenschneider module tends to be much faster than computing the resolution.
        Example
            multModule = sub(m, R)*R^1
            I2 = koszulHironakaClosure(ideal(y,z)*R, multModule)
        Text
            Finally, the slowest part of the computation is frequently computing the complex $\mathbb{R} \Gamma(Y, \mathcal{O}_Y)$ where $Y$ is a resolution of singularities or alteration.  If you already happen to know that complex, you can instead use it for your computation.  This needs to be a complex over the ambient polynomial ring of R.
        Example
            A = QQ[a,b,c]
            J = ideal(a^2*b - c^2)
            needsPackage "PushForward"
            R = A/J
            I = ideal(c^2)
            RN = integralClosure(R);
            phi = map(RN, A, matrix icMap(R));
            C = complex( (pushFwd(phi))#0);            
            trim koszulHironakaClosure(I, C)
            integralClosure I
        Text
            Whenever a ring has normalization with rational singularities, that normalization, as an $A$-module works as such a complex.  You can also construct the complex via the command @TO cmComplex@.  In the case above, we verified that the integral closure of a principal ideal was the same as KH closure, as expected.
///

doc ///
    Key
        cmComplex
        (cmComplex, Ideal)
        (cmComplex, Module)
        [cmComplex, cache]
        [cmComplex, ComputeInQuotient]
        [cmComplex, LengthLimit]
        [cmComplex, CanonicalModule]
    Headline
        compute the complex $\mathbb{R} \Gamma(Y, \mathcal{O}_Y)$ of a blowup or alteration
    Usage
        cmComplex(m)
        cmComplex(M)        
    Inputs        
        m : Ideal
            an ideal to blowup
        M : Module
            a module representing $\Gamma(Y, \omega_Y)$ for a regular alteration $Y$
        cache => Boolean
            whether to cache the output or use previously cached output
        ComputeInQuotient => Boolean
            compute it as a complex of ring M modules if R is Gorenstein
        LengthLimit => ZZ
            specify the length limit when computing a free resolution of M11 when {\tt ComputeInQuotient => true}, if {\tt null} estimate it
    Outputs
        : Complex
    Description
        Text
            This will compute a complex representing $\mathbb{R} \Gamma(Y, \mathcal{O}_Y)$ from a blowup or a multiplier module.  It will produce the complex over the ambient polynomial ring by default.
        Example
            R = QQ[x,y,z]/ideal(x^4+y^4+z^4);
            m = ideal(x,y,z);
            C1 = cmComplex(m); --blowup
            C2 = cmComplex(m^2*R^1); --the multiplier module
            ring C1
            prune HH^0(C1)
            prune HH^0(C2)
            ann HH^1(C1)
            ann HH^1(C2)
        Text
            Producing the complex from the multiplier module tends to be much faster and uses less memory.  The output will be stored if the option {\tt cache} is set to true.
        Text
            The complex produced can then be used in calls to @TO koszulHironakaClosure@ and @TO subHironakaClosure@.        
        Text
            Alternately, if your ring is Gorenstein, and you are calling cmComplex via the multiplier module command, this function can output the corresponding complex over {\tt ring M} if you set {\tt ComputeInQuotient => true}.
        Example
            C3 = cmComplex(m^2*R^1, ComputeInQuotient=>true)
            ring C3
            ann HH^1(C3)
        Text
            If your ring is only Cohen-Macaulay, but not necessarily Gorenstein, you can also construct the desired complex over {\tt ring M} if you specify the canonical module of your ring via the {\tt CanonicalModule} option.  This tends to be pretty slow in interesting examples (for instance, a veronese of a cone over a smooth variety).  We work with a simple example for speed purposes below.
        Example
            A = QQ[x,y,z,w];
            T = QQ[a,b];
            phi = map(T, A, {a^3,a^2*b,a*b^2,b^3});
            I = ker phi;
            R = A/I;
            needsPackage "Divisor"
            M = OO canonicalDivisor R
            C4 = cmComplex(M, ComputeInQuotient=>true, CanonicalModule=>M);
            prune HH^0(C4)
            prune HH^1(C4)
            prune HH^2(C4)
        Text
            In the above example, {\tt C4} should be simply be isomorphic to {\tt R^1} viewed as a complex in degree 0 since {\tt R} has rational singularities.
///

doc ///
    Key
        subHironakaClosure        
        (subHironakaClosure, Ideal, Ideal)
        (subHironakaClosure, Ideal, Module)
        (subHironakaClosure, Ideal, Complex)
        [subHironakaClosure, cache]
    Headline
        compute a subset of the Hironaka-preclosure of an ideal
    Usage
        subHironakaClosure(J, m)
        subHironakaClosure(J, M)
        subHironakaClosure(J, C)
    Inputs
        J : Ideal            
            the ideal you want to compute part of the Hironaka closure
        m : Ideal            
            an ideal whose blowup gives a resolution of singularities
        M : Module            
            a module representing $\Gamma(Y, \omega_Y)$ for a regular alteration $Y$
        C : Complex            
            a complex representing $\mathbb{R}\Gamma(Y, O_Y)$ for a regular alteration $Y$
        cache => Boolean
            passed to calls of @TO cmComplex@
    Outputs
        : Ideal
    Description
        Text
            Use this to compute a subset of the Hironaka-preclosure of an ideal.  You need to provide the ideal {\tt J} of a quotient of a polynomial ring whose closure you want to compute as well as an ideal {\tt m} of the ambient polynomial ring whose blowup computes the resolution of singularities.  
        Example
            A = QQ[x,y,z];
            J = ideal(z*y^2-x^3+x*z^2);
            m = ideal(x,y,z);             
            R = A/J;
            I = ideal(y,z)
            subHironakaClosure(I^2, m)                              
            koszulHironakaClosure(I^2,m)
        Text
            In this case, blowing up the maximal ideal computes the part of the Hironaka-closure as we are considering a cone over a smooth curve.
        Text
            You can also call {\tt subHironakaClosure} using a multiplier module / Grauert-Riemenschneider module $\Gamma(Y, omega_Y)$ or with a complex representing $\mathbb{R} \Gamma(Y, \mathcal{O}_Y)$ completely analogously to @TO koszulHironakaClosure@.
    Caveat
        Text
            We do not know if this computes the Hironaka preclosure or something smaller.  The point is, in our implementation, we are tensoring $R = A/J$ with the direct image of the structure sheaf of a resolution of singularities over the ambient $A$, and not over $R$.  
            The function @TO hironakaClosure@ can compute the full Hironaka preclosure in a Cohen-Macaulay ring, but it tends to be much slower.
///

doc ///
    Key
        hironakaClosure        
        (hironakaClosure, Ideal, Module)        
        [hironakaClosure, cache]
        [hironakaClosure, LengthLimit]
        [hironakaClosure, CanonicalModule]
    Headline
        compute the Hironaka-preclosure of an ideal in a Gorenstein ring
    Usage        
        hironakaClosure(J, M)
    Inputs
        J : Ideal            
            the ideal you want to compute part of the Hironaka closure        
        M : Module            
            a module representing $\Gamma(Y, \omega_Y)$ for a regular alteration $Y$
        cache => Boolean
            passed to calls of @TO cmComplex@
        LengthLimit => ZZ
            passed to calls of @TO cmComplex@
        CanonicalModule => Module
            passed to calls of @TO cmComplex@
    Outputs
        : Ideal
    Description
        Text
            Use this to compute a the Hironaka-preclosure of an ideal in a Gorenstein ring.  You need to provide the ideal {\tt J} of a quotient of a polynomial ring whose closure you want to compute as well as a module {\tt M} representing the multiplier module / Grauert-Riemenschneider module $\Gamma(Y, \omega_Y)$ of a regular alteration.  The @TO cmComplex@ function is used to compute $\mathbb{R} \Gamma(Y, \mathcal{O}_Y)$.
        Example
            A = QQ[x,y,z];
            J = ideal(x^4+y^4+z^4);
            m = ideal(x,y,z);             
            R = A/J;
            mR = sub(m, R);
            I = ideal(y,z)
            I2Hir = hironakaClosure(I^2, mR^2*R^1)                              
            I2KH = koszulHironakaClosure(I^2,m)
            isSubset(I2KH, I2Hir)                            
        Text
            The function also works in a Cohen-Macaulay ring if one passes a canonical module for {\tt R} via the {\tt CanonicalModule} option.  See also @TO [cmComplex, CanonicalModule]@ where this is passed.
        Text
            The option {\tt LengthLimit} controls the length of the free resolution of $R/I$ that is computed.  We have set it at a value that will give the correct answer.        
///

TEST /// --check #0, verifying it gives consistent answers for the cone over a cubic, on a parameter ideal and powers, also verifying Briancon-Skoda.
    A = QQ[x,y,z];    
    J = ideal(x^3+y^3+z^3) ;
    m = ideal(x,y,z);
    R = A/J;
    I = ideal(x,y); -- a parameter ideal
    mR = ideal(x,y,z);
    C1 = cmComplex(mR); --compute from blowup
    assert((R#cache)#(cmComplex,Ideal) === C1)
    remove(R#cache, (cmComplex,Ideal))
    C2 = cmComplex(mR*R^1); --compute from multiplier module
    assert((R#cache)#(cmComplex,Module) === C2)
    remove(R#cache, (cmComplex,Module))
    assert(ann(HH^1(C1)) == ann(HH^1(C2)))
    Im = koszulHironakaClosure(I,m);
    ImR = koszulHironakaClosure(I,mR*R^1);
    ImC1 = koszulHironakaClosure(I,C1);
    ImC2 = koszulHironakaClosure(I,C2);
    assert (Im == ImR)
    assert (Im == ImC1)
    assert (Im == ImC2)
    assert (isSubset(integralClosure(I^2),Im))
    I = I^3
    Im = koszulHironakaClosure(I,m);
    ImR = koszulHironakaClosure(I,mR*R^1);
    ImC1 = koszulHironakaClosure(I,C1);
    ImC2 = koszulHironakaClosure(I,C2);
    assert (Im == ImR)
    assert (Im == ImC1)
    assert (Im == ImC2)
///

TEST /// --check #1, verifying it gives consistent answers for the cone over a quintic, on a parameter ideal and powers, also verifying Briancon-Skoda in this case.  Also does some Hironaka and sub Hironaka clsoure
    A = QQ[x,y,z];    
    J = ideal(x^5+y^5+z^5) ;
    m = ideal(x,y,z);
    R = A/J;
    I = ideal(x,y); -- a parameter ideal
    mR = ideal(x,y,z);
    C1 = cmComplex(mR); --compute from blowup
    multModule = mR^3*R^1;
    assert((R#cache)#(cmComplex,Ideal) === C1)
    remove(R#cache, (cmComplex,Ideal))
    C2 = cmComplex(multModule); --compute from multiplier module
    assert((R#cache)#(cmComplex,Module) === C2)
    remove(R#cache, (cmComplex,Module))
    assert(ann(HH^1(C1)) == ann(HH^1(C2)))
    Im = koszulHironakaClosure(I,m);
    ImR = koszulHironakaClosure(I,multModule);
    ImC1 = koszulHironakaClosure(I,C1);
    ImC2 = koszulHironakaClosure(I,C2);
    assert (Im == ImR)
    assert (Im == ImC1)
    assert (Im == ImC2)
    assert (isSubset(integralClosure(I^2),Im))
    I = I^3
    Im = koszulHironakaClosure(I,m);
    ImR = koszulHironakaClosure(I,multModule);
    ImC1 = koszulHironakaClosure(I,C1);
    ImC2 = koszulHironakaClosure(I,C2);
    assert (Im == ImR)
    assert (Im == ImC1)
    assert (Im == ImC2)
    --as the ring is Gorenstein, we can explore ComputeInQuotient
    C3 = cmComplex(mR^3*R^1, ComputeInQuotient=>true)
    assert(ann HH^0(C3) == sub(ann HH^0(C1), R))
    assert(ann HH^1(C3) == sub(ann HH^1(C1), R))
    IHir = hironakaClosure(I, multModule)
    IsHir = subHironakaClosure(I, multModule)
    IKH = koszulHironakaClosure(I, multModule)
    assert(isSubset(IKH, IsHir))
    assert(isSubset(IsHir,IHir))
///

TEST /// --check #2, verifying it gives consistent answers for a non-normal (non-S2) ring, that is quasi-Gorenstein, also verifying colon capturing
    A = QQ[x,y,u,v];
    J = intersect(ideal(x,y), ideal(u,v));
    m = ideal(x,y,u,v);
    R = A/J -- not Cohen-Macaulay
    mR = sub(m, R);    
    multModule = sub(m, R)*R^1
    --C1 = cmComplex(sub(m, R))
    --assert((R#cache)#(cmComplex,Ideal) === C1)
    --remove(R#cache, (cmComplex,Ideal))
    C2 = cmComplex(sub(m, R)*R^1)
    assert((R#cache)#(cmComplex,Module) === C2)
    remove(R#cache, (cmComplex,Module))
    I = ideal(x^2*y^2,y^3,v^4*u)    
    ImR = koszulHironakaClosure(I,multModule);
    --ImC1 = koszulHironakaClosure(I,C1);
    ImC2 = koszulHironakaClosure(I,C2);
    --assert(ImR == ImC1)
    assert(ImR == ImC2)
    --now check colon capturing
    parm = ideal(x-u, y-v);--an sop
    assert(dim(R/parm) == 0)
    partParm = ideal(x-u)
    colonIdeal = partParm : ideal(y-v)
    partParmGamma = koszulHironakaClosure(partParm, multModule)
    --partParmC1 = koszulHironakaClosure(partParm, C1)    
    partParmC2 = koszulHironakaClosure(partParm, C2)
    --assert(partParmGamma == partParmC1)
    assert(partParmGamma == partParmC2)
    assert(isSubset(colonIdeal, partParmGamma))
///

TEST /// --check #3, verifying it gives consistent answers for a normal non-CM ring, that is quasi-Gorenstein, also verifying colon capturing
    n = 3;
    A = QQ[xr,yr,zr,xs,ys,zs,xt,yt,zt];
    B = (QQ[x,y,z]/(ideal(x^n+y^n+z^n)))**(QQ[r,s,t]/(ideal(r^n+s^n+t^n)));
    phi = map(B, A, {x*r,y*r,z*r,x*s,y*s,z*s,x*t,y*t,z*t});
    J = ker phi; -- make the Segre product, not Cohen-Macaulay
    m = ideal(xr,yr,zr,xs,ys,zs,xt,yt,zt);
    R = A/J;
    mR = sub(m, R);
    multModule = sub(m, R)*R^1 --it is LC, so this is the mult module    
    C2 = cmComplex(sub(m, R)*R^1)
    assert((R#cache)#(cmComplex,Module) === C2)
    remove(R#cache, (cmComplex,Module))    
    parm = ideal(xs,yt,zs+zt)
    assert(dim (R/parm) == 0) -- a parameter ideal has dimension = 0
    partParm = ideal(xs,yt)
    colonIdeal = partParm : ideal(zs+zt)
    assert(not(colonIdeal == partParm)) -- not Cohen Macaulay

    partParmC = trim koszulHironakaClosure(partParm, C2) 

    assert (isSubset(colonIdeal, partParmC))
///

TEST /// --check #4, checking edge cases
    R = QQ[x,y,z]
    m = ideal(x,y,z)
    C1 = cmComplex(m)
    assert((R#cache)#(cmComplex,Ideal) === C1)
    remove(R#cache, (cmComplex,Ideal))
    C2 = cmComplex(m^2)
    assert((R#cache)#(cmComplex,Ideal) === C2)
    remove(R#cache, (cmComplex,Ideal))
    C3 = cmComplex(R^1)
    assert((R#cache)#(cmComplex,Module) === C3)
    remove(R#cache, (cmComplex,Module))
    I = ideal(x^3,x^2*y,y^2,z^3)
    IC1 = koszulHironakaClosure(I, C1)
    IC2 = koszulHironakaClosure(I, C1)
    IC3 = koszulHironakaClosure(I, C1)
    Im = koszulHironakaClosure(I, m)
    IR = koszulHironakaClosure(I, ideal(1_R))
    assert(I == IC1)
    assert(I == IC2)
    assert(I == IC3)
    assert(I == Im)
    assert(I == IR)
///

TEST /// --check #5, comparing integral closure of principal ideals to KH closure in a non-normal ring
    R = QQ[x,y,z, Degrees=>{2,1,2}]/ideal(x*y^2-z^2)
    A = ambient R;    
    RN = integralClosure R  
    phi = map(RN, A, matrix icMap(R))
    RNMod = complex ((pushFwd(phi))#0)
    I = sub(ideal(y^2), R)
    Iint = integralClosure(I)
    cond = conductor R    
    IKosMult = koszulHironakaClosure(I, cond*R^1)
    IKosPush = koszulHironakaClosure(I, RNMod)    
    assert(Iint == IKosMult)
    assert(Iint == IKosPush)
    --checking Briancon-Skoda, non-parameter ideal
    J = sub(ideal(x^2,y^2,z^2), R)
    J3int = integralClosure(J^3)
    JKos = koszulHironakaClosure(J, cond*R^1)
    JKosPush = koszulHironakaClosure(J, RNMod)
    assert(JKos == JKosPush)
    assert(isSubset(J3int, JKos))        
///

TEST /// --check #6, checking Hironaka closure, and comparing all closures
    A = QQ[x,y,z]
    mA = ideal(x,y,z)
    R = A/ideal(x^4+y^4+z^4+x^2*y*z); --another isolated singularity    
    mR = ideal(x,y,z)
    J = ideal(x^2,y^2)
    assert(dim (R/J) == 0) --check this is a parameter ideal
    KH1 = koszulHironakaClosure(J, mA) --check via blowup
    KH2 = koszulHironakaClosure(J, mR^2*R^1)
    subHir = subHironakaClosure(J,mR^2*R^1)
    hir = hironakaClosure(J, mR^2*R^1)
    assert(KH1 == KH2)
    assert(KH1 == subHir)
    assert(KH1 == hir)
///

TEST /// --check #7, checking cmComplex on a ring with rational singularities when computing it in the quotient ring
    A = QQ[x,y,z,w];
    T = QQ[a,b];
    phi = map(T, A, {a^3,a^2*b,a*b^2,b^3});
    I = ker phi;
    R = A/I;
    needsPackage "Divisor"
    M = OO canonicalDivisor R
    C4 = cmComplex(M, ComputeInQuotient=>true, CanonicalModule=>M);
    assert(prune HH^0(C4) == R^1)
    assert(prune HH^1(C4) == 0)
    assert(prune HH^2(C4) == 0)
    assert(prune HH_1(C4) == 0)
///



end

--VERSION NOTES
--0.2  Added subHironakaClosure
--0.3  adding alterate ways to compute RGamma(O_Y) and exporting the output to the user, also added ability to compute Hironaka closure in Gorenstein rings.
--0.4  Improvements to hironakaClosure and to cmComplex.
--0.5  Hironaka closure in non-Gorenstein rings
--0.6  renaming functions to conform to Macaulay2 conventions

--examples
restart
loadPackage "KHClosure"
check KHClosure
restart
uninstallPackage "KHClosure"
loadPackage "KHClosure"
installPackage "KHClosure"
check KHClosure
restart
loadPackage "KHClosure"
A = QQ[x,y,z];
J = ideal(x^5+y^5+z^5) ;
m = ideal(x,y,z);
R = A/J;
I = ideal(x,y); -- a parameter ideal
mR = ideal(x,y,z);
C1 = cmComplex(mR^3*R^1)
koszulHironakaClosure(I,m)
koszulHironakaClosure(I,C)
koszulHironakaClosure(I,mR^3*R^1)
subHironakaClosure(I,m)
I2KH = koszulHironakaClosure(I^2,m)
k = 4; koszulHironakaClosure(I^k,m) == koszulHironakaClosure(I^k,C)
I2KHC = koszulHironakaClosure(I^2,C)
I2Hir = subHironakaClosure(I^2,m)
isSubset(I2KH, I2Hir)
member(x*z^2, I2KH) -- KH closure is strictly smaller than Hironaka
I3int = integralClosure(I^3)
isSubset(I3int, I2KH) --Briancon-Skoda counterexample for KH
isSubset(I3int, I2Hir) --not a counterexample for Hironaka closure
isSubset(integralClosure(I^3), koszulHironakaClosure(I^2,m))
isSubset(integralClosure(I^3), subHironakaClosure(I^2,m))
trim koszulHironakaClosure(ideal(x^4,y^4,z^4)*R,m)
koszulHironakaClosure(ideal(x^4,x*y,y^2)*R,m)
koszulHironakaClosure(oo)--double checking 

tempI = ideal(x^5,y^5,z^5)
t2 = koszulHironakaClosure(tempI, m)
isSubset(tempI, t2)
isSubset(t2, tempI)
koszulHironakaClosure(t2, m)



restart --verifying colon capturing in a more complicated example
loadPackage "KHClosure"
--debugLevel = 10
n = 5;
A = QQ[xs,ys,zs,xt,yt,zt];
B = (QQ[x,y,z]/(ideal(x^n+y^n+z^n)))**QQ[s,t];
phi = map(B, A, {x*s,y*s,z*s,x*t,y*t,z*t});
J = ker phi; -- make the Segre product, not Cohen-Macaulay
m = ideal(xs,ys,zs,xt,yt,zt);
R = A/J;
parm = ideal(xs,yt,zs+zt)
dim R
dim (R/parm) -- a parameter ideal as dimension = 0
partParm = ideal(xs,yt)
colonIdeal = partParm : ideal(zs+zt)
colonIdeal == partParm
partParmC = koszulHironakaClosure(partParm, m)  --this takes forever and terabytes of memory
isSubset(colonIdeal, partParmC)



restart --verifying colon capturing in a simple example
loadPackage "KHClosure"
A = QQ[x,y,u,v];
J = intersect(ideal(x,y), ideal(u,v));
m = ideal(x,y,u,v);
R = A/J -- not Cohen-Macaulay
dim(R)
parm = ideal(x-u, y-v);--an sop
dim(R/parm)
partParm = ideal(x-u)
colonIdeal = partParm : ideal(y-v)
partParmC = koszulHironakaClosure(partParm, m)
C1 = cmComplex(sub(m, R))
partParmC1 = koszulHironakaClosure(partParm, C1)
C2 = cmComplex(sub(m, R)*R^1)
partParmC2 = koszulHironakaClosure(partParm, C2)
isSubset(colonIdeal, partParmC)

restart
loadPackage "KHClosure"
A = QQ[x,y,z];
J = ideal(x^3+y^3+z^3) ;
R = A/J;
mR = ideal(x,y,z);
C = cmComplexFromMultiplierModule(mR*R^1)
ann HH^0(C)
ann HH^1(C)
I = ideal(x,y);
koszulHironakaClosure(I, C)

restart --verifying colon capturing in a more complicated example
loadPackage "KHClosure"
loadPackage "Divisor"
--debugLevel = 10
n = 3;
A = QQ[xr,yr,zr,xs,ys,zs,xt,yt,zt];
B = (QQ[x,y,z]/(ideal(x^n+y^n+z^n)))**(QQ[r,s,t]/(ideal(r^n+s^n+t^n)));
phi = map(B, A, {x*r,y*r,z*r,x*s,y*s,z*s,x*t,y*t,z*t});
J = ker phi; -- make the Segre product, not Cohen-Macaulay
m = ideal(xr,yr,zr,xs,ys,zs,xt,yt,zt);
R = A/J;
mR = ideal(xr,yr,zr,xs,ys,zs,xt,yt,zt);
canonicalDivisor(R)
parm = ideal(xs,yt,zs+zt)
dim R
dim (R/parm) -- a parameter ideal as dimension = 0
partParm = ideal(xs,yt)
colonIdeal = partParm : ideal(zs+zt)
colonIdeal == partParm
C = cmComplex(mR*R^1)
partParmC = trim koszulHironakaClosure(partParm, C) 
(partParm*mR) : (mR)

partParmC = koszulHironakaClosure(partParm, m)  --this takes forever and terabytes of memory
isSubset(colonIdeal, partParmC)

partParm2 = ideal(xs^3+yt^2,yt^3)
(partParm2*mR) : (mR)
partParmC = koszulHironakaClosure(partParm2, C)

restart
loadPackage "KHClosure"
A = QQ[x,y,z];
n = 3;
J = ideal(x^n+y^n+z^n) ;
m = ideal(x,y,z);
R = A/J;
mR = ideal(x,y,z);
C1 = cmComplex(mR^(n-2)*R^1)
C2 = cmComplex(mR)
prune HH^0(C1)
prune HH^0(C2)
prune HH^1(C1)
prune HH^1(C2)
prune HH^2(C1)
prune HH^2(C2)

restart
loadPackage "KHClosure"
A = QQ[x,y,z];    
J = ideal(x^5+y^5+z^5) ;
m = ideal(x,y,z);
R = A/J;
I = ideal(x,y); -- a parameter ideal
mR = ideal(x,y,z);
mult = mR^3*R^1;
I4 = I^4;
I4Hir = hironakaClosure(I^4, mult, cache=>false)
I4sHir = subHironakaClosure(I^4,mult, cache=>false)
I4sHir2 = subHironakaClosure(I4sHir,mult, cache=>false)
I4Hir2 = hironakaClosure(I4Hir, mult, cache => false)
I4Hir3 = hironakaClosure(I4Hir2, mult)



--***********************************************************
--***********************************************************
--***********************************************************
--Computation, Example 5.1 in paper.
--***********************************************************
--***********************************************************
--***********************************************************
restart


loadPackage "KHClosure";
A = QQ[x,y,z]; J = ideal(x^3+y^3+z^3); m = ideal(x,y,z); R = A/J;
koszulHironakaClosure(ideal(x,y)*R,m) --KH closure of a parameter ideal - not closed
diagonal2 = koszulHironakaClosure(ideal(x^2,y^2,z^2)*R,m)
member(x*y*z,diagonal2) -- it is in the tight closure
diagonal3 = koszulHironakaClosure(ideal(x^3,y^3,z^3)*R,m)
member(x^2*y^2*z^2, diagonal3) --in both the tight and KH closures
BrennerComparison = koszulHironakaClosure(ideal(x^4,x*y,y^2)*R,m)
member(y*z^2, BrennerComparison) --this is in tight closure, but not KH-closure

restart
loadPackage "KHClosure"
A = QQ[x,y,z,w]; J = ideal(x^4+y^4+z^4+w^4);  m = ideal(x,y,z,w);  R = A/J;
diagonal3 = koszulHironakaClosure(ideal(x^3,y^3,z^3,w^3), m) --it's already closed
member(x^2*y^2*z^2*w^2, diagonal3)

restart
loadPackage "KHClosure"
A = QQ[x,y,z]; J = ideal(x^7+y^7+z^7);  m = ideal(x,y,z);  R = A/J;
BrennerKatzmanExample45=koszulHironakaClosure(ideal(x^4,y^4,z^4), m)
isSubset(m^7*R, BrennerKatzmanExample45)
isSubset(m^8*R, BrennerKatzmanExample45)

--***********************************************************
--***********************************************************
--***********************************************************
--Computation, Example 5.3 in paper.
--***********************************************************
--***********************************************************
--***********************************************************

restart
loadPackage "KHClosure";
A = QQ[xr,yr,zr,xs,ys,zs,xt,yt,zt];
n = 3; B = (QQ[x,y,z]/(ideal(x^n+y^n+z^n)))**(QQ[r,s,t]/(ideal(r^n+s^n+t^n)));
phi = map(B, A, {x*r,y*r,z*r,x*s,y*s,z*s,x*t,y*t,z*t});
J = ker phi; -- make the Segre product, not Cohen-Macaulay     
R = A/J; -- a cone over an Abelian variety
mR = ideal(xr,yr,zr,xs,ys,zs,xt,yt,zt); --maximal ideal, actually the multiplier ideal
partParm = ideal(xs,yt)
time trim koszulHironakaClosure(partParm, mR*R^1)


--***********************************************************
--***********************************************************
--***********************************************************
--Computation, Subsection 5.2 in the paper
--***********************************************************
--***********************************************************
--***********************************************************

restart
loadPackage "KHClosure";
A = QQ[x,y,z];
J = ideal(x^5+y^5+z^5) ;
mA = ideal(x,y,z);
R = A/J;
I = ideal(x,y);
IKH = koszulHironakaClosure(I, mA)
I2KH = koszulHironakaClosure(I^2, mA)
isSubset(IKH*IKH, I2KH)
IxKH = koszulHironakaClosure(I*x,mA)
IxKH == x*IKH

--***********************************************************
--***********************************************************
--***********************************************************
--Computation, Remark 6.6
--***********************************************************
--***********************************************************
--***********************************************************

restart
loadPackage "KHClosure";
A = QQ[x,y,z];  J = ideal(x^5+y^5+z^5);  mA = ideal(x,y,z);
R = A/J; mR = sub(mA, R);
I = ideal(x,y); -- a parameter ideal 
I2KH = koszulHironakaClosure(I^2,mA)
I2sHir = subHironakaClosure(I^2,mA)
I2Hir = hironakaClosure(I^2,mR^3*R^1) --you need to specify the multiplier ideal/module of R in this case
I2sHir == I2Hir
isSubset(I2KH, I2Hir)
member(x*z^2, I2KH) -- KH closure is strictly smaller than Hironaka  
I3int = integralClosure(I^3)
isSubset(I3int, I2KH) --Briancon-Skoda counterexample for KH
isSubset(I3int, I2Hir) --not a counterexample for Hironaka closure

