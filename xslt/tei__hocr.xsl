<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:util="http://example/com/util/namespace"
  version="2.0"
  exclude-result-prefixes="xsl util"
  xmlns="http://www.w3.org/1999/xhtml">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"
              omit-xml-declaration="yes" />
  <xsl:param name="docTitle" select="'OCRed document'"/>
  <xsl:param name="langs" select="'de'"/>
  <xsl:param name="npages" select="1"/>
  <xsl:param name="scripts" select="'Latg'"/>
  <xsl:param name="system" select="'unknown'"/>
  <xsl:param name="width" />
  <xsl:param name="height" />

  <!-- converts comma-separated to space-separated coordinates -->
  <xsl:function name="util:coords">
    <xsl:param name="coords" />
    <xsl:value-of select="replace($coords, ',', ' ')" />
  </xsl:function>

  <!-- calculates bounding box of all nodes with attribute 'function' -->
  <xsl:function name="util:get-bbox">
    <xsl:param name="nodes" />
    <xsl:variable name="bbox">
      <xsl:for-each select="$nodes">
        <xsl:sort select="tokenize(./@function, ',')[1]" data-type="number" order="ascending" />
        <xsl:if test="position() = 1">
          <xsl:value-of select="tokenize(./@function, ',')[1]" />
        </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:for-each select="$nodes">
        <xsl:sort select="tokenize(./@function, ',')[2]" data-type="number" order="ascending" />
        <xsl:if test="position() = 1">
          <xsl:value-of select="tokenize(./@function, ',')[2]" />
        </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:for-each select="$nodes">
        <xsl:sort select="tokenize(./@function, ',')[3]" data-type="number" order="descending" />
        <xsl:if test="position() = 1">
          <xsl:value-of select="tokenize(./@function, ',')[3]" />
        </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:for-each select="$nodes">
        <xsl:sort select="tokenize(./@function, ',')[4]" data-type="number" order="descending" />
        <xsl:if test="position() = 1">
          <xsl:value-of select="tokenize(./@function, ',')[4]" />
        </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="normalize-space($bbox)" />
  </xsl:function>

  <!-- Start of transformation -->
  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:value-of select="$docTitle" />
        </title>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <meta name="ocr-system" content="{$system}" />
        <meta name="ocr-capabilities" content="ocr_page ocr_carea ocr_par ocr_line ocrx_word" />
        <meta name="ocr-langs" content="{$langs}" />
        <meta name="ocr-number-of-pages" content="{$npages}" />
        <meta name="ocr-scripts" content="{$scripts}" />
      </head>
      <xsl:apply-templates select=".//text" />
    </html>
  </xsl:template>

  <xsl:template match="text">
    <body>
        <xsl:apply-templates select=".//milestone" />
    </body>
  </xsl:template>

  <!-- Page -->
  <xsl:template match="milestone[@type='page']">
    <xsl:variable name="pageno" select="@n" />
    <xsl:variable name="pagenodes" select="//*[@function]" />
    <xsl:variable name="pagebox" select="util:get-bbox($pagenodes)" />
    
    <div class="ocr_page" id="page_{$pageno}" title="bbox {$pagebox}">
      <div class="ocr_carea" id="block_{$pageno}" title="bbox {$pagebox}">
        <xsl:apply-templates select="//p|//figure" />
      </div>
    </div>
  </xsl:template>

  <!-- Paragraph -->
  <xsl:template match="p">
    <xsl:variable name="pid" select="@id" />
    <p class="ocr_par" id="{$pid}">
      <xsl:apply-templates select="./w" />
    </p>
  </xsl:template>

  <!-- Word -->
  <xsl:template match="w">
    <xsl:variable name="bbox" select="util:coords(@function)" />
    <span class="ocrx_word" title="bbox {$bbox}">
      <xsl:value-of select="text()" />
    </span>
  </xsl:template>
  
  <!-- Figure -->
  <xsl:template match="figure">
    <xsl:variable name="bbox" select="util:coords(@function)" />
    <div class="ocr_float" title="bbox {$bbox}" />
  </xsl:template>

  <!-- Unmatched Elements -->
   <xsl:template match="*">
    <xsl:message terminate="no">
      WARNING: Unmatched element: <xsl:value-of select="name()"/>
    </xsl:message>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
