<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xml:lang="en" xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xpath-default-namespace="http://relaxng.org/ns/structure/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

    <xsl:output method="xml" indent="yes"/>


    <!-- Global variables for the schemaSpec element -->
    <xsl:variable name="elementStart">
        <xsl:value-of select="substring-after(/grammar/start/ref/@name, '.')"/>
    </xsl:variable>
    <xsl:variable name="schemaSpecId" select="'EAC-Schema'"/>
    <xsl:variable name="nameSpace">
        <xsl:value-of select="/grammar/@ns"/>
    </xsl:variable>

    <xsl:template match="/">

        <TEI xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title/>
                        <respStmt/>
                    </titleStmt>
                    <publicationStmt>
                        <p/>
                    </publicationStmt>
                    <sourceDesc>
                        <p>created on <xsl:value-of select="current-dateTime()"/></p>
                    </sourceDesc>
                </fileDesc>
                <revisionDesc>
                    <change when=""/>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                    <schemaSpec ident="{$schemaSpecId}" start="{$elementStart}" ns="{$nameSpace}">
                        <xsl:apply-templates select="//element" mode="#default"/>
                        <classSpec ident="atts.EAC" type="atts" module="EAC">
                            <attList>
                                <xsl:apply-templates select="//define[attribute]"/>
                            </attList>
                        </classSpec>
                        
                        <classSpec ident="atts.XML" type="atts" module="EAC">
                            <attlist>
                                
                                <!-- À transformer ici -->
                                <define name="lang" ns="http://www.w3.org/XML/1998/namespace">
                                    <attribute a:id="xmlLang" name="xml:lang">
                                        <choice>
                                            <data type="language"/>
                                            <value/>
                                        </choice>
                                    </attribute>
                                </define>
                                
                                <define name="base" ns="http://www.w3.org/XML/1998/namespace">
                                    <attribute a:id="xmlBase" name="xml:base">
                                        <data type="anyURI"/>
                                    </attribute>
                                </define>
                                
                                <define name="id" ns="http://www.w3.org/XML/1998/namespace">
                                    <attribute a:id="xmlID" name="xml:id">
                                        <data type="NCName">
                                            <!-- Because of restrictions in Relax NG, the expression of this attribute is NCName. 
							This is not strictly conformant to the xml:id specification, though necessary in order for
							to validate. The XML Schema version of this attribute should be defined as ID -->
                                        </data>
                                    </attribute>
                                </define>
                                <!-- À transformer ici -->
                                
                            </attlist>
                        </classSpec>

                    </schemaSpec>
                </body>
            </text>


        </TEI>
    </xsl:template>

    <!--ATTRIBUTES define independantly frm elements-->
    <xsl:template match="define[attribute]">
        <xsl:variable name="att-name" select="@name"/>
        <attDef ident="{$att-name}" xsl:exclude-result-prefixes="a">
            <!-- add the rng: prefix -->
            <xsl:copy-of select="attribute/*"/>
        </attDef>

    </xsl:template>
    
    <!-- EAC-CPF : xml:id, xml:lang, xml:base are not identified explicitly as attributes.
    Need of a template to handle that-->
    <xsl:template name="classXML" match="ref[@name='id']|ref[@name='lang']|ref[@name='base']">
        <classes>
            <memberOf key="atts.xml"/>
        </classes>
    </xsl:template>
    
    <!-- ref[starts-with(@name, '^e.$')] -->
    <xsl:template match="optional">
        <xsl:choose>
            <xsl:when test="ref/@name[starts-with(., '^e.$')]">
                <elementRef key="{substring-after(ref/@name, '.')}" minOccurs="0" maxOccurs="1"/>
            </xsl:when>
            <xsl:when test="element">
                <elementRef key="{element/@name}" minOccurs="0" maxOccurs="1"/>
            </xsl:when>
            <xsl:otherwise>
                <elementRef key="{ref/@name}" minOccurs="0" maxOccurs="1"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="zeroOrMore">
        <xsl:choose>
            <xsl:when test="element">
                <elementRef key="{element/@name}" minOccurs="0" maxOccurs="1"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="oneOrMore">
        <xsl:choose>
            <xsl:when test="element">
                <elementRef key="{element/@name}" minOccurs="0" maxOccurs="1"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="choice">
        <xsl:choose>
            <xsl:when test="element">
                <elementRef key="{element/@name}" minOccurs="0" maxOccurs="1"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="group">
        <xsl:choose>
            <xsl:when test="element">
                <xsl:call-template name="elementIsChild">
                    <xsl:with-param name="minOccursVal" select="0"/>
                    <xsl:with-param name="maxOccursVal" select="1"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="element" name="elementIsChild" mode="child">
        <xsl:param name="minOccursVal"/>
        <xsl:param name="maxOccursVal"/>
        <elementRef key="{@name}" minOccurs="{$minOccursVal}" maxOccurs="{$maxOccursVal}"/>
    </xsl:template>

    <xsl:template match="element" mode="#default">
        <xsl:variable name="element-name" select="@name"/>
        <elementSpec ident="{$element-name}" module="EAC" xsl:exclude-result-prefixes="a">
            <content>
                <xsl:apply-templates select="optional"/>
                <xsl:for-each select="element">
                    <xsl:call-template name="elementIsChild">
                        <xsl:with-param name="minOccursVal" select="1"/>
                        <xsl:with-param name="maxOccursVal" select="1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </content>

            <!-- Attributes -->
            <xsl:if test="ancestor::grammar//element[@name = $element-name]/descendant::attribute">
                <attList>
                    <xsl:for-each
                        select="
                            descendant::attribute[not(some $x in (current()/descendant::* intersect ./ancestor::*)
                                satisfies name($x) = 'element')]">
                        <attDef>
                            <xsl:attribute name="ident">
                                <xsl:choose>
                                    <xsl:when test="@name = 'id'">
                                        <xsl:text>xml:id</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@name"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="parent::optional">
                                    <xsl:attribute name="usage">opt</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="parent::define">
                                    <xsl:attribute name="usage">req</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            <desc>
                                <xsl:apply-templates select="a:documentation"/>
                            </desc>
                        </attDef>
                    </xsl:for-each>
                </attList>
            </xsl:if>

        </elementSpec>
    </xsl:template>
</xsl:stylesheet>
