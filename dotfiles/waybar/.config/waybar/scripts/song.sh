jsonPath="$HOME/.cache/netease-cloud-music/StorageCache/webdata/file/queue"
playerName="netease-cloud-music,yesplaymusic"
playerShell="playerctl --player=$playerName"
# lyricsPath="$HOME/.config/waybar/scripts/lyrics.lrc"
envPath="$HOME/.config/waybar/scripts/.env"

SHOW_LYRICS_AT_BAR=true

albumCachePath="${HOME}/.cache/album"
mkdir -p $albumCachePath

lyricsPath="${HOME}/.cache/waybar-lyrics.lrc"
touch $lyricsPath

while [ true ]; do
	sleep 1s

    # 检查.env文件是否存在
    if [ -f $envPath ]; then
        # 检查变量a是否在.env文件中定义
        if grep -q "^SHOW_LYRICS_AT_BAR=" $envPath; then
            # 导入.env文件
            source $envPath
        fi
    fi

    if [ "$SHOW_LYRICS_AT_BAR" = false ]; then
        echo ""
        sleep 10s
        continue
    fi

	# 音乐播放器当前状态
	status=$($playerShell status)
	if [ "$status" != "Playing" ]; then
		# 非播放状态时, 不显示歌词条
		echo ""
        sleep 10s
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
			# 歌曲图片
			iconPath=$($playerShell metadata mpris:artUrl)
            # echo $iconPath
            # 判断是否以 "http" 开头
            if [[ $iconPath == http* ]]; then
                filename=$(basename "${iconPath%%\?*}") # 提取 URL 的路径部分，并去掉问号及其后面的内容
                title_="${title// /-}" # 歌曲名中空格替换为 `-`
                localIcon="${albumCachePath}/${title_}-${filename}"
                icon="file://${localIcon}"
                if ! [ -f "${localIcon}" ]; then
                    wget -O "${localIcon}" "$iconPath"
                fi
            elif [[ ${iconPath} == file* ]]; then
                # 本地文件
                icon=${iconPath}
            else
                icon=""
            fi
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
