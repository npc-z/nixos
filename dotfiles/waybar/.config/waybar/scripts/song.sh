#!/bin/bash

jsonPath="$HOME/.cache/netease-cloud-music/StorageCache/webdata/file/queue"
playerName="netease-cloud-music"
playerShell="playerctl --player=$playerName"
lyricsPath="$HOME/.config/waybar/scripts/lyrics.lrc"

while [ true ]; do
	sleep 1s
	# 音乐播放器当前状态
	status=$($playerShell status)
	if [ "$status" != "Playing" ]; then
		# 非播放状态时, 不显示歌词条
		echo ""
		continue
	fi
	# 歌曲标题
	title=$($playerShell metadata title)
	if [ -n "$title" ]; then
		songId=$(jq -r '.[]|.track.name,.track.id' $jsonPath | grep -A 1 "$title" | sed -n '2p')
		# 播放当前时间
		position=$($playerShell metadata --format '{{ duration(position) }}')
		# 歌曲总长度
		length=$($playerShell metadata --format '{{ duration(mpris:length) }}')
		# 歌曲名称
		oldTitle=$(head -n +1 $lyricsPath)
		if [ "$title" != "$oldTitle" ]; then
			# 演唱者
			artist=$($playerShell metadata artist)
			# 专辑名称C8FFE0
			album=$($playerShell metadata album)
			# 歌曲本地图片
			icon=$($playerShell metadata mpris:artUrl)
			# 弹出提示框
			# dunstify -h string:x-dunst-stack-tag:music "$title-$artist" $album -t 5000 --icon $icon
			notify-send -h string:x-dunst-stack-tag:music "$title-$artist" $album -t 5000 --icon $icon
			# 请求歌词
			echo "" >$lyricsPath
			echo "" >>$lyricsPath
			curl http://music.163.com/api/song/media?id=$songId | jq -r '.lyric' >>$lyricsPath
			sed -i "1 c $title" $lyricsPath
		fi
		# 写入歌词
		lyrics=$(cat $lyricsPath | grep "$position" | awk -F ']' '{print $NF}' | head -n 1)
		if [ -n "$lyrics" ]; then
			# sed -i "2 c ==>$lyrics" $lyricsPath
			sed -i "2 c $lyrics" $lyricsPath
		fi
		# echo "$status [$title]$(sed -n 2p $lyricsPath) $position|$length"
		# echo "$(sed -n 2p $lyricsPath)"
		curLyric=$(sed -n 2p $lyricsPath)
		# remove the `\n` or `\r`
		curLyric=$(echo $curLyric | sed s/\\n//g)
		curLyric=$(echo $curLyric | sed s/\\r//g)
		if [ "$curLyric" == "" ]; then
			# show the title and position while
			curLyric="[$title] $position|$length"
		fi
		printf '{"text": "%s", "tooltip": "%s"}\n' "$curLyric" "[$title] $position|$length"
	else
		# printf '{"text": "%s", "tooltip": ""}\n' "[$title] $position|$length"
		echo ""
	fi
done
