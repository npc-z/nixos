# ##########################################
# programs shortcuts
# ##########################################

# black py code
alias bl='if [[ "$PWD" =~ "database" ]]; then echo "do not black database repo" &&  return; else black . --exclude /migrations/; fi'

# isort py code
alias ist="gss | xargs isort"

# black and isort the modified py code
# alias fmt="gss | xargs -d 'M' -n 1 | xargs isort && gss | xargs -d 'A' -n 1 | xargs isort &&  xargs -d '??' -n 1 | xargs isort && bl && flake8 --config=/root/doc/env/flake8"
alias fmtpy="gss | xargs -d 'M' -n 1 | xargs isort && gss | xargs -d 'A' -n 1 | xargs isort &&  xargs -d '??' -n 1 | xargs isort && bl && flake8 --config=/root/doc/env/flake8"

alias fmtprotos="buf format -w . && make lint"

alias fmtgo="gofmt -w . && golines -w . && make staticcheck"
#
alias check-work='ls ~/work/ | xargs -n 1  -I path sh -c "cd ~/work/path ; pwd ; git status -s"'



# work
alias bll='echo "black with -l 120\n" && black . -l 120'
alias blll='echo "black with -l 120\n" && black . -l 140'
# alias kl='kubectl config set-credentials developer'
# port forward mysql
alias fm="echo 'kubectl port-forward -n database mysql-proxy-67d4ccb66c-mb7zc 3307:3306' && kubectl port-forward -n database mysql-proxy-67d4ccb66c-mb7zc 3307:3306"

# alias rfm="kubectl port-forward -n database redisinsight-549794bff8-jwg4r 6380:8001"
# port forward redis dashboard
alias wrfm="kubectl -n database port-forward --address=0.0.0.0 svc/redisinsight-service 2000:80"


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

# k8s logs
alias klog="kubectl -c backend -ndos-test logs --since=1m -f "
alias kpod="kubectl get -n dos-test pod | grep "

# ##########################################
# dev env vars
# ##########################################

