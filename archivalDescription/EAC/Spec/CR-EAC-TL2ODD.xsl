<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2005/Xinclude"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
        

    <!-- template used as pre process to actually include <xi:include> in the Tag Library -->

    
    <xsl:template match="xi:include">
        <xsl:variable name="uri">
            <xsl:value-of select="@href"/>
        </xsl:variable>
        <xsl:copy-of select="document($uri)/div"/>
    </xsl:template>


    <!-- transform element div into <elementSpec> -->

    <xsl:template match="div[@type='elementDocumentation']">
        
        <xsl:message>LALALA</xsl:message>
        <xsl:variable name="ident_element" select="@xml:id"/>
        <elementSpec ident="{$ident_element}" module="EAC">

            <!-- gloss ok -->
            <!-- desc ok -->
            <!-- remarks ok -->
            
            <xsl:apply-templates select="div[@type='fullName']"/>
           
            <xsl:call-template name="summary"/>
            <xsl:call-template name="description"/>
            
            <!--  
        <classes>
            <memberOf key="att.EACGlobal"/>
        </classes>
        <content>
            <rng:text/>
        </content>
        <exemplum>
            <teix:egXML>
                <conventionDeclaration xmlns="-">
                    <abbreviation>RICA</abbreviation>
                    <citation>RICA (Regole italiane di catalogazione per
                        autore)</citation>
                </conventionDeclaration>
            </teix:egXML>
        </exemplum>
        <remarks>
            <p>It is recommended that the value be selected from an authorized list
                of codes. An example of such a list may be the MARC Code List
                (<ref>http://www.loc.gov/marc/relators/reladesc.html</ref>).</p>
        </remarks>-->
        </elementSpec>
    </xsl:template>

    <xsl:template match="div[@type = 'fullName']">
        <gloss>
            <xsl:value-of select="p"/>
        </gloss>
    </xsl:template>

    <xsl:template match="div[@type = 'summary']" name="summary">
        <desc>
            <xsl:value-of select="p"/>
        </desc>
    </xsl:template>

    <xsl:template match="div[@type = 'description']" name="description">
        <remarks>
            <xsl:value-of select="p"/>
        </remarks>
    </xsl:template>
    
    <!-- General identical copy template -->
    
    <xsl:template match="*|@*">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
