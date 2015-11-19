<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:eag="http://www.archivesportaleurope.net/Portal/profiles/eag_2012/">
    <xsl:output method="xml" indent="yes"/>
    
    <!-- NB : Cette version 2 de l'XSL transforme l'ensemble de la notice générée par aureHAL, et non pas uniquement la partie TEI.
    Cela permet de récupérer des informations, commme la date de la dernière révision de la notice, ou encore le numéro d'identifiant de la notice
    Problème : la partie du code générée en TEI contient des caractères échappés pour les chevrons : &lt; et &gt;
    -->
    
    <xsl:template match="/">
        <eag:eag audience="external">           
            <!-- LR
                J’aimerais:
                - utiliser de façon conservatrice l’URL AureHal (https://aurehal.archives-ouvertes.fr/structure/read/id/1060 ?)
                - m’assurer quand dans AureHal on sache indiquer d’autres identifiants quand ils sont disponibles.
            -->
            <control>
                <!-- le recordId est requis. Il s'agit du code ISIL/ISO 15511. Il n'est pas mentionné dans la notice aureHAL. 
        J'ai récupéré le numéro RCR sur le sudoc, qui répertorie les centres de ressources, mais il n'y a pas d'URI associé, donc c'est un peu compliqué de le récupérer.-->
                <recordId>FR-543952309</recordId>
               <!-- C'est ici qu'à mon avis, le xml:id doit allern avec l'URI de la notice aureHAL éventuellement -->
               <otherRecordId source="https://aurehal.archives-ouvertes.fr/structure/read/id/1060">
                   <xsl:value-of select="/response/result/doc/str/org[1]/@xml:id"/>
               </otherRecordId>
                <otherRecordId>
                    <!-- On pourrait mettre ici le numéro IDref qui est présent dans certaines notices.-->
                    <xsl:value-of select="/response/result/doc/str/org[1]/idno[@type = 'IdRef']"/>
                </otherRecordId>
                <maintenanceAgency>
                   
                    <!-- HAL ou Parthenos? -->
                    <agencyCode>
                        <!-- également requis. Il s'agit d'un identifiant pour le responsable de la création de la notice
                je mets HAL sans conviction-->
                        <!-- CR : Ce n'est pas le bon code : agencyCode n'est pas pour la structure décrite (AHP, dont l'xml:id="struct-1060") mais pour l'agence de maintenance (HAL), 
                            qui n'apparaît pas dans le code TEI. C'est pourquoi j'avais renseigné HAL faute de mieux.
                            Vu qu'on exporte les notices de HAL, peut-on encoder en dur?
                    -->
                        HAL
                    </agencyCode>
                    <agencyName>Centre pour la Communcation scientfique directe (CCSD) - Hyper archives en ligne</agencyName>
                </maintenanceAgency>
                <!-- si Parthenos, alors ça doit généré à la volée -->
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
                    <!-- La langue n'est pas déclarée dans la source. Je laisse comme ça -->
                    <languageDeclaration>
                        <language languageCode="fre">français</language>
                        <script scriptCode="Latn">latin</script>
                    </languageDeclaration>
                </languageDeclarations>
                
                <!-- Idem -->
                <sources>
                    <source href="https://aurehal.archives-ouvertes.fr/">
                        <sourceEntry>Accès unifié aux référentiels HAL</sourceEntry>
                    </source>
                </sources>
                
                
            </control>
            <archguide>
                <identity>
                    <autform>
                        <xsl:value-of select="/response/result/doc/str/org[1]/orgName"/>
                    </autform>
                    <parform>
                        <xsl:value-of select="/response/result/doc/str/org[1]/orgName[@type = 'acronym']"/>
                    </parform>
                </identity>
                <desc>
                    <repositories>
                        <repository>
                            <!-- Comment transformer la valeur d'un élément en valeur d'un attribut? -->
                            <webpage href=""><xsl:value-of select="/response/result/doc/str/org[1]/desc/ref[@type = 'url']"/></webpage>
                            <location localType="visitors address">
                                
                                <!-- cela va afficher le coultry code -->
                                <country><xsl:value-of select="/response/result[1]/doc[1]/str[1]/org[1]/desc[1]/address[1]/country[1]/@key"/></country>
                                
                                <!-- Dans la source, l'adresse en encodée dans un élément unique, alors qu'ici il faut impérativement divisé en plusieurs sections
                                Je ne sais pas comment faire-->
                                <municipalityPostalcode>F-54001 NANCY Cedex</municipalityPostalcode>
                                <street>91, avenue de la Libération BP 454.</street>
                                
                            </location>
                            <timetable>
                                <opening/>
                            </timetable>
                            <!-- Il n'y a pas l'information dans la notice aureHAL, donc j'ai donné par défaut à l'attribut question (qui est requis) la valeur yes -->
                            <access question="yes"/>
                            <accessibility question="yes"/>
                        </repository>
                    </repositories>
                </desc>
            </archguide>
            <relations>
                <!-- Je suppose qu'il faut ici utiliser
                <xsl:for-each/>
               Il y a deux choses à relier :
                - premièrement un élément listRelation qui contient plusieurs relation, dont @active fait figure d'identifiant. On trouve également un @name qui est à reprendre.
                - ensuite des éléments org où la valeur de @xml:id est la même que celle de relation/@active et qui contiennent effectivement des informations à récupérer
                
                le problème est qu'EAG n'accepte pas d'attribut xml:id ou assimilé pour les éléments eagrelation
                -->
                <xsl:for-each select="/response/result[1]/doc[1]/str[1]/org[1]/listRelation[1]/relation">
                    <!-- Je récupère l'attribut @active, qui doit servir d'id -->
                    <xsl:value-of select="/response/result[1]/doc[1]/str[1]/org[1]/listRelation[1]/relation/@active"/>
                  <eagRelation eagRelationType="hierarchical-parent">
                      <relationEntry source="https://aurehal.archives-ouvertes.fr/structure/read/id/441569">
                          <xsl:value-of select="/response/result[1]/doc[1]/str[1]/org/orgName"/>
                      </relationEntry>
                      <relationEntry source="https://aurehal.archives-ouvertes.fr/structure/read/id/441569">
                          <xsl:value-of select="/response/result[1]/doc[1]/str[1]/org/listRelation/relation/@name"/>
                      </relationEntry>
                  </eagRelation>  
                </xsl:for-each>
                <!-- L'attribut href est problématique ici, puisqu'il est censé décrire l'URI du lieu de ressource, et non pas sa description dans aureHAL -->
                <eagRelation eagRelationType="hierarchical-parent">
                    
                    <relationEntry><xsl:value-of select="/response/result[1]/doc[1]/str[1]/org[1]/listRelation[1]/relation[1]/@name"/></relationEntry>
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
