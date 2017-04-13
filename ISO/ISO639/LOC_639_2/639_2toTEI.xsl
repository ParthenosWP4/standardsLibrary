<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
   xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

   <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

   <xsl:strip-space elements="*"/>

   <xsl:param name="input" as="xs:string" select="'ISO-639-2_utf-8.txt'"/>

   <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/>
   <xsl:param name="separator" select="'\|'"/>

   <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->

   <!-- Reading the text file $input into the string variable $input-text -->
   <xsl:variable name="input-text" as="xs:string"
      select="unparsed-text(normalize-space($input), $text-encoding)"/>

   <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->

   <!-- splitting the input into lines -->
   <xsl:variable name="lines" as="xs:string*" select="tokenize($input-text, '\r?\n')"/>
   <xsl:variable name="file-date" select="substring-after($lines[1], 'File-Date: ')"/>

   <xsl:variable name="structuredLines">
      <xsl:for-each select="$lines">
         <xsl:variable name="tokenizedLines" select="tokenize(., $separator)"/>
         <fs type="Subtag">
            <f name="threeLettersCode">
               <symbol value="{$tokenizedLines[1]}"/>
            </f>
            <xsl:if test="$tokenizedLines[3] != ''">
               <f name="twoLettersCode">
                  <symbol value="{$tokenizedLines[3]}"/>
               </f>
            </xsl:if>
            <f name="englishName">
               <string>
                  <xsl:value-of select="$tokenizedLines[4]"/>
               </string>
            </f>

            <f name="frenchName">
               <string>
                  <xsl:value-of select="$tokenizedLines[5]"/>
               </string>
            </f>
         </fs>
      </xsl:for-each>
   </xsl:variable>
   <xsl:template match="/">
      <TEI>
         <teiHeader>
            <fileDesc>
               <titleStmt>
                  <title type="main">ISO 629.2</title>
                  <title type="main">Codes for the Representation of Names of Languages</title>
                  <respStmt>
                     <resp>Editor</resp>
                     <name>Laurent Romary</name>
                     <name>Charles Riondet</name>
                  </respStmt>
                  <funder>Parthenos
                  <ref type="url">http://parthenos-project.eu</ref>
                  </funder>
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
                              <q>ISO639.2 Codes for the Representation of Names of
                           Languages</q>.</p>
                     </licence>
                  </availability>
               </publicationStmt>
               <sourceDesc>
                  <bibl>
                     <title>Codes for the Representation of Names of Languages</title>
                     <publisher>
                        <abbr>LOC</abbr>
                        <expan>Library of Congress</expan>
                     </publisher>
                     <date>2014-03-18</date>
                     <ref type="url" target="http://www.loc.gov/standards/iso639-2_utf-8.txt"/>
                  </bibl>
               </sourceDesc>
            </fileDesc>
         </teiHeader>
         <text>
            <body>
               <div>
                  <head>ISO 639 codes arranged alphabetically by alpha-3 code</head>
                  <xsl:copy-of select="$structuredLines"/>
               </div>
            </body>
         </text>
      </TEI>
   </xsl:template>
</xsl:stylesheet>
