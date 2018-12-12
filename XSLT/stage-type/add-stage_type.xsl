<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Dodaj ime in primek osebe, ki izvaja kodiranje -->
    <xsl:param name="oseba">Andrej Pančur</xsl:param>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Še ostali možni tipi:
        - time (datum in ura začetka in konca razprave)
        - location (Kratki govori iz klopi, ki so prekinili govor glavnega govorca, so označeni v sp/ab. Če je pred tem zapisano, iz kje (Iz klopi: ...) so govori potekali, se jih označi s stage[@type='location]'
        - comment (komentar zapisovalca magnetograma)
        - incident (nekomunikacijski dogodek)
        - kinesic (neverbalne kretnje s sporočilom)
        - writing (se pove, da nekdo nekaj bere)
        
        Spodnji tipi:
        - quorum (ugotovljena prisotnost poslancev)
        - vote (glasovanje poslancev)
        - debate (komentarji o poteku debate, npr. da se nihče ne javi k razpravi ipd.)
        - vocal (aplavz, smeh, kričanje ipd.)
        - gap (možen opis dveh situacij: 
            - nerazumljiv govor iz klopi (pogosteje),
            - nerazumljivi deli govora glavnega govorca (redkeje).
       
       Na koncu preveri vse zapise z vrednostjo type atributa vote.
       Pri tem upoštevaj pravilo: vote skoraj nikoli ni samo eden v odstavku.
       //stage[@type='vote'][not(preceding-sibling::stage[@type='vote'] or following-sibling::stage[@type='vote'])]
    -->
    <xsl:template match="tei:p/tei:stage">
        <stage>
            <xsl:if test="matches(.,'prisotn','i')">
                <xsl:attribute name="type">quorum</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'\d+') and not(matches(.,'prisotn','i')) and matches(.,'delegat|poslanc','i')">
                <xsl:attribute name="type">vote</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'dva\n?\s+delegat','i') or matches(.,'en\n?\s+delegat','i') or matches(.,'trije\n?\s+delegat','i') or matches(.,'štirje\n?\s+delegat','i') or matches(.,'pete\n?\s+delegat','i')">
                <xsl:attribute name="type">vote</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'nihče','i')">
                <xsl:attribute name="type">vote</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'Da\.') or matches(.,'Ne\.') or matches(.,'Ne\n?\s+želi') or matches(.,'Želi') or matches(.,'Tudi\n?\s+ne') or matches(.,'Umika')">
                <xsl:attribute name="type">debate</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'aplavz','i') or matches(.,'ploskanje','i') or matches(.,'smeh','i')">
                <xsl:attribute name="type">vocal</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'iz\sklopi','i') and string-length(.) lt 10">
                <xsl:attribute name="type">gap</xsl:attribute>
            </xsl:if>
            <xsl:if test="matches(.,'dialog','i') and string-length(.) lt 10">
                <xsl:attribute name="type">gap</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </stage>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <revisionDesc>
            <change when="{current-date()}">
                <name><xsl:value-of select="$oseba"/></name>: kodiranje <list>
                    <item>//p/stage/@type</item>
                </list>
            </change>
            <xsl:apply-templates/>
        </revisionDesc>
    </xsl:template>
    
    
    <!-- Vključena classDecl/taxonomy -->
    <xsl:template match="tei:classDecl">
        <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="../taxonomy.xml"/>]]></xsl:text>
    </xsl:template>
    
    
</xsl:stylesheet>