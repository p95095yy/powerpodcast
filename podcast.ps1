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
		echo �^�X�N�X�P�W���[���Œ���I�ɓ��삷��悤�ɂ��ĉ������B
		echo �܂��A���ϐ���path��pod.bat�̃t�H���_���w�肵�Ă����ƁA�ǂ̏ꏊ����ł� pod�R�}���h �����s�ł��ĕ֗��ł��B
		Taskschd.msc
		control sysdm.cpl
	}
	"help"  {
		echo "pod [�T�u�R�}���h]"
		echo "help: ���̃h�L�������g��\��"
		echo "init: �����ݒ���s��"
		echo "open: �ۑ�����Ђ炭"
		echo "dir:  �ۑ���̃t�@�C�����"
		echo "play: �ۑ���̃t�@�C�����Đ�"
		echo "[rss url]: �w��URL��Podcant�̍ŐV�̎擾"
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

		break} # ��ԐV�������̂��Đ�

	default {
		[Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath

		(new-object net.webclient).downloadfile($Args[0], ".\rss.txt") # �����R�[�h�ϊ��̂��߂�rss��rss.txt�Ɉ�U�ۑ��B
		$xml = [xml](get-content rss.txt -encoding utf8)               # utf8�œǂݏo���B

		$ch   = $xml.rss.channel
		$item = $xml.rss.channel.item[0]

		$url      = New-Object System.Uri($item.enclosure.url)
		$file     = $url.Segments[-1]
		$filename = $ch.title+"_"+$file
		$filename = $PodFolder+$filename

		$filename # �t�@�C������\��

		if (!(test-path $filename)) { # ���̃t�@�C���������݂��Ȃ�������ۑ�����
			(New-Object System.Net.WebClient).DownloadFile($url, $filename) 
		}
	}
}
