# Алиасы и функции. Подхватывается oh-my-zsh автоматически: все *.zsh из
# $ZSH_CUSTOM грузятся после плагинов, поэтому эти алиасы перекрывают стандартные.
# Ставится хардлинком из packages/zsh/install.sh — редактировать можно любую из двух сторон.
# Проверки (( $+commands[...] )) нужны, чтобы алиас не появлялся, если утилита не установлена.

# --- ls ---
if (( $+commands[lsd] )); then
    alias ls='lsd'
    alias ll='lsd -lA'
    alias la='lsd -A'
    alias lt='lsd --tree'

    tree() {
        local -a args depth
        while (( $# )); do
            case $1 in
                -L)   depth=(--depth "${2:?tree: -L требует число}"); shift 2 ;;
                -L*)  depth=(--depth "${1#-L}"); shift ;;
                *)    args+=("$1"); shift ;;
            esac
        done
        lsd --tree $depth $args
    }

else
    alias ll='ls -lAh'
    alias la='ls -A'
fi

# --- cat ---
(( $+commands[bat] )) && alias cat='bat -pp'

# --- навигация ---
alias ..='cd ..'
alias ...='cd ../..'

alias grep='grep --color=auto'

