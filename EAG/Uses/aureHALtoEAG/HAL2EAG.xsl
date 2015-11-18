<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:eag="http://www.archivesportaleurope.net/Portal/profiles/eag_2012/">

    <xsl:output method="xml" indent="yes"/>


    <xsl:template match="/">
        <eag:eag audience="external">
            <control>
                <!-- le recordId est requis. Il s'agit du code ISIL/ISO 15511. Il n'est pas mentionné dans la notice aureHAL. 
        J'ai récupéré le numéro RCR sur le sudoc, qui répertorie les centres de ressources, mais il n'y a pas d'URI associé, donc c'est un peu compliqué de le récupérer.-->
                <recordId>FR-543952309</recordId>
                <maintenanceAgency>
                    <agencyCode>
                        <!-- également requis. Il s'agit d'un identifiant pour le responsable de la création de la notice
                je mets HAL sans conviction-->
                        <xsl:value-of select="/str/org[1]/@xml:id"/>
                    </agencyCode>
                    <agencyName>HAL</agencyName>
                </maintenanceAgency>
                <maintenanceStatus>revised</maintenanceStatus>
                <maintenanceHistory>
                    <maintenanceEvent>
                        <agent/>
                        <agentType>human</agentType>
                        <eventDateTime standardDateTime="2014-10-24">2014-10-24</eventDateTime>
                        <eventType>revised</eventType>
                    </maintenanceEvent>
                </maintenanceHistory>
                <languageDeclarations>
                    <languageDeclaration>
                        <language languageCode="fre">français</language>
                        <script scriptCode="Latn">latin</script>
                    </languageDeclaration>
                </languageDeclarations>
                <sources>
                    <source href="https://aurehal.archives-ouvertes.fr/">
                        <sourceEntry>Accès unifié aux référentiels HAL</sourceEntry>
                    </source>
                    <source>
                        <objectXMLWrap>
                            <tei>
                                <ref type="url">http://poincare.univ-lorraine.fr/fr</ref>
                            </tei>
                        </objectXMLWrap>
                    </source>
                </sources>
            </control>
            <archguide>
                <identity>
                    <autform>
                        <xsl:value-of select="/str/org[1]/orgName"/>
                    </autform>
                    <parform>
                        <xsl:value-of select="/str/org[1]/orgName[@type = 'acronym']"/>
                    </parform>
                </identity>
                <desc>
                    <repositories>
                        <repository>
                            <geogarea>Europe</geogarea>
                            <location localType="visitors address">
                                <country>France</country>
                                <municipalityPostalcode>F-54001 NANCY Cedex</municipalityPostalcode>
                                <street>91, avenue de la Libération BP 454.</street>
                            </location>
                            <timetable>
                                <opening/>
                            </timetable>
                            <!-- Il n'y a pas l'information dans la notice aureHAL, donc j'ai donné par dégaut à l'attribut question (qui est requis) la valeur yes -->
                            <access question="yes"/>
                            <accessibility question="yes"/>
                        </repository>
                    </repositories>
                </desc>
            </archguide>
            <relations>
                <!-- L'attribut href est problématique ici, puisqu'il est censé décrire l'URI du lieu de ressource, et non pas sa description dans aureHAL -->
                <eagRelation eagRelationType="hierarchical-parent">
                    <relationEntry source="https://aurehal.archives-ouvertes.fr/structure/read/id/441569">CNRS</relationEntry>
                    <relationEntry>UMR7117</relationEntry>
                    <!--
                Je n'ai pas trouvé comment intégrer l'adresse des relations. Il y a assez peu d'options.
                
                <placeEntry countryCode="FR"></placeEntry>-->
                </eagRelation>
                <eagRelation eagRelationType="hierarchical-parent">
                    <relationEntry source="https://aurehal.archives-ouvertes.fr/structure/read/id/300292">Université Nancy 2</relationEntry>
                    <dateRange>
                        <fromDate/>
                        <toDate standardDate="2011-12-31">2011-12-31</toDate>
                    </dateRange>
                    <!--<placeEntry countryCode="FR"></placeEntry>-->
                </eagRelation>
                <eagRelation eagRelationType="hierarchical-parent">
                    <relationEntry source="https://aurehal.archives-ouvertes.fr/structure/read/id/413289">Université de Lorraine</relationEntry>
                    <relationEntry>UL</relationEntry>
                    <!--
                même commentaire que pour les adresses.
                <objectXMLWrap >
                <tei>
                    <ref type="url">http://www.univ-lorraine.fr/</ref>
                </tei>
            </objectXMLWrap>
             -->
                    <dateRange>
                        <fromDate standardDate="2012-01-01">2012-01-01</fromDate>
                        <toDate/>
                    </dateRange>
                    <!-- <placeEntry countryCode="FR">34 cours Léopold - CS 25233 - 54052 Nancy cedex</placeEntry>
                -->
                </eagRelation>
            </relations>
        </eag:eag>
    </xsl:template>
</xsl:stylesheet>
