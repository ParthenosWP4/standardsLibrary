Work based on an initiative by Raffaele Vigilanti for MEI (https://gist.github.com/raffazizzi/3237989) : 

```
I wrote this XSLT 2.0 for migrating the **MEI** schema specification (expressed in RelaxNG) into **TEI ODD**.

*The program creates ODD modules and determines which RelaxNG declarations fit better into an ODD *model* or a *macro*. The resulting organization is then reflected in the content of elementSpec declarations.
The user is given warnings and structured information about the decisions made by the program through <xsl:message> instructions.

The XSLT is specific to the source MEI schema specification, but large parts of it could be used to perform more generic RelaxNG to ODD transformations.*

I started working on this after promoting the use of ODD as a member of the MEI advisory board. Here is a [white paper](https://docs.google.com/document/d/1dZCTRnNU2yO6g_bMtwctnNUqvfgUL7ZOWrc8Oqefb7o/edit?pli=1) that I submitted to the rest of the board in 2010.

The ODD resulting from this conversion has since been edited by hand and has been adopted as main source for the new release of MEI (forthcoming in the next few weeks, see [annoucement](https://lists.uni-paderborn.de/pipermail/mei-l/2012/000626.html)).

I have also presented a paper about the motives for adopting ODD at the TEI Members Meeting 2010 in Zadar, Croatia ([slides](http://www.slideshare.net/rviglianti/making-mei-feel-odd)).
```

His original file is: [rng2odd.xsl](https://github.com/ParthenosWP4/standardsLibrary/tree/master/RNG2ODD/rng2odd.xsl)
My file is: [RNG2ODD_2.xsl](https://github.com/ParthenosWP4/standardsLibrary/tree/master/RNG2ODD/RNG2ODD_2.xsl)
