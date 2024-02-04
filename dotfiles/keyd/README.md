# keyd

[link](https://github.com/rvaiya/keyd)


## how to use

```bash
# install
yay -S keyd

# enable
systemctl enable --now keyd


stow keyd
# for app specific remap, run the keyd-application-mapper backgound
keyd-application-mapper &

sudo ln -s the/default.conf /etc/keyd/default.conf

sudo keyd reload
```
