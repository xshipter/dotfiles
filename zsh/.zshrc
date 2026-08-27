# ── Environment ────────────────────────────────────────────────────────────────
# Must be first: downstream config (MANPAGER, zstyle list-colors) depends on these.
export EDITOR=nvim
export VISUAL=nvim
export BAT_THEME="ansi" # ANSI palette defers colors to the terminal — stays cohesive with delta
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
eval "$(dircolors -b)" # populates LS_COLORS — required by zstyle list-colors below

# ── Zsh Options ─────────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt CORRECT # prompts before correcting typos — remove if the interruptions bother you

# ── Autosuggestions config (before plugin load) ─────────────────────────────────
# These are read at widget-bind time, but setting them here makes the dependency explicit.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ── Plugins ─────────────────────────────────────────────────────────────────────
# Locate antidote.zsh — path differs depending on how antidote was installed:
#   AUR package (paru -S zsh-antidote): /usr/share/zsh-antidote/antidote.zsh
#   Git clone (manual):                ~/.antidote/antidote.zsh
# Checking both means this works regardless of install method; no clone needed
# if you went the package manager route.
if [[ -f /usr/share/zsh-antidote/antidote.zsh ]]; then
    source /usr/share/zsh-antidote/antidote.zsh
elif [[ -f ~/.antidote/antidote.zsh ]]; then
    source ~/.antidote/antidote.zsh
else
    echo '[zshrc] antidote not found — run: paru -S zsh-antidote' >&2
fi

# antidote load reads ~/.zsh_plugins.txt, handles its own mtime check, regenerates
# the static bundle only when the plugins list changes, then sources it.
antidote load

# ── History ─────────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY        # sync across all live sessions immediately
setopt HIST_IGNORE_ALL_DUPS # deduplicate fully, not just consecutive
setopt HIST_IGNORE_SPACE    # commands prefixed with a space are never saved
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY # expand !! before executing, don't fire blindly
setopt HIST_APPEND # append rather than overwrite on exit

# --- Compleation ----------------------------------------------------------------
mkdir -p ~/.cache/zsh/compcache
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/compcache
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ── fzf ─────────────────────────────────────────────────────────────────────────
# rg for files; fd for typed filtering in Ctrl-T and Alt-C; bat for previews.
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
# fzf ≥ 0.48 unified form — replaces the separate key-bindings.zsh and completion.zsh files.
# Note: zoxide zi (interactive picker) requires fzf ≥ 0.51.0 — Arch ships current fzf, so this is fine.
source <(fzf --zsh)

# ── Autosuggestion keybindings ───────────────────────────────────────────────────
# Right arrow (→) retains its default full-accept behavior — no rebinding needed.
# End key: partial-accept up to the next word boundary.
bindkey '^[[F' forward-word # End — xterm/VTE sequence
bindkey '\eOF' forward-word # End — application keypad mode (some terminal emulators)

# ── Aliases ─────────────────────────────────────────────────────────────────────
alias ls='eza --group-directories-first --icons=always'
alias ll='eza -lah --group-directories-first --git --icons'
alias la='eza -a --group-directories-first --icons=always --oneline'
alias tree='eza --tree --level=2 --icons'
alias cat='bat'
alias grep='rg'
alias du='dust'
alias top='btop'
alias lg='lazygit'
alias tldr='tldr --color always'
# `find` is deliberately not aliased to fd — fd's flags are incompatible with POSIX find,
# which breaks third-party scripts and plugin internals that call find directly.

alias vim='nvim'
alias cls='clear'

alias gst='git status'
alias gaa='git add -A'
alias gau='git add -U'

# For configs
alias .files='nvim ~/dotfiles'
alias .zsh='nvim ~/.zshrc'
alias .nvim='nvim ~/.config/nvim'
alias .config='nvim ~/.config/'

# Django
alias runserver='uv run manage.py runserver 0.0.0.0:8000'
alias manage='uv run manage.py'

# Custom Profiles

# Google Antigravity Isolated Profiles

# Functions
# Activate venv.(run this inside UV project base directory-- if need for neovim)
activate() {
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
    elif [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    else
        echo "Error: No virtual environment found in .venv/ or venv/." >&2
        return 1
    fi
}

# Create a dir and cd into it(mkdir flags supported)
take() {
    mkdir "$@" && cd "${@: -1}"
}

# cd into dir and ls
cl() {
    cd "$@" && ls
}

# Open neovim with or without a filename
v() {
    if [ $# -eq 0 ]; then
        nvim -c 'FzfLua files'
    else
        nvim "$@"
    fi
}

# ── Tool Initialization ──────────────────────────────────────────────────────────
# Order matters: each tool may rebind keys; later bindings win.
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd z)"           # provides z (jump) and zi (interactive fzf picker)
eval "$(atuin init zsh --disable-up-arrow)" # --disable-up-arrow is mandatory — keeps ↑↓ free below

# history-substring-search bindings must be the very last keybindings registered.
# atuin claims Ctrl-R; these take ↑↓ — if anything runs after this, it will clobber the arrows.
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

