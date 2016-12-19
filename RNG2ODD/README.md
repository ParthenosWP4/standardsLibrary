
This is to convert RelaxNG schema and documentation of XML formats that are not TEI, into TEI pure ODD.
Why?
...

Two files:
1) Transformation of RelaxNG schemas in pure ODD : RNG2ODD.xsl. This file should work more or less with any relaxNG file as input (at least, that's the goal).
2) A file to handle the documentation, whether it's in TEI, HTML, ... : doc2odd.xsl file, with a set of empty templates for every documentation elements in ODD, to be filled according to the documentation source file.
