# alias gac="git add . && git commit -m 'update $(date "+%Y-%m-%d %H:%M:%S")'"
# alias gacp="gac && git push"

cd ~/doc && git add . && git commit -m "auto commit $(date '+%Y-%m-%d %H:%M:%S')" && git push

