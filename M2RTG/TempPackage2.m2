newPackage(
    "TempPackage2",
    Version => "0.99",
    Date => "February 2nd, 1899",
    Authors => {
	{Name => "Cool Cat", Email => "cool.cat@utah.edu", HomePage => "http://www.math.utah.edu/~cat/"},
    {Name => "Smart Dog", Email => "smart.dog@utah.edu", HomePage => "http://www.math.utah.edu/~dog/"},
    {Name => "Fast Mouse", Email => "fast.mouse@utah.edu", HomePage => "http://www.math.utah.edu/~mouse/"}
    },
    Headline => "another example Macaulay2 package",
    Keywords => {"A word"},
    PackageExports => {"TestIdeals"},
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

thirdFunction = method(Options => {Function => null});
thirdFunction RR := opts -> r -> (
    if (opts.Function === null) then 
        exp(r)
    else(
        (opts.Function)(r)
    )
);

beginDocumentation()

doc ///
    Key
        TempPackage2
    Headline
        another temporary package
    Description
        Text
            Some text describing the package.  
    Acknowledgement
        Acknowledge funding sources or collaborators here.
    Contributors
        Acknowledge contributors who are not listed as authors here.
    References
        Provide references for further reading.
    Caveat
        This package is useless.
    SeeAlso
        firstFunction        
        secondFunction        
        [secondFunction, Strategy]
        thirdFunction
///

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

doc ///
    Key
        secondFunction
        [secondFunction, Strategy]
    Headline
        another function
    Usage
        l = secondFunction(r, Strategy=>m)
    Inputs
        r:QQ
            a rational number
        Strategy=>Thing
            a valid value for Strategy
    Outputs
        l:List   
            a list of values
    Description
        Text
            This text explains what the function does.
        Example
            n = 5/3
        Text
            This explains what the various strategy options are and how they work.
///

end--

You can write anything you want down here.  People like to keep examples
they are developing here.  Clean it up before submitting for
publication.  If you don't want to do that, you can omit the "end"
above.