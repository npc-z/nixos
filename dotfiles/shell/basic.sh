# ##########################################
# 代理相关
# ref https://blog.nediiii.com/wsl2-note/
# ##########################################

alias public_ip="curl -i cip.cc"

# export PROXY_HOST=$(grep -oP '(?<=nameserver\ ).*' /etc/resolv.conf)
export PROXY_HOST="localhost"
export HTTP_PROXY_PORT="20171"
export SOCKS5_PROXY_PORT="20172"
export HTTP_PROXY_ADDR="http://${PROXY_HOST}:${HTTP_PROXY_PORT}"
export SOCKS5_PROXY_ADDR="socks5://${PROXY_HOST}:${SOCKS5_PROXY_PORT}"

function proxy() {
  export all_proxy="$HTTP_PROXY_ADDR"
  export http_proxy="$HTTP_PROXY_ADDR"
  export https_proxy="$HTTP_PROXY_ADDR"
  export ALL_PROXY="$HTTP_PROXY_ADDR"
  export HTTP_PROXY="$HTTP_PROXY_ADDR"
  export HTTPS_PROXY="$HTTP_PROXY_ADDR"

  # git
  # git config --global http.proxy "$SOCKS5_PROXY_ADDR"
  # git config --global https.proxy "$SOCKS5_PROXY_ADDR"

  # git config --global http.https://github.com.proxy "$SOCKS5_PROXY_ADDR"

  # declare
  echo "current proxy status: using $HTTP_PROXY_ADDR and $SOCKS5_PROXY_ADDR proxying"

  public_ip
}

function unproxy() {
  unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY

  # git
  git config --global --unset http.proxy
  git config --global --unset https.proxy

  git config --global --unset http.https://github.com.proxy

  # declare
  echo "current proxy status:  direct connect, not proxying"

  public_ip
}

# ##########################################
# git alias
# ##########################################

alias gs='git status'
alias gm="git merge"
alias gr="git rebase"
alias gl='git lg'
alias ga='git add .'
alias gac='git add . && git commit -m "update $(date "+%Y-%m-%d %H:%M:%S")"'
alias gacp="gac && git push"
alias gpl="git pull"
alias gps="git push"
alias lg=lazygit

# ##########################################
# other alias
# ##########################################

# shortcut
alias cls=clear
alias sz="source ~/.zshrc && echo source .zshrc done"
alias vz="vim ~/.zshrc"

alias vi=vim
alias vim=nvim
