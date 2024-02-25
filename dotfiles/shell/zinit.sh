autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Git plugin from OMZ
# zi snippet OMZP::git

zinit light zdharma-continuum/fast-syntax-highlighting
