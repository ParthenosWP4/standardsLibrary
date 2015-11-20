<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:eag="http://www.archivesportaleurope.net/Portal/profiles/eag_2012/">
    <xsl:output method="xml" indent="yes"/>
 
    <xsl:template match="/">
        <eag:eag audience="external">           
            <!-- LR
        J’aimerais:
        - utiliser de façon conservatrice l’URL AureHal (https://aurehal.archives-ouvertes.fr/structure/read/id/1060 ?)
        - m’assurer quand dans AureHal on sache indiquer d’autres identifiants quand ils sont disponibles.
        
        - avoir un vrai export TEI d’AureHAL
        Concrètement, ça veut dire avoir un document TEI pour une transaction comme dans HAL
        (dans l’élément <body> et un <listOrg> avec l’ensemble des <org> nécessaires).
        Remarque: on peut ainsi envisager des exports groupés (e.g. toutes les équipes qui ont Inria comme institution parente …)
        - compléter la structure TEI avec des champs qui ne s’y trouve pas pour l’instant et dans la perspective du point précédent.
        -->
            <control>
                <recordId>
                    <xsl:value-of select="/str/org[1]/desc[1]/address[1]/country[1]/@key"/>-<xsl:value-of select="/str/org[1]/@xml:id"/>
                </recordId>
               <otherRecordId source="https://aurehal.archives-ouvertes.fr/structure/read/id/1060">
                   <xsl:value-of select="str/org[1]/@xml:id"/>
               </otherRecordId>
               
               <!-- Pour la maintenance, en attente des contacts avec HAL -->
                <maintenanceAgency>
                    <agencyCode>HAL</agencyCode>
                    <agencyName>Centre pour la Communcation scientfique directe (CCSD) - Hyper archives en ligne</agencyName>
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
                    <xsl:apply-templates select="idno"/>
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
                           <xsl:apply-templates select="/str/org[1]/desc"/>
                        </repository>
                    </repositories>
                </desc>
            </archguide>
            
            <relations>
                <xsl:apply-templates select="/str/org/listRelation/relation"/>
            </relations>
            
        </eag:eag>
    </xsl:template>
    
    <xsl:template match="idno">
        <repositorid countrycode="" repositorycody=""/> 
    </xsl:template>
    
    <!-- J'ai fait une tentative pour récupérer les relations avec une template.
    Je suis preneur de ta solution, car je coince (désolé c'est très basique)-->
    
    <xsl:template match="relation">
        <eagRelation eagRelationType="hierarchical-parent">
            <relationEntry source="">
                <xsl:value-of select="/str/org/orgName"/>
            </relationEntry>
            <relationEntry source="">
                <xsl:value-of select="/str/org/listRelation/relation/@name"/>
            </relationEntry>
        </eagRelation>
    </xsl:template>
    
    <xsl:template match="/str/org[1]/desc">
        <location localType="visitors address">
            <!-- cela va afficher le country code -->
            <country><xsl:value-of select="/str/org[1]/desc/address/country/@key"/></country>
            
            <!-- Dans la source, l'adresse en encodée dans un élément unique, alors qu'ici il faut impérativement divisé en plusieurs sections
                                Je ne sais pas comment faire.
            Pour le moment, j'affiche l'adresse complète dans les deux éléments-->
            <municipalityPostalcode><xsl:value-of select="/str/org[1]/desc/address/addrLine"/></municipalityPostalcode>
            <street><xsl:value-of select="/str/org[1]/desc/address/addrLine"/></street>    
        </location>
        <timetable>
            <opening/>
        </timetable>
        <!-- Il n'y a pas l'information dans la notice aureHAL, donc j'ai donné par défaut à l'attribut question (qui est requis) la valeur yes -->
        <access question="no"/>
        <accessibility question="no"/>
        <webpage href="{/str/org[1]/desc/ref[@type = 'url']}"><xsl:value-of select="/str/org[1]/desc/ref[@type = 'url']"/></webpage>
    </xsl:template>
</xsl:stylesheet>