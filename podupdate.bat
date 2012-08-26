echo start %time%
cd /D %~dp0

powershell .\podcast.ps1 http://www.tbsradio.jp/ijuin/rss.xml
powershell .\podcast.ps1 http://www.tbsradio.jp/bakusho/rss.xml
powershell .\podcast.ps1 http://www.joqr.co.jp/otenki_pod/index.xml
powershell .\podcast.ps1 http://www.joqr.net/blog/hige/index.xml
powershell .\podcast.ps1 http://feeds.feedburner.com/dpz/longdpr
powershell .\podcast.ps1 http://plray.jp/listen/kyoko/feed
powershell .\podcast.ps1 http://www.nhk.or.jp/r-news/podcast/nhkradionews.xml
powershell .\podcast.ps1 http://www.nhk.or.jp/r-asa/podcast/life.xml
powershell .\podcast.ps1 http://www.nhk.or.jp/r-asa/podcast/business.xml

echo end %time%
