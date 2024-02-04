# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# source ~/.plugin-repo/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# 代理相关  proxy()  unPorxy
#
# https://blog.nediiii.com/wsl2-note/

# export HOST_IP=$(grep -oP '(?<=nameserver\ ).*' /etc/resolv.conf)
export HOST_IP="192.168.43.211"
# export PROXY_ADDR="http://${HOST_IP}:7890"
export PROXY_ADDR="http://${HOST_IP}:1082"

# GLOBAL PROXY FOR BASH

# if ~/.bash_proxy not exist , then create it.
if [ ! -f ~/.bash_proxy ]; then
    touch ~/.bash_proxy
fi
# execute ~/.bash_proxy
# . ~/.bash_proxy

alias public_ip="curl -i cip.cc"


function proxy() {

    export all_proxy="$PORXY_ADDR"
    export http_proxy="$PORXY_ADDR"
    export https_proxy="$PORXY_ADDR"
    export ALL_PROXY="$PORXY_ADDR"
    export HTTP_PROXY="$PORXY_ADDR"
    export HTTPS_PROXY="$PORXY_ADDR"

    echo -e "export {all_proxy,http_proxy,https_proxy,ALL_PROXY,HTTP_PROXY,HTTPS_PROXY}=\"$PROXY_ADDR\";" | tee ~/.bash_proxy >/dev/null

    # apply
    . ~/.bash_proxy

    # git

    # git config --global http.proxy "socks5://$HOST_IP:7890"
    # git config --global https.proxy "socks5://$HOST_IP:7890"

    git config --global http.proxy "socks5://$HOST_IP:1082"
    git config --global https.proxy "socks5://$HOST_IP:1082"
    # declare
    echo "current proxy status: using $PROXY_ADDR, proxying"
    public_ip
}

function unproxy() {

    # unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY
    echo -e "unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY" | tee ~/.bash_proxy >/dev/null
    # apply
    . ~/.bash_proxy

    git config --global --unset http.proxy
    git config --global --unset https.proxy

    # declare
    echo "current proxy status:  direct connect, not proxying"
    public_ip
}


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# 设置临时 build needed envs，也可以写入 `.zshrc`
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/sqlite/lib/pkgconfig"

# .pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# diff-so-fancy
export PATH=~/.bin:$PATH

export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
source /usr/local/bin/virtualenvwrapper.sh



alias cls=clear

# zsh
alias sz="source ~/.zshrc && echo source .zshrc done"
alias vz="nvim ~/.zshrc"

# git
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

# nvim
alias vn="cd ~/.config/nvim && nvim ."
alias vim="nvim"
alias vi="nvim"

# usual programmer
alias bl='if [[ "$PWD" =~ "database" ]]; then echo "do not black database repo" &&  return; else black . --exclude /migrations/; fi'
alias ist="gss | xargs isort"
# gss | xargs -d "M" -n 1 | xargs -I file sh -c 'isort file; black file'

# alias fmt="gss | xargs -d 'M' -n 1 | xargs isort && gss | xargs -d 'A' -n 1 | xargs isort &&  xargs -d '??' -n 1 | xargs isort && bl && flake8 --config=/root/doc/env/flake8"
alias fmtpy="gss | xargs -d 'M' -n 1 | xargs isort && gss | xargs -d 'A' -n 1 | xargs isort &&  xargs -d '??' -n 1 | xargs isort && bl && flake8 --config=/root/doc/env/flake8"

alias fmtprotos="buf format -w . && make lint"

alias fmtgo="gofmt -w . && golines -w . && make staticcheck"

alias check-work='ls ~/work/ | xargs -n 1  -I path sh -c "cd ~/work/path ; pwd ; git status -s"'

function fmt() {
    # set -x
    dir=`pwd`

    # format doc
    if [[ $dir == "$HOME/doc" ]]; then
        # bll
        gss | xargs -d 'M' -n 1 | xargs isort && gss | xargs -d 'A' -n 1 | xargs isort &&  xargs -d '??' -n 1 | xargs isort && bl
        return 0
    fi

    # ignore database repo
    if [[ $dir =~ "database" ]]; then
        echo "do not black database repo"
        return 0
    fi

    # format protos repo
    if [[ $dir == "$HOME/work/protos" ]]; then
        # echo $dir
        fmtprotos
        return 0
    fi

    # format go repo
    if [[ -f "$dir/go.mod" ]]; then
        fmtgo
        return 0
    fi

    # python repo
    if [[ -f "$dir/Pipfile.lock" ]]; then
        fmtpy
        return 0
    fi

    echo "do nothing in $dir"
}

alias ra=ranger

# work
alias bll='echo "black with -l 120\n" && black . -l 120'
alias blll='echo "black with -l 120\n" && black . -l 140'
alias kl='kubectl config set-credentials developer'
alias fm="echo 'kubectl port-forward -n database mysql-proxy-67d4ccb66c-mb7zc 3307:3306' && kubectl port-forward -n database mysql-proxy-67d4ccb66c-mb7zc 3307:3306"
# alias rfm="kubectl port-forward -n database redisinsight-549794bff8-jwg4r 6380:8001"
alias wrfm="kubectl -n database port-forward --address=0.0.0.0 svc/redisinsight-service 2000:80"
alias klog="kubectl -c backend -n dos-test logs "
alias kpod="kubectl get pod -n dos-test | grep"


export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node

# go env

export PATH=$PATH:/usr/local/go/bin:~/go/bin

alias "rqiye"='source ~/doc/env/qiye-web.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && python manage.py runserver -h 0.0.0.0 -p $PORT'

# alias "rbi"='source ~/doc/env/corp-bi.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && python manage.py runserver -h 0.0.0.0 -p $PORT'
alias "rbi"='source ~/doc/env/corp-bi.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && flask run -h 0.0.0.0 -p $PORT'

alias "rcar"='source ~/doc/env/car-backend.sh && workon car-backend && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && flask run -h 0.0.0.0 -p $PORT'

# alias "rboss"=' source ~/doc/env/boss-web.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && pipenv run  python manage.py runserver -h 0.0.0.0 -p $PORT'
alias "rboss"=' source ~/doc/env/boss-web.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload'

alias "rusedcarweb"="source ~/doc/env/usedcar-web.sh && echo SERVER_NAME is '$SERVER_NAME' && echo database is '$SQLALCHEMY_DATABASE_URI' && gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload"

alias "rreport"="source ~/doc/env/report.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload"

alias "rretail"="make clean && make build-linux && build/linux/geteway -c /doc/env/usedcar-retail.yaml"

alias "renquiry"="make clean && make build-linux && build/linux/gateway -c /doc/env/usedcar-enquiry.yaml"

alias "rretail-web"="source ~/doc/env/retail-web.sh && echo SERVER_NAME is $SERVER_NAME && echo DATABASE IS '$SQLALCHEMY_DATABASE_URI'  &&  gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload"

alias "rusedcar-transfer"="make clean && make debug && ./build/gateway -c /doc/env/usedcar-transfer.yaml --log-output-level debug"

alias "rstore"="make clean && make debug && ./build/gateway -c /doc/env/store.yaml"

alias "rsubscriber"="make clean && make debug && ./build/gateway -c /doc/env/usedcar-subscriber.yaml"
# alias "rsubscriber"="make clean && make build-linux && ./build/linux/gateway -c /doc/env/usedcar-subscriber.yaml"

alias "rusedcar-retail"="make build-linux && ./build/linux/gateway -c /doc/env/usedcar-retail.yaml"

alias "rfixedprice"="make build-linux && ./build/linux/gateway -c /doc/env/usedcar-fixed-price.yaml"

alias "rdealer"="make build-linux-debug && ./build/linux/gateway -c /doc/env/dealer.yaml"

alias "rsub"="make clean && make build-linux-debug && ./build/linux/gateway -c /doc/env/subscriber.yaml"

alias "rstock"="make clean && make build-linux-debug && ./build/linux/gateway -c /doc/env/usedcar-stock.yaml"

alias "rmerchant"='source ~/doc/env/merchant-web.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload'

alias "rcorp"='source ~/doc/env/corp-backend.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload'

alias "rauction-web"='source ~/doc/env/auction-web.sh && echo SERVER_NAME is $SERVER_NAME && echo database is $SQLALCHEMY_DATABASE_URI && gunicorn -b 0.0.0.0:$PORT -k gevent wsgi:application --reload'

# Install Ruby Gems to ~/gems
export PATH="$HOME/gems/bin:$PATH"
export GEM_HOME="$HOME/gems"





# source ~/.oh-my-zsh/plugins/incr/incr*.zsh
#
source ~/.gvm/scripts/gvm

# 开发项目所需环境变量
export PYPI_USER=dev
export PYPI_PASSWD=Ood4Kee2eeGhoe7i
export PIP_URL="https://${PYPI_USER}:${PYPI_PASSWD}@pypi.lixinio.com/simple/"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
