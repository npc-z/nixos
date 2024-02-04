set -ex

git config --global init.defaultBranch master
git config --global core.editor vim

git config --global user.name npc-z
git config --global user.email 1763998996@qq.com

git config --global alias.st status --replace-all
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.last 'log -1'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# 正确显示中文文件名
git config --global core.quotepath false

