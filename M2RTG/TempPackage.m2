newPackage(
    "TempPackage",
    Version => "0.2",
    Date => "August 5, 2012",
    Authors => {
	{Name => "Alpha Cat", Email => "alpha.cat@utah.edu", HomePage => "http://www.math.uiuc.edu/~cat/"}},
    Headline => "an example Macaulay2 package",
    Keywords => {"A word"},
    DebuggingMode => true,
    Reload=>true
    )

export {"firstFunction", 
"secondFunction"}

firstFunction = method(TypicalValue => String)
firstFunction ZZ := String => n -> if n == 1 then "Hello World!" else "Meow"

secondFunction = method(Options=>{Strategy => null});
secondFunction QQ := opts -> r -> (
    if opts.Strategy =!= null then
        (numerator r, denominator r)
    else
        (0, 0)
);

thirdFunction = method();
thirdFunction RR := r -> (
    exp(r)
);

beginDocumentation()

doc ///
    Key 
        firstFunction
        (firstFunction, ZZ)
    Headline
        our first function
    Usage
        firstFunction(n)
    Inputs
        n:
            an integer
    Outputs
        :
            a string depending on the input
    Description
        Text
            This is our first function
        Example
            firstFunction 1
            firstFunction 2
    SeeAlso
        secondFunction
///

TEST ///
    assert ( firstFunction 2 == "Meow" )
///



end--

You can write anything you want down here.  People like to keep examples
they are developing here.  Clean it up before submitting for
publication.  If you don't want to do that, you can omit the "end"
above.