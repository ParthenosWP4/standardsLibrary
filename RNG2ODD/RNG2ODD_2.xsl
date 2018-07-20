<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns:xhtml="http://www.w3.org/1000/xhtml" xml:lang="en" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:loc="http:/local-namespace/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xpath-default-namespace="http://relaxng.org/ns/structure/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">


    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="nl" select="'&#10;'"/>

    <!--ATTRIBUTES define independantly frm elements-->
    <xsl:template match="define[attribute]">
        <xsl:variable name="att-name" select="@name"/>
        <attDef ident="{$att-name}" xsl:exclude-result-prefixes="loc a xhtml xd">
            <!-- add the rng: prefix -->
            <xsl:copy-of select="attribute/*"/>
        </attDef>

    </xsl:template>

    <xsl:template match="element">
        <xsl:variable name="element-name" select="@name"/>
        <elementSpec ident="{$element-name}" module="EAC" xsl:exclude-result-prefixes="loc a xhtml xd">

            <content>
                <!-- Pulled from content.{@name} -->
                <xsl:for-each select="./*[not(self::a:documentation)]">
                    <!-- copy the rng <ref>s but handle ODD suffixes for references to models. -->
                    <xsl:call-template name="make-namespace-node">
                        <xsl:with-param name="handle-models" select="true()"/>
                        <xsl:with-param name="recursive" select="true()"/>
                    </xsl:call-template>
                </xsl:for-each>
                <!-- other refs in element declaration that are not contained in content.{@name} -->
                <xsl:for-each select="element/*[not(self::ref[starts-with(@name, 'attlist.') or starts-with(@name, 'content.')]) and not(self::a:documentation)]">
                    <xsl:call-template name="make-namespace-node">
                        <xsl:with-param name="handle-models" select="true()"/>
                        <xsl:with-param name="recursive" select="true()"/>
                    </xsl:call-template>
                </xsl:for-each>
            </content>

            <!-- Attributes -->
            <xsl:if test="ancestor::grammar//element[@name = $element-name]/descendant::attribute">
                <attList>
                    <!-- Pulled from attlist.{@name} -->

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
                            <xsl:choose>
                                <xsl:when test="data | ref">
                                    <datatype>
                                        <!-- N.B. attributes like @maxoccurs are available here, are they used for lists in PR's rng? -->
                                        <xsl:for-each select="data | ref">
                                            <xsl:call-template name="make-namespace-node">
                                                <xsl:with-param name="recursive" select="true()"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </datatype>
                                </xsl:when>

                                <!-- N.B. even closed lists can have a <datatype> specified in ODD -->
                                <xsl:when test="value">
                                    <defaultVal>
                                        <xsl:value-of select="value"/>
                                    </defaultVal>
                                    <valList type="closed">
                                        <valItem ident="{value}"/>
                                    </valList>
                                </xsl:when>
                                <xsl:when test="choice">
                                    <xsl:if test="@a:defaultValue">
                                        <defaultVal>
                                            <xsl:value-of select="@a:defaultValue"/>
                                        </defaultVal>
                                    </xsl:if>
                                    <valList>
                                        <xsl:attribute name="type">
                                            <xsl:choose>
                                                <xsl:when test="choice[not(text)]">
                                                    <xsl:text>closed</xsl:text>
                                                </xsl:when>
                                                <!-- not present in attribute definitions... -->
                                                <xsl:when test="choice[text]">
                                                    <xsl:text>semi</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:for-each select="choice/text">
                                            <xsl:call-template name="make-namespace-node"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="choice/value">
                                            <valItem ident="{.}"/>
                                        </xsl:for-each>
                                    </valList>
                                </xsl:when>
                            </xsl:choose>
                        </attDef>
                    </xsl:for-each>
                </attList>
            </xsl:if>

        </elementSpec>
    </xsl:template>

    <!-- 
    element|attribute[not(parent::define)]
    -->



    <!--    PROBABLY USELESS
        
    <!-\- ELEMENTS CHILD OF OTHER ELEMENT -\->
    <xsl:template match="element[not(parent::define)]">
        <xsl:variable name="element-name" select="@name"/>
        <elementSpec ident="{@name}" module="EAC" xsl:exclude-result-prefixes="loc a xhtml xd">
            <gloss type="test"><xsl:value-of select="$element-name"/></gloss>
        </elementSpec>
    </xsl:template>-->

    <!-- MAKE NAMESPACE NODE -> RNG: -->
    <xsl:template name="make-namespace-node">
        <xsl:param name="handle-models" select="false()"/>
        <xsl:param name="recursive"/>
        <!-- Ignoring leftover xhtml documentation -->
        <xsl:if test="not(self::*[namespace-uri() = 'http://www.w3.org/1999/xhtml'])">
            <xsl:element name="rng:{local-name(.)}" exclude-result-prefixes="loc a xhtml xd">
                <xsl:choose>
                    <!-- Handle ODD suffix if required -->
                    <xsl:when test="$handle-models">
                        <xsl:choose>
                            <xsl:when test="self::ref and starts-with(@name, 'model.')">
                                <xsl:variable name="this-mdl" select="@name"/>
                                <xsl:attribute name="name">
                                    <!-- Problem with combine interleave. If more than one, the name is repeated. Making sure to get only the first one for now -->
                                    <xsl:for-each select="ancestor::define[@name = $this-mdl][not(preceding::define[@name = $this-mdl])]">
                                        <!-- Determine suffix -->
                                        <xsl:variable name="mdlName">
                                            <xsl:value-of select="@name"/>
                                            <!--<xsl:choose>
                        <xsl:when test="starts-with(ancestor::loc:div/@name, 'shared')">
                          <xsl:value-of select="@name"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="concat(@name, '.', ancestor::loc:div/@name)"/>
                        </xsl:otherwise>
                      </xsl:choose>-->
                                        </xsl:variable>
                                        <xsl:choose>
                                            <!-- one element (no suffix) or choice (default behaviour) -->
                                            <xsl:when test="ref or choice">
                                                <xsl:value-of select="$mdlName"/>
                                            </xsl:when>
                                            <!--only one of the members (alternation)-->
                                            <!--<xsl:when test="choice">
                        <xsl:value-of select="@name"/>
                        <xsl:text>_alternation</xsl:text>
                      </xsl:when>-->
                                            <!-- members may be provided, in sequence, but are optional (sequenceOptional) -->
                                            <xsl:when test="optional and not(optional/*[not(self::ref)]) and not(zeroOrMore)">
                                                <xsl:value-of select="$mdlName"/>
                                                <xsl:text>_sequenceOptional</xsl:text>
                                            </xsl:when>
                                            <!-- members may be provided one or more times, in sequence, but are optional (sequenceOptionalRepeatable) -->
                                            <xsl:when test="zeroOrMore and not(zeroOrMore/*[not(self::ref)]) and not(optional)">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text>_sequenceOptionalRepeatable</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="zeroOrMore/choice and not(optional)">
                                                <xsl:value-of select="$mdlName"/>
                                            </xsl:when>
                                            <!-- If it doens't fit in any of the previous cases, it's a macro -->
                                            <xsl:otherwise>
                                                <xsl:text>macro.</xsl:text>
                                                <xsl:value-of select="substring-after(@name, 'model.')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:attribute>
                                <xsl:sequence select="@* except @name"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="@*"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Otherwise just copy all attributes -->
                    <xsl:otherwise>
                        <xsl:sequence select="@*"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- recursive? -->
                <xsl:choose>
                    <!-- ON -->
                    <!-- not(self::text()) condition is redundant and produces a warning with Saxon. -->
                    <xsl:when test="$recursive and *[not(self::text())]">
                        <xsl:for-each select="*[not(self::text())]">
                            <xsl:choose>
                                <!-- If ODD suffix handling is required, bring it forward in recursion -->
                                <xsl:when test="$handle-models">
                                    <xsl:call-template name="make-namespace-node">
                                        <xsl:with-param name="handle-models" select="true()"/>
                                        <xsl:with-param name="recursive" select="true()"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <!-- otherwise ignore it and keep going -->
                                <xsl:otherwise>
                                    <xsl:call-template name="make-namespace-node">
                                        <xsl:with-param name="recursive" select="true()"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- OFF -->
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/">

        <!-- Oxygen-specific link to TEI schema. -->
        <xsl:processing-instruction name="oxygen">
            <xsl:text>RNGSchema="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_odds.rng" type="xml"</xsl:text>
        </xsl:processing-instruction>

        <TEI xsl:exclude-result-prefixes="loc a xhtml xd">

            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>MEI (Music Encoding Initiative)</title>
                        <respStmt>
                            <resp>automated and manual editing</resp>
                            <name xml:id="RV">Raffaele Viglianti</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <p>Converted from RNG with XSLT script ../Styles/rng2odd.xsl</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>created on <xsl:value-of select="current-dateTime()"/></p>
                    </sourceDesc>
                </fileDesc>
                <revisionDesc>
                    <change who="#RV" when="{current-date()}"> Converted RNG Datatypes Declarations into ODD Datatype Macros according to TEI guidelines. <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/html/ST.html#DTYPES">Chapter 1, §1.4.2</ref>. </change>
                    <change who="#RV" when="{current-date()}"> Converted RNG Attribute Classes Declarations into ODD Attribute Classes according to TEI guidelines. <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/html/ST.html#STECAT">Chapter 1, §1.3.1</ref>. </change>
                    <change who="#RV" when="{current-date()}"> Converted RNG Model Classes Declarations into ODD Model Classes according to TEI guidelines. <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ST.html#STECCM">Chapter 1, §1.3.2</ref>. See also <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/TD.html#TDCLA">Chapter 22, §22.4.6</ref> for references to models. </change>
                    <change who="#RV" when="{current-date()}"> Converted RNG Model Classes Declarations into ODD Macro Classes (when appropriate) according to TEI guidelines. <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/TD.html#TDENT">Chapter 22, §22.4.7</ref>. </change>
                    <change who="#RV" when="{current-date()}"> Converted RNG Element Declarations into ODD Element Declarations according to TEI guidelines. <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/TD.html#TDcrystals">Chapter 22, §22.3</ref>. See also <ref
                            target="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/TD.html#TDCLA">Chapter 22, §22.4.6</ref> for references to models. </change>
                    <change who="#PR" when="{current-date()}">Changed order of content and attlist declarations, fixed problem generating @usage</change>
                    <change who="#RV" when="{current-date()}">Integrated Schematron rules within element declarations.</change>
                    <change who="#RV" when="{current-date()}">Integrated modules.</change>
                    <change who="#CR" when="{current-date()}">Adaptation for the EAC-CPF relaxNG schema</change>
                </revisionDesc>
            </teiHeader>
            <text>
                <front>
                    <divGen type="toc"/>
                </front>
                <body>
                    <p>EAC-CPF</p>
                    <!--
                    <!-\- DATATYPES -\->
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Datatype Macros</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Number of definitions found in original RNG: <xsl:value-of select="count(//define[starts-with(@name, 'data.')])"/>
            </xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:apply-templates select="//define[starts-with(@name, 'data.')]"/>

                    <!-\- ATTRIBUTES -\->
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Attribute Classes</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Number of definitions found in original RNG: <xsl:value-of select="count(//define[starts-with(@name, 'att.')])"/>
            </xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:apply-templates select="//define[starts-with(@name, 'att.')]"/>

                    <!-\-MODELS AND MACROS-\->
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Defintion of Model and Macro Classes</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Number of definitions found in original RNG: <xsl:value-of select="count(//define[starts-with(@name, 'model.')])"/>
            </xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:apply-templates select="//define[starts-with(@name, 'model.')]"/>-->

                    <!-- ELEMENTS -->
                    <!-- N.B. If the modularization of element, attlist.element and content.element
                            was done to facilitate the change of the element's name (i.e. for translations)
                            remember that it is possible to specify alternative names in ODD in <elementSpec>.
                            For this reason, this scripts re-joins them together -->
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Defintion of Model Classes</xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>Number of definitions found in original RNG: <xsl:value-of select="count(//define[starts-with(@name, 'model.')])"/>
                    </xsl:comment>
                    <xsl:value-of select="$nl"/>
                    <xsl:comment>****</xsl:comment>
                    <xsl:value-of select="$nl"/>




                    <xsl:apply-templates select="//element"/>


                    <!--                    <xsl:apply-templates select="//element[not(parent::define)]"/>-->

                    <classSpec ident="att.EAC" type="atts">
                        <attList>
                            <xsl:apply-templates select="//define[attribute]"/>
                            <xsl:apply-templates select="attribute"/>
                        </attList>
                    </classSpec>
                    <!--</schemaSpec>-->

                </body>
            </text>
        </TEI>

        <!-- CREATE STANDARD CUSTOMISATIONS -->
        <xsl:result-document href="../ODD/mei-all.xml">
            <xsl:processing-instruction name="oxygen">
                <xsl:text>RNGSchema="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="xml"</xsl:text>
            </xsl:processing-instruction>
            <TEI xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns="http://www.tei-c.org/ns/1.0" xsl:exclude-result-prefixes="loc a xhtml xd">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>EAC-CPF (Encoding archival context - Corporate bodies, persons, families)</title>
                            <respStmt>
                                <resp>Authored by</resp>
                                <name xml:id="CR">Charles Riondet</name>
                                <name xml:id="RV">Raffaele Viglianti</name>
                            </respStmt>
                        </titleStmt>
                        <publicationStmt>
                            <p>Automatically Generated</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>created on 2016-12-08</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <front>
                        <divGen type="toc"/>
                    </front>
                    <body>
                        <schemaSpec ident="odd" start="tei" ns="http://www.tei-c.org/ns/1.0"> </schemaSpec>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>

    </xsl:template>

</xsl:stylesheet>
