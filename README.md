# swift-metal-standard

Use this package to build source text in Metal's shading language from values, as a code generator does. Start from `Metal.Source` and its `text`. It neither reads Metal text nor compiles it, and it has nothing of the Metal framework: no device, queue or buffer. A file that also imports Apple's `Metal` module names these types as `Metal_Standard::Metal`.

## Laws

- Equal values give equal text, on every platform.
- A compound expression is put in parentheses wherever it is an operand, so the text means what the tree says without precedence.
- Integer literals are written unsigned with their width (`7u`, `7ul`), and a `float` literal as its bit pattern, so a constant survives exactly, NaN included.
- A name is written as it is given; the package does not check that names are declared, distinct or not reserved.
