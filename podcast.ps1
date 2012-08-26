<#
	open
	
 #>

$PodFolder = [Environment]::GetFolderPath('MyMusic')+'\Podcast\'

if(Test-Path $PodFolder){
}else{
	mkdir $PodFolder
}

switch($Args[0]){
	"init" {
		echo タスクスケジューラで定期的に動作するようにして下さい。
		echo また、環境変数のpathにpod.batのフォルダを指定しておくと、どの場所からでも podコマンド が実行できて便利です。
		Taskschd.msc
		control sysdm.cpl
	}
	"help"  {
		echo "pod [サブコマンド]"
		echo "help: このドキュメントを表示"
		echo "init: 初期設定を行う"
		echo "open: 保存先をひらく"
		echo "dir:  保存先のファイルを列挙"
		echo "play: 保存先のファイルを再生"
		echo "[rss url]: 指定URLのPodcantの最新の取得"
	}
	"open"  {
		Invoke-Item $PodFolder; break}
	"dir"   {
		dir $PodFolder; break}
	"play"   {
		Add-Type -AssemblyName presentationCore 
		$mediaPlayer = New-Object system.windows.media.mediaplayer 
		$path = "C:\Users\p95095yy\Dropbox\podcast" 
		$files = Get-ChildItem -path $path -include *.mp3,*.wma -recurse 
		foreach($file in $files) 
		{ 
			"Playing $($file.BaseName)"
			 $mediaPlayer.open([uri]"$($file.fullname)")
			 $mediaPlayer.Play()
			 Start-Sleep -Seconds 10
			 $mediaPlayer.Stop()
		}

		break} # 一番新しいものを再生

	default {
		[Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath

		(new-object net.webclient).downloadfile($Args[0], ".\rss.txt") # 文字コード変換のためにrssをrss.txtに一旦保存。
		$xml = [xml](get-content rss.txt -encoding utf8)               # utf8で読み出す。

		$ch   = $xml.rss.channel
		$item = $xml.rss.channel.item[0]

		$url      = New-Object System.Uri($item.enclosure.url)
		$file     = $url.Segments[-1]
		$filename = $ch.title+"_"+$file
		$filename = $PodFolder+$filename

		$filename # ファイル名を表示

		if (!(test-path $filename)) { # そのファイル名が存在しなかったら保存する
			(New-Object System.Net.WebClient).DownloadFile($url, $filename) 
		}
	}
}
