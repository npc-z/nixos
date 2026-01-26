# ##########################################
# 代理相关
# ##########################################

# NOTE: 代理软件设置端口是否匹配, 如何在配置中配置软件的端口?
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
  # git config --local http.proxy "$SOCKS5_PROXY_ADDR"
  # git config --local https.proxy "$SOCKS5_PROXY_ADDR"
  # git config --local http.https://github.com.proxy "$SOCKS5_PROXY_ADDR"

  echo "current proxy status: using $HTTP_PROXY_ADDR and $SOCKS5_PROXY_ADDR proxying"

  # public_ip
}

function unproxy() {
  unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY

  # git
  # git config --local --unset http.proxy
  # git config --local --unset https.proxy
  # git config --local --unset http.https://github.com.proxy

  echo "current proxy status:  direct connect, not proxying"

  # public_ip
}
