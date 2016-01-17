<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:date="http://exslt.org/dates-and-times"
    exclude-result-prefixes="xs tei"
    extension-element-prefixes="date"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Dodaj ime in primek osebe, ki izvaja kodiranje -->
    <xsl:param name="oseba">Andrej Pančur</xsl:param>
    
    <xsl:template match="@* | node()" mode="pass1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:docDate[parent::tei:div[@ana='#PAR.Seja'] | parent::tei:div[@ana='#PAR.Zasedanje']]" mode="pass1">
        <docDate>
            <xsl:apply-templates select="@*" mode="pass1"/>
            <xsl:apply-templates mode="pass1"/>
        </docDate>
        <timeline>
            <xsl:for-each select="parent::tei:div//tei:time[parent::tei:stage[@type='time']]">
                <xsl:variable name="numLevel-from">
                    <xsl:number count="tei:time[parent::tei:stage[@type='time']][@from]" level="any"/>
                </xsl:variable>
                <xsl:variable name="num">
                    <xsl:number value="$numLevel-from"/>
                </xsl:variable>
                <when>
                    <xsl:attribute name="synch">
                        <xsl:value-of select="concat('#',@xml:id)"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@from">
                            <xsl:attribute name="xml:id">
                                <xsl:value-of select="concat('TL.',$num)"/>
                            </xsl:attribute>
                            <xsl:attribute name="absolute">
                                <xsl:value-of select="@from"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@to">
                            <xsl:attribute name="absolute">
                                <xsl:value-of select="@to"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message terminate="yes">Manjka oznaka časa tei:stage/tei:time</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </when>
            </xsl:for-each>
        </timeline>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:timeline" mode="pass2">
        <timeline origin="{concat('#',tei:when[1]/@xml:id)}" unit="s">
            <xsl:for-each select="tei:when">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="time-diff-sec"
                            select="date:seconds(date:difference(preceding-sibling::tei:when[1]/@absolute, @absolute))" />
                        <when synch="{@synch}">
                            <xsl:attribute name="since">
                                <xsl:value-of select="concat('#',preceding-sibling::tei:when[1]/@xml:id)"/>
                            </xsl:attribute>
                            <xsl:attribute name="absolute">
                                <xsl:value-of select="@absolute"/>
                            </xsl:attribute>
                            <xsl:attribute name="interval">
                                <xsl:value-of select="$time-diff-sec"/>
                            </xsl:attribute>
                        </when>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </timeline>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc" mode="pass2">
        <revisionDesc>
            <change when="{current-date()}">
                <name><xsl:value-of select="$oseba"/></name>: kodiranje <list>
                    <item>//stage[@type='time']</item>
                    <item>//p/stage</item>
                    <item>//docDate</item>
                    <item>//timeline</item>
                </list>
            </change>
            <xsl:apply-templates mode="pass2"/>
        </revisionDesc>
    </xsl:template>
    
    <!-- Vključena classDecl/taxonomy -->
    <xsl:template match="tei:classDecl" mode="pass2">
        <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="../taxonomy.xml"/>]]></xsl:text>
    </xsl:template>
    
    
    <xsl:variable name="v-pass1">
        <xsl:apply-templates mode="pass1" select="/"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates mode="pass2" select="$v-pass1"/>
    </xsl:template>
    
    
</xsl:stylesheet>