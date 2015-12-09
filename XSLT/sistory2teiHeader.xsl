<?xml version="1.0" encoding="UTF-8"?>
<!-- Konverzija SIstory izvoza iz mySQL v TEI P5 -->
<!-- 2015-12-08 -->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    exclude-result-prefixes="fn tei">

    <!-- za izbrano delo se vpiše sistory identifikacijsko številko -->
    <xsl:param name="id">27204</xsl:param>
    <!-- ime in priimek osebe, ki bo pretvorila metapodatke v teiHeader -->
    <xsl:param name="vnesel">Andrej Pančur</xsl:param>
    <!-- ime osebe, ki preveri OCR v DOCX -->
    <xsl:param name="preverilOCR">Marta Rendla</xsl:param>
    <xsl:param name="digIzdajatelj">Inštitut za novejšo zgodovino, Zgodovina Slovenije - SIstory</xsl:param>
    <xsl:param name="opisProjekta">XML na portalu Zgodovina Slovenije - SIstory narejen v okviru izvajanja infrastrukturnega programa Inštituta za
        novejšo zgodovino</xsl:param>
    <!-- osnovni URL za publikacije -->
    <xsl:param name="baseURL">http://www.sistory.si/SISTORY:ID:</xsl:param>
    <!-- predpona za TEI @xml:id -->
    <xsl:param name="id-prefix">sistory.</xsl:param>

    <!-- jeziki in njih kode in imena -->
    <xsl:variable name="languages">
        <language n="1" xml:lang="slv" ident="slv">slovenski</language>
        <language n="1" xml:lang="eng" ident="slv">Slovenian</language>
        <language n="2" xml:lang="slv" ident="eng">angleški</language>
        <language n="2" xml:lang="eng" ident="eng">English</language>
        <language n="3" xml:lang="slv" ident="deu">nemški</language>
        <language n="3" xml:lang="eng" ident="deu">German</language>
        <language n="4" xml:lang="slv" ident="hbs">hrvaški/bosanski/srbski</language>
        <language n="4" xml:lang="eng" ident="hbs">Serbo-Croatian</language>
        <language n="5" xml:lang="slv" ident="srp">srbski - cirilica</language>
        <language n="5" xml:lang="eng" ident="srp">Serbian -  Cyrillic</language>
        <language n="6" xml:lang="slv" ident="fra">francoski</language>
        <language n="6" xml:lang="eng" ident="fra">French</language>
        <language n="7" xml:lang="slv" ident="spa">španski</language>
        <language n="7" xml:lang="eng" ident="spa">Spanish</language>
        <language n="8" xml:lang="slv" ident="ita">italijanski</language>
        <language n="8" xml:lang="eng" ident="ita">Italian</language>
        <language n="9" xml:lang="slv" ident="hun">madžarski</language>
        <language n="9" xml:lang="eng" ident="hun">Hungarian</language>
        <language n="10" xml:lang="slv" ident="lat">latinski</language>
        <language n="10" xml:lang="eng" ident="lat">Latin</language>
        <language n="11" xml:lang="slv" ident="rus">ruski</language>
        <language n="11" xml:lang="eng" ident="rus">Russian</language>
        <language n="12" xml:lang="slv" ident="pol">poljski</language>
        <language n="12" xml:lang="eng" ident="pol">Polish</language>
        <language n="13" xml:lang="slv" ident="ces">češki</language>
        <language n="13" xml:lang="eng" ident="ces">Czech</language>
        <language n="14" xml:lang="slv" ident="slk">slovaški</language>
        <language n="14" xml:lang="eng" ident="slk">Slovak</language>
        <language n="15" xml:lang="slv" ident="mul">večjezično</language>
        <language n="15" xml:lang="eng" ident="mul">Multiple languages</language>
        <language n="16" xml:lang="slv" ident="srp">srbski - latinica</language>
        <language n="16" xml:lang="eng" ident="srp">Serbian - Latin</language>
        <language n="17" xml:lang="slv" ident="hrv">hrvaški</language>
        <language n="17" xml:lang="eng" ident="hrv">Croatian</language>
        <language n="18" xml:lang="slv" ident="bos">bosanski</language>
        <language n="18" xml:lang="eng" ident="bos">Bosnian</language>
        <language n="19" xml:lang="slv" ident="mkd">makedonski</language>
        <language n="19" xml:lang="eng" ident="mkd">Macedonian</language>
        <language n="20" xml:lang="slv" ident="ara">arabski</language>
        <language n="20" xml:lang="eng" ident="ara">Arabic</language>
        <language n="21" xml:lang="slv" ident="bel">beloruski</language>
        <language n="21" xml:lang="eng" ident="bel">Belarusian</language>
        <language n="22" xml:lang="slv" ident="bul">bolgarski</language>
        <language n="22" xml:lang="eng" ident="bul">Bulgarian</language>
        <language n="23" xml:lang="slv" ident="dan">danski</language>
        <language n="23" xml:lang="eng" ident="dan">Danish</language>
        <language n="24" xml:lang="slv" ident="ell">moderni grški</language>
        <language n="24" xml:lang="eng" ident="ell">Modern Greek (1453-)</language>
        <language n="25" xml:lang="slv" ident="est">estonski</language>
        <language n="25" xml:lang="eng" ident="est">Estonian</language>
        <language n="26" xml:lang="slv" ident="fin">finski</language>
        <language n="26" xml:lang="eng" ident="fin">Finnish</language>
        <language n="27" xml:lang="slv" ident="fur">furlanski</language>
        <language n="27" xml:lang="eng" ident="fur">Friulian</language>
        <language n="28" xml:lang="slv" ident="heb">hebrejski</language>
        <language n="28" xml:lang="eng" ident="heb">Hebrew</language>
        <language n="29" xml:lang="slv" ident="lav">latvijski</language>
        <language n="29" xml:lang="eng" ident="lav">Latvian</language>
        <language n="30" xml:lang="slv" ident="lit">litvanski</language>
        <language n="30" xml:lang="eng" ident="lit">Lithuanian</language>
        <language n="31" xml:lang="slv" ident="nld">nizozemski</language>
        <language n="31" xml:lang="eng" ident="nld">Dutch</language>
        <language n="32" xml:lang="slv" ident="nor">norveški</language>
        <language n="32" xml:lang="eng" ident="nor">Norwegian</language>
        <language n="33" xml:lang="slv" ident="por">portugalski</language>
        <language n="33" xml:lang="eng" ident="por">Portuguese</language>
        <language n="34" xml:lang="slv" ident="jpn">japonski</language>
        <language n="34" xml:lang="eng" ident="jpn">Japanese</language>
        <language n="35" xml:lang="slv" ident="rom">romski</language>
        <language n="35" xml:lang="eng" ident="rom">Romany</language>
        <language n="36" xml:lang="slv" ident="ron">romunski</language>
        <language n="36" xml:lang="eng" ident="ron">Romanian</language>
        <language n="37" xml:lang="slv" ident="sqi">albanski</language>
        <language n="37" xml:lang="eng" ident="sqi">Albanian</language>
        <language n="38" xml:lang="slv" ident="swe">švedski</language>
        <language n="38" xml:lang="eng" ident="swe">Swedish</language>
        <language n="39" xml:lang="slv" ident="tur">turški</language>
        <language n="39" xml:lang="eng" ident="tur">Turkish</language>
        <language n="40" xml:lang="slv" ident="ukr">ukrajinski</language>
        <language n="40" xml:lang="eng" ident="ukr">Ukrainian</language>
        <language n="41" xml:lang="slv" ident="vec">beneški</language>
        <language n="41" xml:lang="eng" ident="vec">Venetian</language>
        <language n="42" xml:lang="slv" ident="wln">valonski</language>
        <language n="42" xml:lang="eng" ident="wln">Walloon</language>
        <language n="43" xml:lang="slv" ident="yid">jidiš</language>
        <language n="43" xml:lang="eng" ident="yid">Yiddish</language>
        <language n="44" xml:lang="slv" ident="zho">kitajski</language>
        <language n="44" xml:lang="eng" ident="zho">Chinese</language>
        <language n="45" xml:lang="slv" ident="zxx">brez jezikovne vsebine</language>
        <language n="45" xml:lang="eng" ident="zxx">No linguistic content</language>
        <language n="46" xml:lang="slv" ident="epo">esperanto</language>
        <language n="46" xml:lang="eng" ident="epo">Esperanto</language>
        <language n="47" xml:lang="slv" ident="chu">stara cerkvena slovanščina</language>
        <language n="47" xml:lang="eng" ident="chu">Church Slavic</language>
        <language n="48" xml:lang="slv" ident="grc">stara grščina (do 1453)</language>
        <language n="48" xml:lang="eng" ident="grc">Ancient Greek (to 1453)</language>
        <language n="49" xml:lang="slv" ident="hbo">stara hebrejščina</language>
        <language n="49" xml:lang="eng" ident="hbo">Ancient Hebrew</language>
        <language n="50" xml:lang="slv" ident="goh">stara visoka nemščina</language>
        <language n="50" xml:lang="eng" ident="goh">Old High German (ca. 750-1050)</language>
        <language n="51" xml:lang="slv" ident="gmh">srednja visoka nemščina</language>
        <language n="51" xml:lang="eng" ident="gmh">Middle High German (ca. 1050-1500)</language>
        <language n="52" xml:lang="slv" ident="gml">srednja spodnja nemščina</language>
        <language n="52" xml:lang="eng" ident="gml">Middle Low German</language>
        <language n="53" xml:lang="slv" ident="nds">spodnja nemščina</language>
        <language n="53" xml:lang="eng" ident="nds">Low German</language>
        <language n="54" xml:lang="slv" ident="san">sanskrt</language>
        <language n="54" xml:lang="eng" ident="san">Sanskrit</language>
        <language n="55" xml:lang="slv" ident="egy">staroegipščanski</language>
        <language n="55" xml:lang="eng" ident="egy">Egyptian (Ancient)</language>
        <language n="56" xml:lang="slv" ident="xve">venetski</language>
        <language n="56" xml:lang="eng" ident="xve">Venetic</language>
        <language n="57" xml:lang="slv" ident="xil">ilirski</language>
        <language n="57" xml:lang="eng" ident="xil">Illyrian</language>
        <language n="58" xml:lang="slv" ident="ang">stara angleščina</language>
        <language n="58" xml:lang="eng" ident="ang">Old English (ca. 450-1100)</language>
        <language n="59" xml:lang="slv" ident="enm">srednja angleščina</language>
        <language n="59" xml:lang="eng" ident="enm">Middle English (1100-1500)</language>
        <language n="60" xml:lang="slv" ident="fro">stara francoščina</language>
        <language n="60" xml:lang="eng" ident="fro">Old French (842-ca. 1400)</language>
        <language n="61" xml:lang="slv" ident="frm">srednja francoščina</language>
        <language n="61" xml:lang="eng" ident="frm">Middle French (ca. 1400-1600)</language>
        <language n="200" xml:lang="slv" ident="zzx">brez jezikovne vsebine</language>
        <language n="200" xml:lang="eng" ident="zzx">No linguistic content</language>
    </xsl:variable>	  	    	   	   	  	  	  	   	    	    	   	  	  	    	   	   	    	    	   	  	  	   	  	 	 	
    

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:key name="ID" match="publication" use="ID"/>

    <xsl:template match="root">
        <xsl:choose>
            <xsl:when test="normalize-space($id)">
                <xsl:apply-templates select="publication[ID = $id]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="publication"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="publication">
        <xsl:variable name="lang">
            <xsl:variable name="n" select="LANGUAGE[1]"/>
            <xsl:value-of select="$languages/tei:language[@n = $n]/@ident"/>
        </xsl:variable>
        <xsl:variable name="children">
            <xsl:apply-templates select="key('ID',CHILDREN/CHILD)" mode="ident">
                <xsl:sort select="CHILD_ORDER" data-type="number"/>
            </xsl:apply-templates>
        </xsl:variable>

        <TEI>
            <teiHeader xml:lang="slv">
                <fileDesc>
                    <titleStmt>
                        <xsl:apply-templates select="TITLE[@titleType='Title']"/>
                        <title xml:lang="slv" type="desc">Elektronska izdaja</title>
                        <xsl:apply-templates select="TITLE[@titleType='Alternative Title']"/>
                        <xsl:if test="$lang != 'eng' and normalize-space(TITLE[@titleType='Sistory:Title'][1])">
                            <xsl:apply-templates select="TITLE[@titleType='Sistory:Title']"/>
                            <title xml:lang="eng" type="desc">Electronic publication.</title>
                        </xsl:if>
                        <xsl:apply-templates select="CREATOR"/>
                        <xsl:apply-templates select="CONTRIBUTOR"/>
                        <respStmt>
                            <persName>
                                <xsl:value-of select="$vnesel"/>
                            </persName>
                            <resp>Kodiranje TEI in računalniški zapis</resp>
                        </respStmt>
                        <respStmt>
                            <persName>
                                <xsl:value-of select="$vnesel"/>
                            </persName>
                            <resp>Validacija meta-podatkov.</resp>
                        </respStmt>
                        <respStmt>
                            <persName>
                                <xsl:value-of select="$preverilOCR"/>
                            </persName>
                            <resp>Preverjanje in validacija OCR</resp>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <xsl:value-of select="$digIzdajatelj"/>
                        </publisher>
                        <idno type="URN">
                            <xsl:value-of select="concat($baseURL,ID)"/>
                        </idno>
                        <pubPlace>
                            <xsl:value-of select="concat($baseURL,ID)"/>
                        </pubPlace>
                        <pubPlace>https://github.com/SIstory/Sejni_zapiski</pubPlace>
                        <availability status="free">
                            <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                            <p>To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/"
                                >Creative Commons Priznanje avtorstva 4.0 International licenco</ref></p>
                        </availability>
                        <xsl:call-template name="date"/>
                    </publicationStmt>
                    <sourceDesc>
                        <biblStruct>
                            <xsl:apply-templates select="$children" mode="analytic"/>
                            <monogr>
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="concat($id-prefix,ID)"/>
                                </xsl:attribute>
                                <xsl:apply-templates select="CREATOR"/>
                                <xsl:apply-templates select="TITLE[@titleType='Title']"/>
                                <xsl:apply-templates select="TITLE[@titleType='Alternative Title']"/>
                                <xsl:if test="$lang != 'eng'">
                                    <xsl:apply-templates select="TITLE[@titleType='Sistory:Title']"/>
                                </xsl:if>
                                <imprint>
                                    <xsl:if test="contains(TITLE[@titleType='Title'][1], 'št.')">
                                        <biblScope unit="volume">
                                            <xsl:value-of select="substring-after(TITLE[@titleType='Title'][1],'št. ')"/>
                                        </biblScope>
                                    </xsl:if>
                                    <xsl:apply-templates select="PUBLISHER"/>
                                    <xsl:apply-templates select="DATE[@type='Date']"/>
                                </imprint>
                            </monogr>
                            <xsl:apply-templates select="COLLECTION"/>
                        </biblStruct>
                        <biblFull>
                            <xsl:attribute name="corresp">
                                <xsl:value-of select="concat('#',$id-prefix,ID)"/>
                            </xsl:attribute>
                            <titleStmt>
                                <xsl:apply-templates select="TITLE[@titleType='Title']"/>
                                <xsl:apply-templates select="TITLE[@titleType='Alternative Title']"/>
                                <xsl:if test="$lang != 'eng'">
                                    <xsl:apply-templates select="TITLE[@titleType='Sistory:Title']"/>
                                </xsl:if>
                            </titleStmt>
                            <publicationStmt>
                                <publisher>Državni zbor Republike Slovenije</publisher>
                                <xsl:apply-templates select="DATE[@type='Date']"/>
                                <availability status="free">
                                    <licence target="http://creativecommons.org/publicdomain/mark/1.0/"
                                        xml:lang="slv">Avtorske pravice so potekle, delo je v javni
                                        domeni.</licence>
                                    <licence target="http://creativecommons.org/publicdomain/mark/1.0/"
                                        xml:lang="eng">Public Domain Mark 1.0</licence>
                                </availability>
                            </publicationStmt>
                        </biblFull>
                    </sourceDesc>
                </fileDesc>
                <encodingDesc>
                    <projectDesc>
                        <p>
                            <xsl:value-of select="$opisProjekta"/>
                        </p>
                    </projectDesc>
                    <!-- Vključena classDecl/taxonomy -->
                    <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="../taxonomy.xml"/>]]></xsl:text>
                </encodingDesc>
                <profileDesc>
                    <langUsage>
                        <xsl:apply-templates select="LANGUAGE"/>
                    </langUsage>
                    <xsl:if test="SUBJECT_SLO | SUBJECT_ENG | $children[publication/SUBJECT_SLO] | $children[publication/SUBJECT_ENG]">
                        <textClass>
                            <xsl:if test="SUBJECT_SLO | SUBJECT_ENG">
                                <keywords>
                                    <list>
                                        <xsl:apply-templates select="SUBJECT_SLO"/>
                                        <xsl:apply-templates select="SUBJECT_ENG"/>
                                    </list>
                                </keywords>
                            </xsl:if>
                        </textClass>
                    </xsl:if>
                </profileDesc>
                <revisionDesc>
                    <change when="{current-date()}">
                        <name>
                            <xsl:value-of select="$vnesel"/>
                        </name>: kodiranje<list>
                            <item>//front//*</item>
                            <item>//div/@ana</item>
                            <item>//sp/@who</item>
                            <item>//stage</item>
                            <item>//head</item>
                            <item>//castList</item>
                            <item>//docDate</item>
                        </list>
                    </change>
                    <change when="{current-date()}">
                        <name>
                            <xsl:value-of select="$vnesel"/>
                        </name>
                        <xsl:text>: izvoz in preverjanje metapodatkov.</xsl:text></change>
                    <change when="{current-date()}">
                        <name>
                            <xsl:value-of select="$vnesel"/>
                        </name>: konverzija docx2tei </change>
                    <change when="{current-date()}">
                        <name>Andrej Pančur</name>: označil Header1 in TEI stil (tei:sp) za docx2tei konverzijo</change>
                    <change notAfter="{current-date()}">
                        <name>
                            <xsl:value-of select="$preverilOCR"/>
                        </name>: pregled in poprava OCR v DOCX</change>
                </revisionDesc>
            </teiHeader>

            <!-- element text sem dodal samo zaradi validacije - ODSTRANI -->
            <text>
                <body>
                    <ab>
                        <!-- besedilo članka -->
                    </ab>
                </body>
            </text>
        </TEI>
    </xsl:template>

    <!-- Izpis posameznih polj -->
    <xsl:template match="LANGUAGE">
        <xsl:variable name="n" select="."/>
        <xsl:variable name="lang" select="$languages/tei:language[@n = $n][@xml:lang='slv']"/>
        <xsl:variable name="lang_eng" select="$languages/tei:language[@n = $n][@xml:lang='eng']"/>
        <xsl:if test="not(normalize-space($lang))">
            <xsl:message terminate="yes">WARNING: Vstavite LANGUAGE!</xsl:message>
        </xsl:if>
        <language ident="{$lang/@ident}" xml:lang="slv">
            <xsl:value-of select="$lang"/>
        </language>
        <language ident="{$lang/@ident}" xml:lang="eng">
            <xsl:value-of select="$lang_eng"/>
        </language>
    </xsl:template>
    <xsl:template match="CREATOR">
        <author>
            <persName>
                <forename>
                    <xsl:value-of select="IME"/>
                </forename>
                <xsl:text> </xsl:text>
                <surname>
                    <xsl:value-of select="PRIIMEK"/>
                </surname>
            </persName>
        </author>
    </xsl:template>
    <xsl:template match="CONTRIBUTOR">
        <!-- preveč raznoliko v DC sistory,
            zato bo potrebno po pretvorbi urediti še ročno;
            išče prevajalce (najdi še druge) in jih da v respStmt:
            vse ostale da v editor; če je več oseb, jih ročno razdeli-->
        <xsl:choose>
            <xsl:when test="fn:matches(., '(prev\.)|(prevajalec)|(prevajalka)')">
                <respStmt>
                    <xsl:comment>Preveri!</xsl:comment>
                    <resp xml:lang="sl" key="translator">prevajalec</resp>
                    <persName>
                        <xsl:value-of select="."/>
                    </persName>
                </respStmt>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Preveri!</xsl:comment>
                <editor>
                    <xsl:value-of select="."/>
                </editor>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="TITLE[@titleType='Title']">
        <title>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="@lang"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::TITLE[@titleType='Title'])">main</xsl:when>
                    <xsl:otherwise>sub</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="level">m</xsl:attribute>
            <xsl:value-of select="."/>
        </title>
    </xsl:template>
    <xsl:template match="TITLE[@titleType='Sistory:Title']">
        <title xml:lang="eng" type="alt" level="m">
            <xsl:value-of select="."/>
        </title>
    </xsl:template>
    <xsl:template match="TITLE[@titleType='Alternative Title']">
        <title xml:lang="{@lang}" type="alt" level="m">
            <xsl:value-of select="."/>
        </title>
    </xsl:template>
    <xsl:template match="PUBLISHER">
        <xsl:choose>
            <xsl:when test="contains(., ',')">
                <pubPlace>
                    <xsl:value-of select="substring-after(.,', ')"/>
                </pubPlace>
                <publisher>
                    <xsl:value-of select="substring-before(.,',')"/>
                </publisher>
            </xsl:when>
            <xsl:otherwise>
                <publisher>
                    <xsl:value-of select="."/>
                </publisher>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="DATE[@type='Date']">
        <xsl:choose>
            <xsl:when test="contains(., '-01-01')">
                <date when="{substring-before(.,'-')}">
                    <xsl:value-of select="substring-before(.,'-')"/>
                </date>
            </xsl:when>
            <xsl:otherwise>
                <date when="{.}">
                    <xsl:value-of select="."/>
                </date>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="COPYRIGHT">
        <xsl:if test="contains(.,'nima soglasja avtorja')">
            <p>Uredništvo portala SIstory nima soglasja avtorja za objavo dela.</p>
        </xsl:if>
        <xsl:if test="contains(.,'/by-nc-nd/2.5/si/')">
            <licence target="http://creativecommons.org/licenses/by-nc-nd/2.5/si/">
                <xsl:text>Priznanje avtorstva-Nekomercialo-Brez predelav 2.5 Slovenija (CC BY-NC-ND 2.5 SI)</xsl:text>
            </licence>
        </xsl:if>
        <xsl:if test="contains(.,'/by-nc/2.5/si/')">
            <licence target="http://creativecommons.org/licenses/by-nc/2.5/si/">
                <xsl:text>Priznanje avtorstva-Nekomercialno 2.5 Slovenija (CC BY-NC 2.5 SI)</xsl:text>
            </licence>
        </xsl:if>
        <xsl:if test="contains(.,'/by/2.5/si/')">
            <licence target="http://creativecommons.org/licenses/by/2.5/si/">
                <xsl:text>Priznanje avtorstva 2.5 Slovenija (CC BY 2.5 SI)</xsl:text>
            </licence>
        </xsl:if>
        <xsl:if test="contains(.,'/by-nc-sa/2.5/si/')">
            <licence target="http://creativecommons.org/licenses/by-nc-sa/2.5/si/">
                <xsl:text>Priznanje avtorstva-Nekomercialno-Deljenje pod enakimi pogoji 2.5 Slovenija (CC BY-NC-SA 2.5 SI)</xsl:text>
            </licence>
        </xsl:if>
        <xsl:if test="contains(.,'/by-nd/2.5/si/')">
            <licence target="http://creativecommons.org/licenses/by-nd/2.5/si/">
                <xsl:text>Priznanje avtorstva-Brez predelav 2.5 Slovenija (CC BY-ND 2.5 SI)</xsl:text>
            </licence>
        </xsl:if>
        <xsl:if test="contains(.,'/by-sa/2.5/si/')">
            <licence target="http://creativecommons.org/licenses/by-sa/2.5/si/">
                <xsl:text>Priznanje avtorstva-Deljenje pod enakimi pogoji 2.5 Slovenija (CC BY-SA 2.5 SI)</xsl:text>
            </licence>
        </xsl:if>
        <xsl:if test="contains(.,'publicdomain')">
            <licence target="http://creativecommons.org/publicdomain/mark/1.0/" xml:lang="slv">
                <xsl:text>Avtorske pravice so potekle, delo je v javni domeni.</xsl:text>
            </licence>
            <licence target="http://creativecommons.org/publicdomain/mark/1.0/" xml:lang="eng">
                <xsl:text>Public Domain Mark 1.0</xsl:text>
            </licence>
        </xsl:if>
    </xsl:template>
    <xsl:template match="COLLECTION">
        <series>
            <title>
                <xsl:value-of select="."/>
            </title>
        </series>
    </xsl:template>
    <xsl:template match="SUBJECT_SLO">
        <item xml:lang="slv">
            <xsl:value-of select="."/>
        </item>
    </xsl:template>
    <xsl:template match="SUBJECT_ENG">
        <item xml:lang="eng">
            <xsl:value-of select="."/>
        </item>
    </xsl:template>
    <xsl:template match="SUBJECT[@subjectAttr='UDK']">
        <item xml:lang="{@lang}">
            <xsl:value-of select="."/>
        </item>
    </xsl:template>
    <xsl:template match="SUBJECT[@subjectAttr='ARRS']">
        <item xml:lang="{@lang}">
            <xsl:value-of select="."/>
        </item>
    </xsl:template>
    
    <xsl:template match="DESCRIPTION_SLO">
        <note type="description" xml:lang="slv">
            <xsl:value-of select="." disable-output-escaping="yes"/>
        </note>
    </xsl:template>
    <xsl:template match="DESCRIPTION_ENG">
        <note type="description" xml:lang="eng">
            <xsl:value-of select="." disable-output-escaping="yes"/>
        </note>
    </xsl:template>
    <xsl:template match="COVERAGE[@coverageType='Coverage']">
        <note type="coverage" xml:lang="{@lang}">
            <xsl:value-of select="."/>
        </note>
    </xsl:template>

    <!-- Procesiranje posameznih delov analitske ravni -->
    <xsl:template match="publication" mode="idno">
        <idno type="URN">
            <xsl:call-template name="corresp"/>
            <xsl:value-of select="URN"/>
        </idno>
    </xsl:template>
    <xsl:template match="publication" mode="availability">
        <availability>
            <xsl:call-template name="corresp"/>
            <xsl:call-template name="availability"/>
            <xsl:apply-templates select="COPYRIGHT"/>
        </availability>
    </xsl:template>
    <xsl:template match="publication" mode="description">
        <xsl:if test="DESCRIPTION_SLO">
            <note type="description" xml:lang="slv">
                <xsl:call-template name="corresp"/>
                <xsl:value-of select="DESCRIPTION_SLO" disable-output-escaping="yes"/>
            </note>
        </xsl:if>
        <xsl:if test="DESCRIPTION_ENG">
            <note type="description" xml:lang="eng">
                <xsl:call-template name="corresp"/>
                <xsl:value-of select="DESCRIPTION_ENG" disable-output-escaping="yes"/>
            </note>
        </xsl:if>
        <xsl:if test="COVERAGE[@coverageType='Coverage']">
            <note type="coverage" xml:lang="{@lang}">
                <xsl:call-template name="corresp"/>
                <xsl:value-of select="COVERAGE[@coverageType='Coverage']"/>
            </note>
        </xsl:if>
    </xsl:template>
    <xsl:template match="publication" mode="keywords">
        <xsl:if test="SUBJECT_SLO | SUBJECT_ENG">
            <keywords>
                <xsl:call-template name="corresp"/>
                <list>
                    <xsl:apply-templates select="SUBJECT_SLO"/>
                    <xsl:apply-templates select="SUBJECT_ENG"/>
                </list>
            </keywords>
        </xsl:if>
        <xsl:if test="SUBJECT[@subjectAttr='UDK']">
            <keywords scheme="#UDK">
                <xsl:call-template name="corresp"/>
                <list>
                    <xsl:apply-templates select="SUBJECT[@subjectAttr='UDK']"/>
                </list>
            </keywords>
        </xsl:if>
        <xsl:if test="SUBJECT[@subjectAttr='ARRS']">
            <keywords scheme="#ARRS">
                <xsl:call-template name="corresp"/>
                <list>
                    <xsl:apply-templates select="SUBJECT[@subjectAttr='ARRS']"/>
                </list>
            </keywords>
        </xsl:if>
    </xsl:template>
    <xsl:template match="publication" mode="languages">
        <langUsage>
            <xsl:call-template name="corresp"/>
            <xsl:apply-templates select="LANGUAGE"/>
        </langUsage>
    </xsl:template>
    <xsl:template match="publication" mode="analytic">
        <analytic>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($id-prefix,ID)"/>
            </xsl:attribute>
            <idno>
                <xsl:value-of select="URN"/>
            </idno>
            <xsl:apply-templates select="CREATOR"/>
            <xsl:apply-templates select="TITLE[@titleType='Title']" mode="article"/>
            <xsl:apply-templates select="TITLE[@titleType='Alternative Title']" mode="article"/>
            <xsl:variable name="lang">
                <xsl:variable name="n" select="LANGUAGE[1]"/>
                <xsl:value-of select="$languages/tei:language[@n = $n]/@ident"/>
            </xsl:variable>
            <xsl:if test="$lang != 'eng'">
                <xsl:apply-templates select="TITLE[@titleType='Sistory:Title']" mode="article"/>
            </xsl:if>
            <xsl:variable name="n" select="LANGUAGE"/>
            <xsl:variable name="lang" select="$languages/tei:language[@n = $n][@xml:lang='slv']"/>
            <xsl:variable name="lang_eng" select="$languages/tei:language[@n = $n][@xml:lang='eng']"/>
            <textLang xml:lang="slv" mainLang="{$lang[1]/@ident}">
                <xsl:if test="$lang[2]">
                    <xsl:attribute name="otherLangs">
                        <xsl:value-of select="$lang[position() &gt; 1]/@ident"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="string-join(($lang), ', ')"/>
            </textLang>
            <textLang xml:lang="eng" mainLang="{$lang[1]/@ident}">
                <xsl:if test="$lang[2]">
                    <xsl:attribute name="otherLangs">
                        <xsl:value-of select="$lang_eng[position() &gt; 1]/@ident"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="string-join(($lang_eng), ' &amp; ')"/>
            </textLang>
        </analytic>
    </xsl:template>
    <xsl:template match="TITLE[@titleType='Title']" mode="article">
        <title>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="@lang"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::TITLE[@titleType='Title'])">main</xsl:when>
                    <xsl:otherwise>sub</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="level">a</xsl:attribute>
            <xsl:value-of select="."/>
        </title>
    </xsl:template>
    <xsl:template match="TITLE[@titleType='Alternative Title']" mode="article">
        <title xml:lang="{@lang}" type="alt" level="a">
            <xsl:value-of select="."/>
        </title>
    </xsl:template>
    <xsl:template match="TITLE[@titleType='Sistory:Title']" mode="article">
        <title xml:lang="eng" type="alt" level="a">
            <xsl:value-of select="."/>
        </title>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="ident">
        <xsl:copy>
            <xsl:apply-templates mode="ident" select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Named templates for adding attributes -->
    
    <xsl:template name="corresp">
        <xsl:attribute name="corresp">
            <xsl:variable name="corresp">
                <xsl:choose>
                    <xsl:when test="ID">
                        <xsl:value-of select="ID"/>
                    </xsl:when>
                    <xsl:when test="../ID">
                        <xsl:value-of select="../ID"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">ERROR: Slab ID!</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat('#',$id-prefix,$corresp)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template name="availability">
        <xsl:variable name="licence-url" select="COPYRIGHT"/>
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="contains($licence-url,'publicdomain')">free</xsl:when>
                <xsl:when test="contains($licence-url,'nima soglasja avtorja')">restricted</xsl:when>
                <xsl:when test="contains($licence-url,'/by-nc-nd/2.5/si/')">restricted</xsl:when>
                <xsl:when test="contains($licence-url,'/by-nc/2.5/si/')">restricted</xsl:when>
                <xsl:when test="contains($licence-url,'/by/2.5/si/')">restricted</xsl:when>
                <xsl:when test="contains($licence-url,'/by-nc-sa/2.5/si/')">restricted</xsl:when>
                <xsl:when test="contains($licence-url,'/by-nd/2.5/si/')">restricted</xsl:when>
                <xsl:when test="contains($licence-url,'/by-sa/2.5/si/')">restricted</xsl:when>
                <xsl:otherwise>
                    <xsl:message>Can't find licence!</xsl:message>
                    <xsl:text>unknown</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
        
    <xsl:template name="date">
        <date when="{current-date()}">
            <xsl:value-of select="format-date(
                current-date(),
                '[D]. [M]. [Y]',
                'en',(),())"/>
        </date>
    </xsl:template>
</xsl:stylesheet>
