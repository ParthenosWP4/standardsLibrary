<?xml version="1.0" encoding="utf-8"?>
<!-- Schematron constraints extracted from the odd file EADspecEHRI.xml with the extractschematron stylesheet
    created by KCL departement of Digital Humanities for the Kiln project
    https://github.com/kcl-ddh/kiln/blob/master/webapps/ROOT/kiln/stylesheets/odd/extract-schematron.xsl -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:oxdoc="http://www.oxygenxml.com/ns/doc/xsl" queryBinding="xslt2">
    <title>ISO Schematron rules</title>
    <!--namespaces:-->
    <ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
    <sch:ns xmlns:sch="http://purl.oclc.org/dsdl/schematron" prefix="tei"
        uri="http://www.tei-c.org/ns/1.0"/>
    <!--constraints:-->
    <pattern id="archdesc-constraint-levelRequired">
        <rule context="ead:archdesc">
            <assert role="MUST-WP19" test="@level">archdesc MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-archdescLevelValues">
        <rule context="ead:archdesc">
            <assert role="COULD"
                test="@level = 'fonds' or @level = 'recordGrp' or @level = 'collection' or @level = 'otherlevel'"
                > The value of the archdesc level attribute SHOULD be 'fonds', 'recordGrp',
                'collection' ot 'otherlevel'.</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-orignationDesirable">
        <rule context="ead:archdesc">
            <assert role="COULD"
                test="ead:did/ead:origination and normalize-space(ead:did/ead:origination)">archdesc
                COULD have a non-empty origination</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-archdescProcessinfoDesirable">
        <rule context="ead:archdesc">
            <assert role="SHOULD-WP17" test="normalize-space(ead:processinfo)">archdesc-processinfo
                SHOULD not be empty</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-archdescProcessinfoDateDesirable">
        <rule context="ead:archdesc">
            <assert role="SHOULD-WP17" test="normalize-space(ead:processinfo/ead:p/ead:date)"
                >archdesc-processinfo SHOULD have a non empty date</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-langmaterialPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:did/ead:langmaterial">archdesc COULD have a
                langmaterial</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-custodhistPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:custodhist">archdesc COULD have a custodhist</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-otherfindaidPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:otherfindaid">archdesc COULD have an
                otherfindaid</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-originalslocPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:originalsloc">archdesc COULD have an
                originalsloc</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-altformavailPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:altformavail">archdesc COULD have an
                altformavail</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-bibliographyPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:bibliography">archdesc COULD have a bibliography</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-oddPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:odd">archdesc COULD have an odd</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-notePossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:note">archdesc COULD have a note</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-scopecontentPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:scopecontent">archdesc COULD have a scopecontent</assert>
        </rule>
    </pattern>
    <pattern id="archdesc-constraint-controlaccessPossible">
        <rule context="ead:archdesc">
            <assert role="COULD" test="ead:controlaccess">archdesc COULD have a
                controlaccess</assert>
        </rule>
    </pattern>
    <pattern id="c01-constraint-levelRequired">
        <rule context="ead:c01">
            <assert role="MUST-WP19" test="@level">c01 MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="c02-constraint-levelRequired">
        <rule context="ead:c02">
            <assert role="MUST-WP19" test="@level">c02 MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="c03-constraint-levelRequired">
        <rule context="ead:c03">
            <assert role="MUST-WP19" test="@level">c03 MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="c04-constraint-levelRequired">
        <rule context="ead:c04">
            <assert role="MUST-WP19" test="@level">c04 MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="c05-constraint-levelRequired">
        <rule context="ead:c05">
            <assert role="MUST-WP19" test="@level">c05 MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="c06-constraint-levelRequired">
        <rule context="ead:c06">
            <assert role="MUST-WP19" test="@level">c06 MUST have a level-attribute</assert>
        </rule>
    </pattern>
    <pattern id="change-constraint-dateNotEmpty">
        <rule context="ead:revisiondesc">
            <assert role="SHOULD-WP17" test="normalize-space(ead:date)">a revisiondesc SHOULD have a
                not empty date</assert>
        </rule>
    </pattern>
    <pattern id="controlaccess-constraint-controlaccessSubjectPossible">
        <rule context="ead:controlaccess">
            <assert role="COULD" test="ead:subject">controlaccess COULD have a subject</assert>
        </rule>
    </pattern>
    <pattern id="controlaccess-constraint-controlaccessPlacePossible">
        <rule context="ead:controlaccess">
            <assert role="COULD" test="ead:place">controlaccess COULD have a place</assert>
        </rule>
    </pattern>
    <pattern id="controlaccess-constraint-controlaccessPersnamePossible">
        <rule context="ead:controlaccess">
            <assert role="COULD" test="ead:persname">controlaccess COULD have a persname</assert>
        </rule>
    </pattern>
    <pattern id="controlaccess-constraint-controlaccessorgnamePossible">
        <rule context="ead:controlaccess">
            <assert role="COULD" test="ead:orgname">controlaccess COULD have a orgname</assert>
        </rule>
    </pattern>
    <pattern id="did-constraint-unitidRequired">
        <rule context="ead:did">
            <assert role="MUST-WP19" test="ead:unitid">a did MUST have a unitid, according 17.3 and
                WP19</assert>
        </rule>
    </pattern>
    <pattern id="did-constraint-unittitleRequired">
        <rule context="ead:did">
            <assert role="MUST-WP19" test="ead:unittitle">a did MUST have a unittitle, according
                17.3</assert>
        </rule>
    </pattern>
    <pattern id="did-constraint-unittitleNotEmpty">
        <rule context="ead:did">
            <assert role="MUST-WP19" test="count(ead:unittitle[text()]) &gt; 0">a did MUST have at
                least one non-empty unittitle</assert>
        </rule>
    </pattern>
    <pattern id="dsc-constraint-dscType">
        <rule context="ead:dsc">
            <assert role="MUST-EAD" test="@type">dsc MUST have a type attribute</assert>
        </rule>
    </pattern>
    <pattern id="dsc-constraint-dscothertype">
        <rule context="ead:dsc">
            <assert role="MUST-EAD"
                test="not(@type = 'othertype') or (@othertype and not(@othertype = ''))">dsc MUST
                have a type attribute</assert>
        </rule>
    </pattern>
    <pattern id="eadheader-constraint-profiledescRequired">
        <rule context="ead:eadheader">
            <assert role="MUST-WP19" test="ead:profiledesc">eadheader must contain a profiledesc
                element</assert>
        </rule>
    </pattern>
    <pattern id="eadheader-constraint-creationDateNotempty">
        <rule context="ead:eadheader">
            <assert test="ead:creation/ead:date and normalize-space(ead:creation/ead:date)"
                >eadheader COULD have a non-empty creation-date</assert>
        </rule>
    </pattern>
    <pattern id="eadid-constraint-mustContainText">
        <rule context="ead:eadid">
            <assert role="MUST-WP19" test="normalize-space(.)">eadid must contain text</assert>
        </rule>
    </pattern>
    <pattern id="eadid-constraint-creationDesirable">
        <rule context="ead:eadid">
            <assert role="SHOULD-WP17" test="@mainagencycode">eadid SHOULD contain a mainagencycode
                attribute</assert>
        </rule>
    </pattern>
    <pattern id="language-constraint-langcodeRequired">
        <rule context="ead:language">
            <assert role="MUST-WP19" test="@langcode">language MUST have a langcode
                attribute</assert>
        </rule>
    </pattern>
    <pattern id="language-constraint-scriptcodeRequired">
        <rule context="ead:language">
            <assert role="SHOULD-WP17" test="@scriptcode">language SHOULD have a scriptcode
                attribute</assert>
        </rule>
    </pattern>
    <pattern id="physdesc-constraint-nonemptyPhysdescDesirable">
        <rule context="ead:physdesc">
            <assert role="SHOULDWP17" test="normalize-space(ead:extent)">a did SHOULD have a
                non-empty physdesc-extent, according to 17.3</assert>
        </rule>
    </pattern>
    <pattern id="profiledesc-constraint-langusageRequired">
        <rule context="ead:profiledesc">
            <assert role="MUST-WP19" test="ead:langusage/ead:language">eadheader MUST contain a
                langusage/language element</assert>
        </rule>
    </pattern>
    <pattern id="profiledesc-constraint-creationDesirable">
        <rule context="ead:profiledesc">
            <assert role="SHOULD-WP17" test="ead:creation">eadheader should contain a creation
                element</assert>
        </rule>
    </pattern>
    <pattern id="publicationstmt-constraint-notempty">
        <rule context="ead:piblicationstmt">
            <assert role="SHOULD-WP17" test="ead:publisher">eadheader SHOULD specify a
                publisher</assert>
        </rule>
    </pattern>
    <pattern id="unitdate-constraint-labelDesirable">
        <rule context="ead:unitdate">
            <assert role="COULD-WP17"
                test="normalize-space(@label) or normalize-space(@encodinganalog)">unitdates COULD
                have a label, describing the type of date, according 17.3</assert>
        </rule>
    </pattern>
    <pattern id="unitdate-constraint-normalDesirableOrNotEmpty">
        <rule context="ead:unitdate">
            <assert role="COULD-WP17" test="text() or normalize-space(@normal)">unitdate should be
                not empty or have a non-empty @normal attribute</assert>
        </rule>
    </pattern>
    <pattern id="unitdate-constraint-normalNotEmtpy">
        <rule context="ead:unitdate">
            <assert role="SHOULD-WP19" test="normalize-space(@normal)">unitdate should have a
                non-empty @normal attribute</assert>
        </rule>
    </pattern>
    <pattern id="unitid-constraint-notEmpty">
        <rule context="ead:unitid">
            <assert role="SHOULD-WP17" test="not(ead:unitid = '')">a unitid SHOULD not be
                empty</assert>
        </rule>
    </pattern>
    <pattern id="unitid-constraint-uniqueId">
        <rule context="ead:unitid">
            <assert role="MUST-WP19"
                test="count(//ead:unitid[@label = 'ehri_main_identifier']) = count(distinct-values(//ead:unitid[@label = 'ehri_main_identifier']))"
                >unitid's MUST be unique within one eadfile, according 17.3</assert>
        </rule>
    </pattern>
    <pattern id="att.desc.c-constraint-otherlevel">
        <rule context="ead:ead">
            <assert role="MUST-EAD"
                test="not(@level = 'otherlevel') or (@otherlevel and not(@otherlevel = ''))">If the
                attribute level has the value 'otherlevel', an attribute otherlevel MUST be
                added</assert>
        </rule>
    </pattern>
    <pattern id="att.desc.c-constraint-levelFonds">
        <rule context="ead:ead">
            <assert role="SHOULD-WP19" test="not(@level = 'fonds') or name(.) = 'archdesc'">ONLY the
                archdesc can be fonds level</assert>
        </rule>
    </pattern>
    <pattern id="att.desc.c-constraint-recordgrplevel">
        <rule context="ead:ead">
            <assert role="SHOULD-WP19"
                test="not(@level = 'recordgrp') or (parent::*[@level = 'recordgrp'] or (name(.) = 'archdesc') or (name(.) = 'c01') and ancestor::*[@level = 'recordgrp'])"
                >recordgrp SHOULD be a child of another recordgrp</assert>
        </rule>
    </pattern>
    <pattern id="att.desc.c-constraint-subgrpLevel">
        <rule context="ead:ead">
            <assert role="SHOULD-WP19"
                test="not(@level = 'subgrp') or ((parent::*[@level = 'recordgrp' or @level = 'subgrp']) or (name(.) = 'c01') and ancestor::*[@level = 'recordgrp'])"
                >subgrp SHOULD be a child of another subgrp or a recordgrp</assert>
        </rule>
    </pattern>
    <pattern id="att.desc.c-constraint-subseriesLevel">
        <rule context="ead:ead">
            <assert role="SHOULD-WP19"
                test="not(@level = 'subseries') or parent::*[@level = 'subseries' or @level = 'series']"
                >subseries SHOULD be a child of another subseries or a series</assert>
        </rule>
    </pattern>
</schema>
