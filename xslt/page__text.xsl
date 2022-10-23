<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pc="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15">
  <!-- rid of xml syntax: -->
  <xsl:output
      method="text"
      standalone="yes"
      omit-xml-declaration="yes"/>
  <!-- copy text element verbatim: -->
  <xsl:variable name="newline"><xsl:text>
</xsl:text>
  </xsl:variable>
  <!-- paragraph break -->
  <xsl:param name="pb" select="concat($newline,$newline)"/>
  <!-- line break -->
  <xsl:param name="lb" select="$newline"/>
  <!-- text order: by element or by explicit ReadingOrder (reading-order|document) -->
  <xsl:param name="order" select="'reading-order'"/>
  <!-- hierarchy level to extract text annotation from (region|line|word|glyph|highest) -->
  <xsl:param name="level" select="'highest'"/>
  <!-- use key mechanism for IDREFs, because XSD does not support id mechanism -->
  <xsl:key name="textRegion" match="pc:TextRegion" use="@id"/>
  <xsl:template match="pc:PcGts/pc:Page">
    <xsl:variable name="regions" select="//pc:TextRegion"/>
    <xsl:choose>
      <xsl:when test="starts-with($order, 'reading-order') and pc:ReadingOrder//*[@regionRef|@regionRefIndexed]">
        <xsl:call-template name="getrefs">
          <xsl:with-param name="group" select="pc:ReadingOrder/*"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$regions">
          <xsl:call-template name="getlines">
            <xsl:with-param name="region" select="."/>
          </xsl:call-template>
          <xsl:value-of select="$pb"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="getlines">
    <xsl:param name="region"/>
    <xsl:choose>
      <xsl:when test="$level='region' or $level='highest' and $region/pc:TextEquiv/pc:Unicode">
        <xsl:value-of select="$region/pc:TextEquiv[1]/pc:Unicode" disable-output-escaping="yes"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$region/pc:TextLine">
          <xsl:if test="position()>1">
            <xsl:value-of select="$lb"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$level='line' or $level='highest' and pc:TextEquiv/pc:Unicode">
              <xsl:value-of select="pc:TextEquiv[1]/pc:Unicode" disable-output-escaping="yes"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="pc:Word">
                <xsl:if test="position()>1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$level='word' or $level='highest' and pc:TextEquiv/pc:Unicode">
                    <xsl:value-of select="pc:TextEquiv[1]/pc:Unicode" disable-output-escaping="yes"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="pc:Glyph">
                      <xsl:value-of select="pc:TextEquiv[1]/pc:Unicode" disable-output-escaping="yes"/>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose> <!-- word level? -->
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose> <!-- line level? -->
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose> <!-- region level? -->
  </xsl:template>
  <xsl:template name="getrefs">
    <xsl:param name="group"/>
    <xsl:for-each select="$group/*">
      <xsl:sort select="@index" data-type="number"/>
      <!--<xsl:variable name="region" select="id(@regionRef|@regionRefIndexed)"/>-->
      <xsl:variable name="region" select="key('textRegion', @regionRef|@regionRefIndexed)"/>
      <xsl:if test="$region">
        <xsl:call-template name="getlines">
          <xsl:with-param name="region" select="$region"/>
        </xsl:call-template>
        <xsl:value-of select="$pb"/>
      </xsl:if>
      <!-- UnorderedGroup(Indexed) and OrderedGroup(Indexed): recurse -->
      <xsl:if test="contains(local-name(.), 'Group')">
        <xsl:call-template name="getrefs">
          <xsl:with-param name="group" select="."/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!-- override implicit rules copying elements and attributes: -->
  <xsl:template match="text()"/>
</xsl:stylesheet>
