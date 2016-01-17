<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:time[parent::tei:stage[@type='time']]">
        <xsl:variable name="numLevel">
            <xsl:number count="tei:time[parent::tei:stage[@type='time']]" level="any"/>
        </xsl:variable>
        <xsl:variable name="num">
            <xsl:number value="$numLevel"/>
        </xsl:variable>
        <time>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat('stage.t.',$num)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </time>
    </xsl:template>
    
    <!-- Vključena classDecl/taxonomy -->
    <xsl:template match="tei:classDecl">
        <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="../taxonomy.xml"/>]]></xsl:text>
    </xsl:template>
    
</xsl:stylesheet>