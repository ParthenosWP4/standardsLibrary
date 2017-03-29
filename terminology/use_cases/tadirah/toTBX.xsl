<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="../resources/TBXinTEI/Schemas/TBXinTEI.rnc" type="application/relax-ng-compact-syntax"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="html"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:tbx="http://www.tbx.org"
    xmlns:html="http://www.w3.org/1999/xhtml">
 
    <xsl:param name="inpath"/>
    <xsl:param name="outpath"/>
    

    <!-- calling saxon with -it:main instead of input doc -->
    <xsl:template match="/" name="main">
        
        <xsl:variable name="entries_tmp">
            
            <xsl:for-each select="collection(concat($inpath, '?select=*.xml'))">
                <xsl:variable name="langcode" select="substring-before(tokenize(document-uri(.), '/')[last()],'.')"/>   <!-- get language code from filename -->
                
                <xsl:for-each-group select="/html:html/html:body/*" group-starting-with="html:h1">
                    
                    <xsl:variable name="topid" select="concat('c', position())"/>
                    <xsl:variable name="topterm">
                        <xsl:choose>
                            <xsl:when test="contains(current-group()[1], ' - ')">
                                <xsl:value-of select="substring-after(current-group()[1], ' - ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="current-group()[1]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="subs" select="current-group()[position() &gt; 1 and not(self::html:p)]"/>
                    
                    <xsl:for-each select="current-group()">
                        <xsl:choose>
                            <xsl:when test="self::html:h1">     <!-- entries for top-level concepts -->
                                
                                <termEntry>
                                    <xsl:attribute name="xml:id">
                                        <xsl:value-of select="$topid"/>
                                    </xsl:attribute>
                                    
                                    <langSet>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="$langcode"/>
                                        </xsl:attribute>
                                        
                                        <descrip type="definition">
                                            <xsl:value-of select="following-sibling::html:p[1]"/>
                                        </descrip>
                                        
                                        <tig>
                                            <tei:term>
                                                <xsl:value-of select="$topterm"/>
                                            </tei:term>
                                        </tig>
                                        
                                        <!-- references to subsumed concepts -->
                                        <xsl:for-each select="$subs">
                                            <xsl:variable name="subid" select="concat($topid, '_', position())"/>
                                            <xsl:variable name="subterm" select="."/>
                                            
                                            <tei:ref type="crossReference">
                                                <xsl:attribute name="target">
                                                    <xsl:value-of select="$subid"/>
                                                </xsl:attribute>
                                                
                                                <xsl:value-of select="$subterm"/>
                                            </tei:ref>
                                        </xsl:for-each>
                                                                                
                                    </langSet>
                                </termEntry>
                                
                            </xsl:when>
                            <xsl:when test="self::html:h2">         <!-- entries for subsumed concepts -->
                                
                                <xsl:variable name="subid" select="concat($topid, '_', position())"/>
                                <xsl:variable name="subterm" select="."/>
                                
                                <termEntry>
                                    <xsl:attribute name="xml:id">
                                        <xsl:value-of select="$subid"/>
                                    </xsl:attribute>
                                    
                                    <langSet>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="$langcode"/>
                                        </xsl:attribute>
                                        
                                        <descrip type="definition">
                                            <xsl:value-of select="following::html:p[1]"/>
                                        </descrip>
                                        
                                        <tig>
                                            <tei:term>
                                                <xsl:value-of select="$subterm"/>
                                            </tei:term>
                                        </tig>
                                        
                                        <tei:ref type="crossReference">
                                            <xsl:attribute name="target">
                                                <xsl:value-of select="$topid"/>
                                            </xsl:attribute>
                                            
                                            <xsl:value-of select="$topterm"/>
                                        </tei:ref>
                                        
                                    </langSet>
                                </termEntry>
                                
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                        
                    </xsl:for-each>     <!-- end for-each-group -->
                </xsl:for-each-group>   <!-- end for-each top-level -->
            </xsl:for-each>             <!-- end for-each input file -->
            
        </xsl:variable>
        
        
        <xsl:result-document href="{$outpath}" method="xml" encoding="utf-8" indent="yes">
            
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>TaDiRAH - Taxonomy of Digital Research Activities in the Humanities</title>
                        </titleStmt>
                        <publicationStmt>
                            <p>...</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>...</p>
                        </sourceDesc>
                    </fileDesc> 
                </teiHeader>
                
                <text>
                    <body>
                        <div>              
                            
                            <xsl:for-each-group select="$entries_tmp/termEntry" group-by="@xml:id">
                                
                                <termEntry>
                                    <xsl:attribute name="xml:id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    
                                    <xsl:copy-of select="current-group()//langSet"/>
                                </termEntry>
                                
                            </xsl:for-each-group>
                            
                        </div>
                    </body>
                </text>
            </TEI>
            
        </xsl:result-document>
        
    </xsl:template>

    
</xsl:stylesheet>