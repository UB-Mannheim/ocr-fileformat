<?xml version="1.0" encoding="UTF-8"?>
<!-- https://github.com/altoxml/documentation/issues/1#issuecomment-219671094 -->
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0"
   xmlns:v2="http://www.loc.gov/standards/alto/ns-v2#"
   xmlns:v4="http://www.loc.gov/standards/alto/ns-v4#">
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>

   <!-- replace xsi:schemaLocation attribute -->
   <xsl:template match="@xsi:schemaLocation">
      <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/v2/alto-2-1.xsd</xsl:attribute>
   </xsl:template>

   <!-- replace namespace  -->
   <xsl:template match="v4:*">
      <xsl:element name="{local-name()}" namespace="http://www.loc.gov/standards/alto/ns-v4#">
         <xsl:apply-templates select="@* | node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="@IDNEXT">
     <xsl:attribute name="ZORDER">
       <xsl:value-of select="."/>
     </xsl:attribute>
   </xsl:template>

   <xsl:template match="v2:alto/@SCHEMAVERSION"/>
   <xsl:template match="v2:Page/@ACCURACY"/>
   <xsl:template match="v2:Page/@QUALITY_DETAIL"/>
   <xsl:template match="v2:TextLine/@CS"/>
   <xsl:template match="v2:Description"/>

</xsl:stylesheet>
