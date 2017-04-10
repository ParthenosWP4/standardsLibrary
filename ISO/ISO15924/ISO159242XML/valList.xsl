<?xml version="1.0" encoding="UTF-8"?>
<!--
    Charles Riondet (Inria)
    Parthenos project
    CC-BY
    
    This small stylesheet extracts the language codes in a tei:valList. This snippet can be then copied in ODD document  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <valList>
            <xsl:apply-templates select="//fs[@type='subtag']/f[@name='code']/symbol"/>    
        </valList>  
    </xsl:template>
    
    <xsl:template match="symbol">
        <xsl:variable name="Item"><xsl:value-of select="@value"/></xsl:variable>  
        <valItem ident="{$Item}"/>  
    </xsl:template>
</xsl:stylesheet>