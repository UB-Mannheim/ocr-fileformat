<?xml version="1.1" encoding="UTF-8"?>
<!--
Author:  Philipp Zumstein
License: MIT
-->
<xsl:stylesheet version="2.0" 
    xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="utf-8" indent="no" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*:Unicode">
    <xsl:value-of select="current()"/>
  </xsl:template>

  <xsl:template match="node()">
    <!-- Try to to the unicode text as soon as possible and then stop to going deeper in the tree. Otherwise there will be created the same text multiple times. -->
    <xsl:choose>
       <xsl:when test="./*:Unicode|./*:TextEquiv/*:Unicode">
         <xsl:apply-templates select="./*:Unicode|./*:TextEquiv/*:Unicode"/>
       </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Add space, new line or new page symbol when necessary. -->
    <xsl:choose>
      <xsl:when test="self::*:TextLine or self::*:TextRegion or self::*:TableRegion">
        <xsl:text>&#x0a;</xsl:text>
      </xsl:when>
      <xsl:when test="self::*:Word">
        <xsl:text>&#x20;</xsl:text>
      </xsl:when>
      <xsl:when test="self::*:Page">
        <xsl:text>&#x0c;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>