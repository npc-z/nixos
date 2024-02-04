# remap keys

See the 5.2 `Reassigning modifiers to keys on your keyboard` arch wiki

https://wiki.archlinux.org/title/Xmodmap


## use
put the below command in script automatically run when the system boot up

```bash
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
```

or manaully exceute the command
```bash
xmodmap .Xmodmap
```

