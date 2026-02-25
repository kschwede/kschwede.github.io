# Making documents more accessible in mathematics

This page summarizes practical steps for making math-heavy documents more accessible to students who use screen readers, magnifiers, alternative input devices, and other assistive technologies.

For a broader, campus-wide overview, see the [University of Utah Accessibility Essentials](https://cte.utah.edu/instructor-education/accessibility-essentials/index.php).

Another excellent resource (especially for STEM workflows) is [Yao‑Yuan Mao's accessibility page (Physics)](https://yymao.github.io/accessibility/).

Nothing on this document is legal advice.  It is simply information that may help improve accessibility.

---

## Key points

At a high level, the following are important.

1. **Use structure (semantic markup)**: real headings, real lists, real tables (not bold text pretending to be a heading).
2. **Never use images of text** (including screenshots of equations).
3. **Give every meaningful figure/diagram a text alternative** (use alt text and potentially a longer surrounding description, for ways to do this see [W3.org's suggestions](https://www.w3.org/WAI/tutorials/images/complex/#approach-2-describing-the-location-of-the-long-description-in-the-alt-attribute)).
4. **Don’t rely on color alone** to convey meaning; ensure **high contrast**.
5. **Export/produce a properly tagged PDF (if using LaTeX, provide the source code and/or provide HTML/EPUB)**.
6. **Check accessibility** we have built-in checkers (Canvas/UDOIT) and you can access Acrobat Pro.

---

## Requirements and expectations

All instructional documents must, at minimum:

- **Be readable as text** (not scanned images of text).
- Use **semantic structure**:
  - headings
  - lists
  - table structure (including header rows)
- Provide **text alternatives** for non-text content:
  - figures, plots, diagrams, screenshots
  - math (see options below if using LaTeX)
- Use **high contrast** and **not rely on color alone** to communicate meaning.
- Be compatible with **reading assistance software** (screen readers, magnifiers, text-to-speech).

For detailed guidance, see [University of Utah Accessibility Essentials](https://cte.utah.edu/instructor-education/accessibility-essentials/index.php).

---

## Guidance for all documents (Word, Google Docs, LaTeX, etc.)

Accessibility starts with authoring habits.

### Do NOT

- **Fake headings** by using bold, underline, or a larger font size.
- Insert **images of blocks of text** (including screenshots of a PDF page).
- Use **color alone** to indicate “important” content (e.g., “items in red are due next week”).

### Do

- Use built-in **heading styles** in Word/Google Docs (or `\section` and `\begin{theorem} ... \end{theorem}` type commands in LaTeX)
- Use built-in **list tools** (numbered/bulleted lists).
- Use meaningful **link text** (e.g., “Homework 3 (PDF)” instead of “click here”).
- If you include tables:
  - keep them simple when possible,
  - use header rows,

---

## Writing good alt text (especially for mathematical diagrams)

Alt text should communicate the *purpose* of the visual in context.

- **Keep it concise** when the figure is simple.
- If a full description is long, put the details in nearby text and keep alt text short (e.g., “See description in the paragraph below.”).
- For **graphs**: name axes/units, the main trend, and key features (intercepts, peaks, asymptotes, comparisons).
- For **diagrams** (commutative diagrams, geometry figures): describe the objects and relations (what maps to what; what is congruent; what is perpendicular), not just “a triangle.”

> Tip: AI tools can help draft alt text, but you must review it for correctness and for the course context.

---

## LaTeX documents

There are now workable options for producing more accessible PDFs from LaTeX, but compatibility still depends on your document class and packages.

Regardless, the [Center for Disability & Access (CDA)](https://disability.utah.edu/) asks that **all LaTeX** documents also have their source code uploaded.

### The LaTeX Tagged PDF Project

The LaTeX tagged PDF workflow requires a modern TeX distribution.

- Learn more: [The LaTeX Tagged PDF Project](https://latex3.github.io/tagging-project/)
- **Requirement:** TeX Live 2025 or later.

There are two common approaches.

---

### Option 1 (more accessible in some screen readers): LuaLaTeX + MathML tagging

This option aims for a properly tagged PDF and tags math using MathML (which some screen readers and PDF viewers can use effectively).

You need certain information **before** `\documentclass`:

```latex
% !TeX program = lualatex
\DocumentMetadata{
  lang        = en-US,
  pdfstandard = ua-2,
  tagging     = on,
  tagging-setup = { math/setup = {mathml-SE} }
}
\documentclass{article} % or another supported class
% various other packages
\usepackage{unicode-math} %%important
% more packages, etc.
\begin{document}
\title{Your title}
%\author{Your name or other information}
\date{} %%optional if you want to turn the date off 
\maketitle
% ... the rest of your document ...
\end{document}
```

Compile with `lualatex` (instead of `pdflatex`).

- If you do not delete the line `% !TeX program = lualatex` this may happen automatically
- Command line: run `lualatex <filename>.tex`
- Overleaf: set **File → Settings → Compiler → LuaLaTeX**

Examples:
- [Sample review sheet with MathML, article class](ReviewSheetMathML-ArticleClass.tex)
- [Sample worksheet with MathML, exam class](ReviewSheetMathML-ExamClass.tex)

---

### Option 2: pdfLaTeX + “LaTeX source” alt text for formulas

This option also tags the PDF, and it uses LaTeX source as a fallback text alternative for math. This can sometimes satisfy automated checkers better, but the spoken output may be less natural (and custom macros may appear verbatim).  

Again, put this **before** `\documentclass`:

```latex
\DocumentMetadata{
  lang        = en-US,
  pdfstandard = ua-2,
  tagging     = on,
  tagging-setup = { math/alt/use }  %%you can use both via tagging-setup = {math/alt/use, math/setup = {mathml-SE}}   but then only the latex code is read in the screen reader I have experimented with
}
\documentclass{article} % or another supported class
% various other packages
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
% more packages, etc.
\begin{document}
\title{Your title}
%\author{Your name or other information}
\date{} %%optional if you want to turn the date off 
\maketitle
% ... the rest of your document ...
\end{document}
```

Compile as normal with `pdflatex`.

Examples:
- [Sample review sheet with math/alt/use, article class](ReviewSheetMathAltUse-ArticleClass.tex)
- [Sample worksheet with math/alt/use, exam class](ReviewSheetMathAltUse-ExamClass.tex)

---

### LaTeX hints, warnings, and common fixes

#### Tool limitations (Canvas/LMS checkers)

- **Canvas’ built-in accessibility checker currently does not detect MathML math tagging** and may report “missing alt text” even when MathML is present.

#### Compilation time

- `lualatex` may compile more slowly than `pdflatex`.
- Any tagging workflow can slow compilation, especially on larger documents.

#### Titles and document metadata

- Use `\title{...}`, `\author{...}`, `\date{...}`, and `\maketitle` to populate visible title content.
- If you dislike the default spacing, adjust the title formatting carefully (avoid breaking structure). For example:

```latex
\title{\vspace{-1.5cm}My Title\vspace{-2cm}}
\date{}
\maketitle
```

#### Images and diagrams: add alt text (or mark decorative content)

All meaningful graphics must have alt text. Many commands support an `alt={...}` key:

```latex
\includegraphics[alt={Alt text for the image},scale=0.3]{MyImage.jpg}
```

For purely decorative images, prefer marking as an artifact so screen readers skip it:

```latex
\includegraphics[artifact,scale=0.3]{DecorativeRule.png}
```

TikZ examples (support may vary by setup; test with your workflow; `tikz`, `tikzpicture` and `picture` environment support the `[alt]` key):

```latex
\begin{tikzpicture}[scale=.30,alt={A line segment from A to B}]
  \coordinate (A) at (0,0);
  \coordinate (B) at (1,1);
  \draw (A)--(B);
\end{tikzpicture}
```

#### Tables: specify header rows 

If you include tables, identify header rows so screen readers can interpret them better:

See the examples here:  [Tagged PDF Usage Instructions - Handling Tables](https://latex3.github.io/tagging-project/documentation/usage-instructions).

#### Package compatibility notes

- `tikz-cd` is currently not compatible in some tagging workflows and may fail to compile.
  - See: [tikz-cd tagging issue](https://github.com/latex3/tagging-project/issues/30)
  - A workaround (from a minimal example by Matthew Bertucci):

```latex
\DocumentMetadata{lang=en-US,tagging=on}
\documentclass{article}
\usepackage{tikz-cd}
\AddToHook{env/tikzcd/begin}{\MathCollectFalse}
\begin{document}
\begin{tikzcd}[alt={A commutative square: A→B, A→C, B→D, C→D}]
A \ar[r] \ar[d] & B \ar[d] \\
C \ar[r] & D
\end{tikzcd}
\end{document}
```

- `xypic` may not tag optimally and may require package order adjustments.
  - See: [xypic tagging issue](https://github.com/latex3/tagging-project/issues/899)
  - Load order that may help:

```latex
\usepackage{luatex85}
\usepackage[all]{xy}
\usepackage{unicode-math}
```

  - Examples with alt text will be available in the future.

- `enumitem` and `titlesec` are not compatible.
  - Consider alternatives for `enumitem` like [enumext](https://ctan.org/pkg/enumext) which has many features.
  - See also examples under “Handling lists and other block structures” in the tagging docs:
    [LaTeX tagging project usage instructions](https://latex3.github.io/tagging-project/documentation/usage-instructions)

- `beamer` is not compatible at this time.
  - Consider the more limited [ltx-talk class](https://ctan.org/pkg/ltx-talk) for some talk/presentation workflows.

---

## LaTeXML (HTML/EPUB output)

LaTeXML can produce **HTML** or **EPUB**, which are often easier for assistive technology than PDF. Installation and output cleanup can be more demanding, and some documents require manual remediation.

- [LaTeXML](https://math.nist.gov/~BMiller/LaTeXML/)
- For thesis-related discussion/templates: [UIC Math Thesis Template](https://github.com/juliusross1/Accessible-LaTeX-Thesis-Template)

---

## Caveats: compatibility is not universal

Both the LaTeX Tagged PDF Project and LaTeXML are only compatible with some packages and document classes. Others may not compile, or may compile but yield poor accessibility.

- Tagged PDF compatibility list:
  [LaTeX Tagged PDF Compatible Classes and Packages](https://latex3.github.io/tagging-project/tagging-status/)

- LaTeXML bindings:
  [Included Bindings for LaTeXML](https://math.nist.gov/~BMiller/LaTeXML/manual/included.bindings/)

---

## Word documents

For general guidance, see:
[University of Utah Accessibility Essentials](https://cte.utah.edu/instructor-education/accessibility-essentials/index.php)

### Math equations in Word

- Use Word’s built-in **Equation Editor** (not screenshots).
- Add **alt text** to figures/plots/diagrams.
- Run Word’s **Accessibility Checker** (Review → Check Accessibility).
- It is probably better not to export to PDF.

---

## Checking document accessibility

The University of Utah provides several tools to help assess document accessibility.

### Adobe Acrobat Pro (PDF checking and remediation)

- Request access: [Request access to Adobe Acrobat Pro](https://software-catalog.app.utah.edu/adobe/creative-cloud/request)
- In Acrobat Pro:
  - Use “Prepare for accessibility” then “Check for accessibility”.
  - Untagged documents can be tagged.

> Warning: Re-tagging a PDF that was already tagged well (for example, by a LaTeX tagging workflow) will sometimes make the tagging worse. If possible, fix issues at the source document instead of re-tagging.

Acrobat can also:
- Add **alt text** to images missing alt text.
- Add or edit **document title metadata**.

### Canvas tools

- UDOIT in Canvas:
  - Training video: [UDOIT training video](https://mediaspace.utah.edu/media/t/1_7wzbzaa0/393149263)
  - Some issues can be remediated inside the tool.
- Canvas built-in accessibility checker:
  - Can detect some issues and fix some issues in-editor.

### Web scanning tools

- AXE Monitor (detects issues with PDFs linked on webpages)

