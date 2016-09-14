<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.tei-c.org/ns/1.0"
   xpath-default-namespace="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

   <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

   <xsl:strip-space elements="*"/>

   <xsl:param name="input" as="xs:string"
      select="'iso15924-utf8-20160119.txt'"/>

   <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/>


   <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->

   <!-- Reading the text file $input into the string variable $input-text -->
   <xsl:variable name="input-text" as="xs:string" select="unparsed-text($input, $text-encoding)"/>

   <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->

   <!-- splitting the input into lines -->
   <xsl:variable name="lines" as="xs:string*" select="tokenize($input-text, '\r?\n')"/>

   <xsl:variable name="typedLines">
      <xsl:for-each select="$lines">
         <ab>
            <xsl:value-of select="."/>
         </ab>
      </xsl:for-each>
   </xsl:variable>

   <xsl:variable name="groupedLines">
     <xsl:for-each select="$typedLines/ab">
      <xsl:choose>
         <xsl:when test="starts-with(., '#')"/>
         <xsl:otherwise>
            <xsl:if test="normalize-space(.)">
               <xsl:variable name="split" select="tokenize(., ';')"/>
               <fs type="subtag">
                  <xsl:if test="normalize-space($split[1])">
                     <xsl:variable name="symbolValue">
                        <xsl:value-of select="$split[1]"/>
                     </xsl:variable>
                     <f name="code">
                        <symbol value="{$symbolValue}"/>
                     </f>
                  </xsl:if>
                  <xsl:if test="normalize-space($split[2])">
                     <xsl:variable name="numericValue">
                        <xsl:value-of select="$split[2]"/>
                     </xsl:variable>
                     <f name="number">
                        <numeric value="{$numericValue}"/>
                     </f>
                  </xsl:if>
                  <xsl:if test="normalize-space($split[3])">
                     <f name="englishName">
                        <string>
                           <xsl:value-of select="$split[3]"/>
                        </string>
                     </f>
                  </xsl:if>
                  <xsl:if test="normalize-space($split[4])">
                     <f name="frenchName">
                        <string>
                           <xsl:value-of select="$split[4]"/>
                        </string>
                     </f>
                  </xsl:if>
                  <xsl:if test="normalize-space($split[5])">
                     <f name="PVA">
                        <string>
                           <xsl:value-of select="$split[5]"/>
                        </string>
                     </f>
                  </xsl:if>
                  <xsl:if test="normalize-space($split[6])">
                     <f name="date">
                        <string>
                           <xsl:value-of select="$split[6]"/>
                        </string>
                     </f>
                  </xsl:if>
               </fs>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
   </xsl:variable>
   
   <xsl:template match="/">
      <TEI>
         <teiHeader>
            <fileDesc>
               <titleStmt>
                  <title>ISO 15924 - Codes for the representation of names of scripts</title>
                  <respStmt>
                     <resp>Editor</resp>
                     <name>Laurent Romary</name>
                     <name>Charles Riondet</name>
                  </respStmt>
                     <funder>Parthenos</funder>
               </titleStmt>
               <publicationStmt>
                  <distributor>
                     <name>Dariah</name>
                     <ref type="url">http://dariah.eu</ref>
                  </distributor>
                  <distributor>
                     <name>Parthenos</name>
                     <ref type="url">http://parthenos-project.eu</ref>
                  </distributor>
                  <availability>
                     <licence target="http://creativecommons.org/licenses/by/4.0/"
                        notBefore="2013-01-01">
                        <p>The Creative Commons Attribution 4.0 International (CC BY 4.0) Licence
                           applies to this document.</p>
                        <p>The material contained in this document must be quoted as follows:
                           <q>ISO 15924 - Codes for the representation of names of scripts</q>.</p>
                     </licence>
                  </availability>
               </publicationStmt>
               <sourceDesc>
                  <bibl>
                     <title>ISO 15924 - Codes for the representation of names of scripts</title>
                     <publisher>The Unicode Consortium</publisher>
                     <date>
                        <xsl:value-of select="current-date()"/></date>
                     <ref type="url"
                        >http://www.unicode.org/iso15924/codelists.html</ref>
                  </bibl>
               </sourceDesc>
            </fileDesc>
         </teiHeader>
         <text>
            <body>
               <div>
                  <head>Language subtags</head>
                  <xsl:copy-of select="$groupedLines"/>
               </div>
            </body>
         </text>
      </TEI>
   </xsl:template>


   <!-- cf. tokenize("XPath is fun", "\s+") Result: ("XPath", "is", "fun") -->
   <!-- Penser au parcours de tokens et à xsl:sequence
    <xsl:for-each select="tokenize(., ' \|')">
     <xsl:for-each select="tokenize(., '> ')">
       <td><xsl:sequence select="."/></td>
     </xsl:for-each>
    </xsl:for-each>
    -->
   <!-- eA propos xsl:sequence Michael Kay says in his "XSLT 2.0 and XPath 2.0 programmer's reference" about
        xsl:sequence: "This innocent looking instruction introduced in XSLT 2.0 has far reaching effects
        on the capability of the XSLT language, because it means that XSLT instructions and sequence 
        constructors (and hence functions and templates) become capable of returning any value allowed
        by the XPath data model. Without it, XSLT instructions could only be used to create new nodes in 
        a result tree, but with it, they can also return atomic values and references to existing nodes.".
 -->


   <!-- upconversion transforms -->

   <!-- XPath 2.0 offers three functions in its standard function library that perform regular expression processing. Specifically:
matches(): returns a boolean value indicating whether a particular string matches a regular expression.
replace(): replaces those substrings within a given string that match a regular expression, with a replacement string.
tokenize(): breaks a string into a sequence of substrings, based on finding delimiters or separators that match a given regular expression.
 -->

   <!-- XSLT 2.0 Programmer's Reference and XPath 2.0 Programmer's Reference  -->
   <!-- http://www.saxonica.com/papers/ideadb-1.1/mhk-paper.xml -->
   <!-- functions on strings http://www.w3schools.com/xpath/xpath%5Ffunctions.asp#string -->

   <!-- xsl:analyze-string, that logically takes four arguments: the string to be analyzed, a regex, an instruction to be executed to process substrings
        that match the regular expression, and an instruction to be executed to process substrings that don't match. -->
   <!-- example d'usage: http://stackoverflow.com/questions/15974377/parse-text-file-with-xslt -->


   <!-- Regex -->
   <!-- a{3,6} match between 3 and 6 occurances of a -->
   <!-- [abc]+ a or b or c; n times-->
   <!-- (abc)+ abc; n times -->
   <!-- matches(string, regex) -->
   <!-- replace(string, regex, replacement) -->
   <!-- tokenize(string, regex) -->
   <!-- <xsl:analyze-string> -->

</xsl:stylesheet>
