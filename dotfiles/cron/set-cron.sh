set -ex

crontab ./git-commit-doc-everyday
crontab -l
service cron start
# service cron status
