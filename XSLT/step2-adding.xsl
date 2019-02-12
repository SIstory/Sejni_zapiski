<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- Procesiraj s tem stilom.
         Potem popravi napačno procesirane actor/@xml:id
         Dodaj ročno predsedniku castList/castItem/*
         
         Procesiraj s DZ-addWho.xsl, da dodaš sp/@who
         Popravi potem ročno, kar ni bilo avtomatično dodano.
         Uredi ročno di/@ana
    
    -->
    
    <xsl:output method="xml"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type = 'contents']">
        <div type="contents">
            <head><xsl:value-of select="tei:head"/></head>
            <list rend="simple">
                <xsl:for-each select="tei:p">
                    <head><xsl:apply-templates/></head>
                </xsl:for-each>
                <item>
                    <xsl:for-each select="tei:div[1]">
                        <xsl:call-template name="seznam-kazalo"/>
                    </xsl:for-each>
                    <xsl:for-each select="tei:div[2]">
                        <xsl:call-template name="seznam-kazalo"/>
                    </xsl:for-each>
                </item>
            </list>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='speakers']">
        <div type="speakers">
            <xsl:for-each select="*">
                <xsl:choose>
                    <xsl:when test=".[self::tei:head]">
                        <head><xsl:apply-templates/></head>
                    </xsl:when>
                    <xsl:when test=".[self::tei:div]">
                        <castList>
                            <xsl:for-each select="*">
                                <xsl:choose>
                                    <xsl:when test=".[self::tei:head]">
                                        <head><xsl:apply-templates/></head>
                                    </xsl:when>
                                    <xsl:when test=".[self::tei:p]">
                                        <castItem>
                                            <xsl:analyze-string select="." regex="^(.*?)(\s)(.*?)(\s+\d.*)$" flags="m">
                                                <xsl:matching-substring>
                                                    <actor xml:id="sp.{regex-group(1)}{regex-group(3)}">
                                                        <xsl:value-of select="normalize-space(concat(regex-group(1),regex-group(2),regex-group(3)))"/>
                                                    </actor>
                                                    <xsl:for-each select="regex-group(4)">
                                                        <xsl:analyze-string select="." regex="\d+">
                                                            <xsl:matching-substring>
                                                                <ref>
                                                                    <xsl:value-of select="."/>
                                                                </ref>
                                                            </xsl:matching-substring>
                                                            <xsl:non-matching-substring>
                                                                <xsl:value-of select="."/>
                                                            </xsl:non-matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:for-each>
                                                </xsl:matching-substring>
                                                <xsl:non-matching-substring>
                                                    <xsl:value-of select="."/>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </castItem>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="{name()}">
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </castList>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{name()}">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template name="seznam-kazalo">
        <list rend="ordered">
            <head><xsl:value-of select="tei:head"/></head>
            <xsl:for-each-group select="*[not(self::tei:head)]" group-starting-with="tei:list">
                <xsl:variable name="items-list">
                    <xsl:for-each select="current-group()">
                        <xsl:choose>
                            <xsl:when test=".[self::tei:list]">
                                <xsl:apply-templates/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="{name(.)}">
                                    <xsl:apply-templates/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each-group select="$items-list/*" group-starting-with="tei:item">
                    <xsl:choose>
                        <!-- če item sledijo p -->
                        <xsl:when test="current-group()[self::tei:p]">
                            <xsl:for-each select="current-group()[self::tei:item]">
                                <item>
                                    <xsl:call-template name="tocka"/>
                                    <list rend="simple">
                                        <xsl:for-each select="current-group()[not(self::tei:item)]">
                                            <xsl:choose>
                                                <xsl:when test=".[self::tei:p]">
                                                    <xsl:choose>
                                                        <xsl:when test="matches(.,'[A-ZČŠŽ]+') and not(matches(.,'[a-zčšž]'))">
                                                            <head><xsl:apply-templates/></head>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <item>
                                                                <xsl:analyze-string select="." regex="(\d+)">
                                                                    <xsl:matching-substring>
                                                                        <ref><xsl:value-of select="."/></ref>
                                                                    </xsl:matching-substring>
                                                                    <xsl:non-matching-substring>
                                                                        <xsl:value-of select="."/>
                                                                    </xsl:non-matching-substring>
                                                                </xsl:analyze-string></item>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- procesira pb in podobno -->
                                                    <xsl:element name="{name()}">
                                                        <xsl:apply-templates/>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </list>
                                </item>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- če je samo item (in možno pb ipd.) -->
                        <xsl:otherwise>
                            <xsl:for-each select="current-group()">
                                <xsl:choose>
                                    <xsl:when test=".[self::tei:item]">
                                        <item>
                                            <xsl:call-template name="tocka"/>
                                        </item>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- procesira pb in podobno -->
                                        <xsl:element name="{name()}">
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </list>
    </xsl:template>
    
    <xsl:template name="tocka">
        <!-- TODO: kaj narediti, če je znotraj besedila pb -->
        <xsl:analyze-string select="." regex="^(\d+)(\.\s)(.*?)(\s)(\d+)$" flags="m">
            <xsl:matching-substring>
                <xsl:attribute name="n">
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:attribute>
                <xsl:value-of select="regex-group(3)"/>
                <xsl:value-of select="regex-group(4)"/>
                <ref><xsl:value-of select="regex-group(5)"/></ref>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>