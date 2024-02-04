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
# run projects shortcuts
# ##########################################

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


# ##########################################
# dev env vars
# ##########################################

