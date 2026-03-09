<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:wx="https://example.com/workspace-export">
  <xsl:output method="text" encoding="UTF-8" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <xsl:text>Workspace Export Summary&#10;</xsl:text>
    <xsl:text>=======================&#10;</xsl:text>
    <xsl:text>Generated: </xsl:text>
    <xsl:value-of select="wx:workspace-export/wx:generated-at" />
    <xsl:text>&#10;</xsl:text>
    <xsl:text>Workspace count: </xsl:text>
    <xsl:value-of select="count(wx:workspace-export/wx:workspace)" />
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:for-each select="wx:workspace-export/wx:workspace">
      <xsl:call-template name="render-workspace" />
    </xsl:for-each>
    <xsl:text>End of report&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="render-workspace">
    <xsl:text>- Workspace: </xsl:text>
    <xsl:value-of select="wx:name" />
    <xsl:text>&#10;  Owner: </xsl:text>
    <xsl:value-of select="wx:owner" />
    <xsl:text>&#10;  Branch: </xsl:text>
    <xsl:value-of select="wx:branch" />
    <xsl:text>&#10;  Remote: </xsl:text>
    <xsl:value-of select="wx:remote-url" />
    <xsl:text>&#10;  Favorite: </xsl:text>
    <xsl:choose>
      <xsl:when test="@favorite = 'true'">yes</xsl:when>
      <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;  Settings:&#10;</xsl:text>
    <xsl:text>    wifi-only = </xsl:text>
    <xsl:value-of select="wx:settings/wx:wifi-only" />
    <xsl:text>&#10;    auto-sync = </xsl:text>
    <xsl:value-of select="wx:settings/wx:auto-sync" />
    <xsl:text>&#10;    open-readme-on-launch = </xsl:text>
    <xsl:value-of select="wx:settings/wx:open-readme-on-launch" />
    <xsl:text>&#10;    sort-order = </xsl:text>
    <xsl:value-of select="wx:settings/wx:sort-order" />
    <xsl:text>&#10;    title-affordance = </xsl:text>
    <xsl:value-of select="wx:settings/wx:title-affordance" />
    <xsl:text>&#10;  Recent files:&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="count(wx:recent-files/wx:file) &gt; 0">
        <xsl:for-each select="wx:recent-files/wx:file">
          <xsl:text>    - </xsl:text>
          <xsl:value-of select="wx:path" />
          <xsl:text> [</xsl:text>
          <xsl:value-of select="wx:language" />
          <xsl:text>] at </xsl:text>
          <xsl:value-of select="wx:opened-at" />
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>    - none&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>  Sync events:&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="count(wx:sync-events/wx:event) &gt; 0">
        <xsl:for-each select="wx:sync-events/wx:event">
          <xsl:text>    - </xsl:text>
          <xsl:value-of select="wx:type" />
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@status" />
          <xsl:text>) </xsl:text>
          <xsl:value-of select="wx:message" />
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>    - none&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
</xsl:stylesheet>