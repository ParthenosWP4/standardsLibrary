<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
    <sch:pattern>
        <sch:rule context="ead:c06">
            <sch:report role="SHOULD-WP11" test="ead:c07">C subelements SHOULD be between c01 and
                c06</sch:report>
            <!--ead:c07 or ead:c08 or ead:c09 or ead:c10 or ead:c11 or ead:c12s-->
        </sch:rule>
        <sch:rule context="ead:eadheader">
            <sch:assert test="ead:profiledesc/ead:langusage/@langcode = 'eng'">If the language of
                the description is not English, a parallel form of the title in English should be
                added.</sch:assert>
        </sch:rule>
        <sch:rule context="ead:archdesc">
            <sch:assert
                test="ead:scopecontent or ead:dsc/ead:c01/descendant-or-self::ead:scopecontent">a
                scopecontent element should be present at least in archdesc if not in the c
                elements</sch:assert>
            <sch:assert test="not(ead:acqinfo | ead:custodhist)">acqinfo and custodhit will be merged, according EHRI guidelines for description v1.0 (DL17.3)</sch:assert>
        </sch:rule>
        <sch:rule context="ead:profiledesc">
            <sch:assert test="not(normalize-space(ead:descrules))">descrules has a default value
                added automatically by EHRI.</sch:assert>
        </sch:rule>
        <sch:rule context="ead:unitdate">
            <sch:assert role="WP11" test="matches(@normal, '^(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$')">ISO8601</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
