<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="utf-8" indent="no"/>
  <xsl:template match="/IA">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <xsl:apply-templates select="/IA/CoverPage"/>
      </head>
      <body>
        <xsl:apply-templates select="/IA/Lessons"/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="/IA/CoverPage/Title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>
</xsl:stylesheet>
