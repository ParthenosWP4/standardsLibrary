<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns="http://www.tei-c.org/ns/1.0"
   xpath-default-namespace="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="xs" version="2.0">

   <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

   <xsl:strip-space elements="*"/>

   <xsl:param name="input" as="xs:string"
      select="'http://www.iana.org/assignments/language-subtag-registry'"/>

   <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/>


   <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->

   <!-- Reading the text file $input into the string variable $input-text -->
   <xsl:variable name="input-text" as="xs:string" select="unparsed-text($input, $text-encoding)"/>

   <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->

   <!-- splitting the input into lines -->
   <xsl:variable name="lines" as="xs:string*" select="tokenize($input-text, '\r?\n')"/>
   <xsl:variable name="file-date" select="substring-after($lines[1], 'File-Date: ')"/>

   <xsl:variable name="typedLines">
      <xsl:for-each select="$lines">
         <ab>
            <xsl:value-of select="."/>
         </ab>
      </xsl:for-each>
   </xsl:variable>

   <xsl:variable name="groupedLines">
      <xsl:for-each-group select="$typedLines/ab" group-starting-with=".[starts-with(., 'Type')]">
         <xsl:choose>
            <xsl:when test=".[starts-with(., 'File-Date:')]"/>
            <xsl:otherwise>
               <fs type="subtag">
                  <xsl:for-each select="current-group()">
                     <xsl:choose>
                        <xsl:when test="starts-with(., 'Type')">
                           <f name="Type">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>
                        <xsl:when test="starts-with(., 'Subtag')">
                           <f name="subType">
                              <xsl:variable name="value"
                                 select="normalize-space(substring-after(., ':'))"/>
                              <symbol value="{$value}"/>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Tag')">
                           <f name="tag">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Preferred-Value')">
                           <f name="Preferred-Value">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Comments')">
                           <f name="Comments">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., '  ')"/>

                        <xsl:when test="starts-with(., 'Macrolanguage')">
                           <f name="Macrolanguage">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Description')">
                           <f name="Description">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                                 <xsl:for-each
                                    select="
                                       following-sibling::*[starts-with(., '  ')
                                       and preceding-sibling::*[not(starts-with(., '  '))][1] = current()]">
                                    <xsl:value-of select="."/>
                                 </xsl:for-each>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Deprecated')">
                           <f name="Deprecated">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Prefix')">
                           <f name="Preifx">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Added')">
                           <f name="Added">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test="starts-with(., 'Scope')">
                           <f name="Scope">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:when test=". = '%%'"/>


                        <xsl:when test="starts-with(., 'Suppress-Script')">
                           <f name="Supress-Script">
                              <string>
                                 <xsl:value-of select="normalize-space(substring-after(., ':'))"/>
                              </string>
                           </f>
                        </xsl:when>

                        <xsl:otherwise>
                           <xsl:message>
                              <xsl:value-of select="."/>
                           </xsl:message>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each>
               </fs>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each-group>
   </xsl:variable>

   <xsl:template match="/">
      <TEI>
         <teiHeader>
            <fileDesc>
               <titleStmt>
                  <title>IANA Language Subtag Registry</title>
                  <respStmt>
                     <resp>Editor</resp>
                     <name>Laurent Romary</name>
                     <name>Charles Riondet</name>
                  </respStmt>
                  <funder>Parthenos</funder>
                  <ref type="url">http://parthenos-project.eu</ref>
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
                              <q>IANA Language Subtag Registry</q>.</p>
                     </licence>
                  </availability>
               </publicationStmt>
               <sourceDesc>
                  <bibl>
                     <title>Language Subtag Registry</title>
                     <publisher>
                        <abbr>IANA</abbr>
                        <expan>Internet Assigned Numbers Authority</expan>
                     </publisher>
                     <date>
                        <xsl:value-of select="$file-date"/>
                     </date>
                     <ref type="url"
                        >http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry</ref>
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
