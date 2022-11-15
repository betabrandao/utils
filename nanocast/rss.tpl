<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
  <channel>
    <title>${SITE_TITLE}</title>
    <itunes:owner>
        <itunes:email>${SITE_EMAIL}</itunes:email>
    </itunes:owner>
    <itunes:author>${SITE_AUTHOR}</itunes:author>
    <description>${SITE_DESC}</description>
    <itunes:image href="${SITE_IMG}"/>
    <language>en-us</language>
    <link>${SITE_URL}</link>
    ${RSS_ITEM}
  </channel>
</rss>
