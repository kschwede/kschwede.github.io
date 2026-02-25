# Making documents more accessible in mathematics

This page discusses options to help make documents accessible, especially from the perspective of Mathematics.

Another excellent resource following:  [Yao‑Yuan Mao's page on accessibility for the physics department](https://yymao.github.io/accessibility/)

## Requirements

All documents must 
- have alt text on images (including equations)
- have all colorful content high contrast (and not use only color to highlight important text)
- be compatible with reading assistance software
- and more.

For more information see [University of Utah Accessibility Essentials](https://cte.utah.edu/instructor-education/accessibility-essentials/index.php).

## All documents

All documents need to use semantic markup commands, and text should be readable.  In particular:

### Do NOT

- Denote sections of text using bold or a larger font.
- Insert images of blocks of text (write the text).  

### Do

- Use headings in Word or Google Docs
- Use \section \subsection \begin{theorem} and \end{theorem} etc in LaTeX
- Use list structures built into whatever system you are using.

## LaTeX documents

There are new options to help automatically make LaTeX documents accessible.

### The LaTeX Tagged PDF Project

This option requires minimal changes to workflow.

- For more information see [The LaTeX Tagged PDF Project](https://latex3.github.io/tagging-project/).

- No matter what, you will need TeXLive 2025 or later.

There are two main ways to use this.

#### Option 1:  lualatex and MathML alt text

This option will automatically tag your pdf reasonably assuming semantic markup and a compatible document class and packages.  All equations will also be give MathML alt text which some screen readers can access.

The start of your document should look like this.

```latex
% !TEX program = lualatex
{
  lang        = en-US,
  pdfstandard = ua-2,
  pdfversion = 2.0,
  tagging=on,
  tagging-setup={math/setup={mathml-SE}}  
}
\documentclass{article} %or another class
%various other packges
\usepackage{unicode-math}
%more packages, etc
%%the rest of your document
%%use the \maketitle command
```

Then you need to compile this using lualatex (which will probably happen automatically if you didn't delete the line `% !TEX program = lualatex`).  
From the command line, you run `lualatex` instead of `pdflatex` and if all goes well it will create an accessible pdf.
If you are using overleaf, you may alternately change your compiler in `File`, `Settings`, `Compiler`.

For examples see:
- [Sample review sheet with mathml, article class](ReviewSheetMathML-ArticleClass.tex)
- [Sample worksheet with mathml, exam class](ReviewSheetMathML-ExamClass.tex)


#### Option 2:  pdflatex and latex source alt text

This will also automatically tag your pdf reasonably assuming semantic markup and a compatible document class and packages.  All equations will be given their LaTeX source as the alt text (your custom macros are there as well).

The start of your document should probably look like this

```latex
{
  lang        = en-US,
  pdfstandard = ua-2,
  pdfversion = 2.0,
  tagging=on,
  tagging-setup={math/alt/use}  
}
\documentclass{article} %or another class
%various other packges
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
%more packages, etc
%%the rest of your document
%%use the \maketitle command
```

Compile the document as normal with pdflatex.

For examples see:
- [Sample review sheet with math/alt/use, article class](ReviewSheetMathAltUse-ArticleClass.tex)
- [Sample worksheet with math/alt/use, exam class](ReviewSheetMathAltUse-ExamClass.tex)


#### Hints and warnings

- The built in canvas scanner cannot detect the mathml and will report your document is missing alt text if you use Option #1.  Compatible screen readers and pdf viewers can read the mathml though.
- lualatex sometimes compiles much more slowly than pdflatex, but any document tagging system will make your documents compile more slowly.
- You should use the `\maketitle` command to automatically title the pdf.  If you don't like the large spacing this produces, you can do things like:
    ```latex
    \title{\vspace{-1.5cm}My Title\vspace{-2cm}}
    \date{}
    \maketitle
    ```
- All your images need alt text.  In many cases this is done with an `alt` option
    ```latex
    \includegraphics[alt={Alt text for an image},scale=0.3]{MyImage.jpg}
    \begin{tikzpicture}[scale=.30,alt={a cool diagram}]
        \coordinate (A) at (0,0);
        \coordinate (B) at (1,1);    
        \draw (A)--(B);
    \end{tikzpicture}
    ```
- ChatGPT tends to be quite good at making alt text.  You can give it an image, a `tikz` diagram, or just your entire document.  
- Note `tikz-cd` is not compatible and will not compile if you use it, see [tikz-cd github issue](https://github.com/latex3/tagging-project/issues/30).  You can bypass the error as in the following minimal example provided by Matthew Bertucci.
    ```
        \DocumentMetadata{lang=en-US,tagging=on}
        \documentclass{article}
        \usepackage{tikz-cd}
        \AddToHook{env/tikzcd/begin}{\MathCollectFalse}
        \begin{document}
        \begin{tikzcd}[alt={some alt text}]
        A \ar[r] \ar[d] & B \ar[d] \\
        C \ar[r] & D
        \end{tikzcd}
        \end{document}
    ```
- `xypic` doesn't have optimal tagging [xypic github issue](https://github.com/latex3/tagging-project/issues/899).  You may need to load packages in a certain order.
    ```
        \usepackage{luatex85}
        \usepackage[all]{xy}
        \usepackage{unicode-math}
    ```
    In the future, we hope to provide some code below for adding alt text to xymatrix in the future.
- `enumitem` and `titlesec` are not compatible.  However, the [enumext package](https://ctan.org/pkg/enumext) has many replacement features.  In fact, there is even a new list implementation in LaTeX with new features.  See for instance [the example on Handling lists and other block structures](https://latex3.github.io/tagging-project/documentation/usage-instructions) at the LaTeX tagging project.
- `beamer` is not compatible at all. The [ltx-talk class](https://ctan.org/pkg/ltx-talk) can replace some features.

### LaTeXML

This option can produce html or epub files, which are widely viewed as more accessible than pdfs.  However, this tool can be more challenging to install and the output may require manual remediation.

- Check out [LaTeXML](https://math.nist.gov/~BMiller/LaTeXML/)
- For more discussion in the context of theses, see [UIC Math Thesis Template](https://github.com/juliusross1/Accessible-LaTeX-Thesis-Template)

It is fairly robust. It is was the arXiv uses to make html versions of preprints.

### Caveats

Both the LaTeX Tagged PDF Project and LaTeXML are only compatible with some packages and document classes, others may or may not even compile, or even if they do, they may break accessibility.

- [LaTeX Tagged PDF Compatible Classes and Packages](https://latex3.github.io/tagging-project/tagging-status/)

- [Included Bindings for LaTeXML](https://math.nist.gov/~BMiller/LaTeXML/manual/included.bindings/)


## Word documents 

We recommend you check out [University of Utah Accessibility Essentials](https://cte.utah.edu/instructor-education/accessibility-essentials/index.php) for general information.

# Checking document accessibility

The University of Utah provides several tools to help assess accessibility of documents.

- You can get Adobe Acrobat Pro, [Request access to adobe acrobat pro](https://software-catalog.app.utah.edu/adobe/creative-cloud/request), this can also help remediate documents.
    - From there, select the tool "Prepare for accessibility" then select "Check for accessibility".  
    - Untagged documents can be tagged.
        - Warning, retagging a document already tagged by LaTeX apparently produces worse tagging.
    - Alt text can be added to images missing pictures.
    - Titles can be added
- Use the UDOIT tool in Canvas.
    - Some issues can be remediated in the tool.
- Canvas' built in accessibility checker.
- AXE Monitor (which detects issues with pdfs on webpages)
