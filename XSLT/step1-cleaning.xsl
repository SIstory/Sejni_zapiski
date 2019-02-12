<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- Počistimo različne Word rend, ki so ostali po docx2tei transformaciji  -->
    <!-- Če boš pretvarjal z JSI (in ne z lastnim sistory) profilom aktiviraj spodnji template match tei:l[parent::tei:sp] -->
    <!-- S sistory2tei profilom dodaj teiHeader pred ali enkrat po tej pretvorbi (vseeno, kdaj to narediš). -->
    <!-- Po pretvorbi premakni kazali in seznam oseb v front in ju uredi v skladu s pretvorbo v step2:
         - uredi docTitle
         - v div type="contents" uredi ogrodje za pretvorbo kazala:
            - head (VSEBINA)
            - prvi p je head bodočega list, drugi p je drugi head bodočega list
            - PRED DNEVNIM REDOM in DNEVNI RED daj v ločena div (in jih označi kot head)
            - ostalo kopiraj in popravi:
                  - točke morajo biti znotraj list; 
                  - zadnja točka znotraj posameznega list ima seznam oseb v p takoj za list
         - v front/div[@type='speakers'] daj seznam govornikov:
             - v head[1] in head[2] naslove do GOVORNIKI
             - govornike daj v div (naslov head)
             - govornike pusti v odstavkih (popravi morebitne napake pri pretvorbah
          - v body uredi naslovni pred prvim sp
          - popravi napačne sp/speaker
          - dodaj sp/p/title za naslove v velikih tiskanih črkah
          - najdi in označi stage
    -->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!--<xsl:template match="tei:l[parent::tei:sp]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>-->
    
    <xsl:template match="tei:hi">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:seg">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>