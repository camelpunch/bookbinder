<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xy="http://xyleme.com/xylink">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  <xsl:template match="/IA">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <xsl:apply-templates select="/IA/CoverPage/Title"/>
        <link href="http://docs.pivotal.io/stylesheets/master.css" rel="stylesheet" type="text/css" media="screen,print" />
        <link href="http://docs.pivotal.io/stylesheets/print.css" rel="stylesheet" type="text/css" media="print" />
      </head>
      <body>
        <div class="viewport">
          <div class="wrap">
            <div class="container">
              <main class="content content-layout" id="js-content" role="main">
                <a id="top"></a>
                <h1 class="title-container">
                  <xsl:value-of select="/IA/CoverPage/Title/text()"/>
                </h1>
                <xsl:apply-templates select="/IA/Lessons"/>
              </main>
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/IA/CoverPage/Title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Title">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/Title">
    <xsl:element name="h3">
      <xsl:attribute name="id">ref-<xsl:value-of select="../@xy:guid"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock//Href">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="@UrlTarget"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock//Xref">
    <xsl:element name="a">
      <xsl:attribute name="href">#ref-<xsl:value-of select="@InsideTargetRef"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
