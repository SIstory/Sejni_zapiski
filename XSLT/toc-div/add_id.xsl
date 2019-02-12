<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- Dodaj ime in primek osebe, ki izvaja kodiranje -->
    <xsl:param name="oseba">Andrej Pančur</xsl:param>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:item[ancestor::tei:div[@type='contents']][@n]">
        <xsl:variable name="numLevel">
            <xsl:number count="tei:item[parent::tei:list[parent::tei:div[@type='contents']]]" level="any"/>
        </xsl:variable>
        <xsl:variable name="num">
            <xsl:number value="$numLevel"/>
        </xsl:variable>
        <item>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat('toc.',$num,'.',@n)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </item>
    </xsl:template>
    
    <!-- še ni potrebno dodajati xml:id za div -->
    <xsl:template match="tei:div[ancestor::tei:body]">
        <xsl:variable name="numLevel">
            <xsl:number count="tei:div[ancestor::tei:body]"  format="1.1.1.1" level="multiple"/>
        </xsl:variable>
        <div>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat('div.',$numLevel)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <revisionDesc>
            <change when="{current-date()}">
                <name><xsl:value-of select="$oseba"/></name>: kodiranje <list>
                    <item>front/div[@type='contents']//item[@n]/@xml:id</item>
                    <item>body/div/div/div/div/@corresp</item>
                    <item>body//div/@xml:id</item>
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