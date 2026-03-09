<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:wx="https://example.com/workspace-export">
  <xsl:output method="html" indent="yes" encoding="UTF-8" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Workspace Export Report</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 24px; background: #f8fafc; color: #1f2937; }
          h1, h2 { color: #7c3f00; }
          .meta { color: #6b7280; margin-bottom: 16px; }
          .card { background: white; border-radius: 12px; padding: 16px; margin-bottom: 16px; box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08); }
          table { width: 100%; border-collapse: collapse; margin-top: 12px; }
          th, td { padding: 10px; border-bottom: 1px solid #e5e7eb; text-align: left; }
          th { font-size: 12px; text-transform: uppercase; letter-spacing: 0.06em; color: #6b7280; }
          .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; background: #fff4db; color: #8a5a24; font-size: 12px; }
          .empty { padding: 18px; background: white; border-radius: 12px; color: #6b7280; }
        </style>
      </head>
      <body>
        <h1>Workspace Export Report</h1>
        <p class="meta">
          Generated at
          <xsl:value-of select="wx:workspace-export/wx:generated-at" />
        </p>
        <xsl:choose>
          <xsl:when test="count(wx:workspace-export/wx:workspace) &gt; 0">
            <xsl:apply-templates select="wx:workspace-export/wx:workspace" />
          </xsl:when>
          <xsl:otherwise>
            <div class="empty">No workspaces were exported.</div>
          </xsl:otherwise>
        </xsl:choose>
        <p class="meta">Rendered from workspace-export XML via XSLT.</p>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="wx:workspace">
    <div class="card">
      <h2>
        <xsl:value-of select="wx:name" />
        <xsl:if test="@favorite = 'true'">
          <span class="tag">Pinned</span>
        </xsl:if>
      </h2>
      <p>
        <strong>Owner:</strong>
        <xsl:text> </xsl:text>
        <xsl:value-of select="wx:owner" />
        <xsl:text> | </xsl:text>
        <strong>Branch:</strong>
        <xsl:text> </xsl:text>
        <xsl:value-of select="wx:branch" />
      </p>
      <p>
        <strong>Remote:</strong>
        <xsl:text> </xsl:text>
        <xsl:value-of select="wx:remote-url" />
      </p>
      <table>
        <thead>
          <tr>
            <th>Recent File</th>
            <th>Language</th>
            <th>Opened</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="wx:recent-files/wx:file">
            <tr>
              <td><xsl:value-of select="wx:path" /></td>
              <td><xsl:value-of select="wx:language" /></td>
              <td><xsl:value-of select="wx:opened-at" /></td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>