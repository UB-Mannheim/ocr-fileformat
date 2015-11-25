<?xml version="1.0" encoding="UTF-8"?>
<!--
Author:  Filip Kriz
Version: 1.0 25-11-2015
License: Creative Commons Attribution-ShareAlike 4.0 International.(CC BY-SA 4.0)
-->
<xsl:stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:mf="http://myfunctions" 
    xpath-default-namespace="http://www.loc.gov/standards/alto/ns-v2#" 
    exclude-result-prefixes="#all">

  <xsl:output method="xml" encoding="utf-8" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes" />
  <xsl:strip-space elements="*"/>
  <xsl:param name="language" />

  <xsl:template match="/">
        <html xml:lang="{$language}" lang="{$language}">
            <xsl:apply-templates/>
        </html>
  </xsl:template>
  
  <xsl:template match="Description">
    <head>
      <title>Image: <xsl:apply-templates select="sourceImageInformation"/></title>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <xsl:apply-templates select="OCRProcessing/ocrProcessingStep"/>
      <meta name='ocr-capabilities' content='ocr_page ocr_carea ocr_par ocr_line ocrx_word' />
    </head>
  </xsl:template>
  
  
  <xsl:template match="sourceImageInformation">
        <xsl:value-of select="fileName"/>
  </xsl:template>

 
  <xsl:template match="OCRProcessing/ocrProcessingStep">
      <meta name='ocr-system' content='{processingSoftware/softwareName} {processingSoftware/softwareVersion}' />
  </xsl:template>


  <xsl:template match="Styles">
  </xsl:template>

  
  <xsl:template match="Layout">
    <body>
        <xsl:apply-templates select="Page"/>
     </body>
  </xsl:template>
 
 
 <xsl:template match="Page">
    <xsl:variable name="fname"><xsl:value-of select="//alto/Description/sourceImageInformation/fileName"/></xsl:variable>
    <div class="ocr_page" id="{mf:getId(@ID,'page',.)}" title="image {$fname}; bbox 0 0 {@WIDTH} {@HEIGHT}; ppageno 0">
        <xsl:apply-templates select="PrintSpace"/>
     </div>
  </xsl:template>
  
  
 <xsl:template match="PrintSpace">
        <xsl:apply-templates select="ComposedBlock"/>
        <xsl:apply-templates select="TextBlock"/>
  </xsl:template>

 
 <xsl:template match="ComposedBlock">
    <div class="ocr_carea" id="{mf:getId(@ID,'block',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS)}">
         <xsl:apply-templates select="TextBlock"/>
     </div>
  </xsl:template>


 <xsl:template match="TextBlock">
    <p class="ocr_par" dir="ltr" id="{mf:getId(@ID,'par',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS)}" lang="{@language}{@LANG}">
        <xsl:apply-templates select="TextLine"/>
     </p>
  </xsl:template>


 <xsl:template match="TextLine">
    <span class="ocr_line" id="{mf:getId(@ID,'line',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS)}">
        <xsl:apply-templates select="String"/>
     </span>
  </xsl:template>


 <xsl:template match="String">
    <span class="ocrx_word" id="{mf:getId(@ID,'word',.)}" title="{mf:getBox(@HEIGHT,@WIDTH,@VPOS,@HPOS)}">
        <xsl:value-of select="@CONTENT"/>
     </span>
  </xsl:template>

  

<xsl:function name="mf:getBox">
    <xsl:param name="HEIGHT"/>
    <xsl:param name="WIDTH"/>
    <xsl:param name="VPOS"/>
    <xsl:param name="HPOS"/>
    <xsl:variable name="right" select="number($WIDTH) + number($HPOS)"/>
    <xsl:variable name="bottom" select="number($HEIGHT) + number($VPOS)"/>
    <xsl:value-of select="string-join(('bbox', $HPOS, $VPOS, string($right), string($bottom)),' ')"/>
</xsl:function>

<xsl:function name="mf:getId">
    <xsl:param name="ID"/>
    <xsl:param name="nodetype"/>
    <xsl:param name="node"/>
    
    <xsl:choose>
    <xsl:when test="$ID!=''">
          <xsl:value-of select="$ID"/>
    </xsl:when>
    <xsl:otherwise>
          <xsl:value-of select="concat($nodetype,'_',generate-id($node))"/>
    </xsl:otherwise>
    </xsl:choose>
</xsl:function>
  
  
</xsl:stylesheet>
