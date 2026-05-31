# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
eval "$(starship init zsh)"
setopt AUTO_CD
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="arrow"

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

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias ls="ls -aFh --color=always"
alias cp="cp -i"
alias mv="mv -i"
alias ll="eza -la"
alias ls="eza -a --icons --group-directories-first"
alias home="cd ~"
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cls="clear"
alias vi="nvim"
alias svi="sudo nvim"
alias is="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
alias f="fastfetch"
alias download="aria2c -x 16 -s 16"
alias rm="rm -rf"
alias i="yay -S"
alias s="yay -Ss"

ff() {
    local file=$(fzf)
    # Avataan nvim vain, jos tiedosto valittiin (merkkijono ei ole tyhjä)
    [ -n "$file" ] && nvim "$file"
}

chpwd() {
    # --icons näyttää hienot kuvakkeet, --group-directories-first laittaa kansiot ensin
    eza -a --icons --group-directories-first
}

ex() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' ei voida purkaa ex-funktiolla" ;;
    esac
  else
    echo "'$1' ei ole pätevä tiedosto"
  fi
}

cpp() {
    # Zsh-kohtainen virheenhallinta (vastaa Bashin 'set -e' -asetusta tämän funktion sisällä)
    setopt localoptions errexit

    # Tarkistetaan, että lähdetiedosto on olemassa
    if [[ ! -f "$1" ]]; then
        echo "Virhe: Lähdetiedostoa ei ole olemassa." >&2
        return 1
    fi

    # Haetaan tiedoston koko (stat-komento toimii hieman eri tavoin eri alustoilla, 
    # mutta tämä Linux-muoto toimii kuten alkuperäisessäkin)
    local total_size
    total_size=$(stat -c '%s' "$1")

    # Jos tiedosto on tyhjä, kopioidaan se suoraan ilman kikkailuja
    if (( total_size == 0 )); then
        cp -- "$1" "$2"
        echo "100% [==================================================>]"
        return
    fi

    # Suoritetaan cp stracen läpi ja käsitellään awkilla
    # Zsh vaatii välillä pakotetun bufferityhjennyksen (fflush), joka on mukana awk-koodissa
    strace -q -a0 -ewrite cp -- "$1" "$2" 2>&1 | awk -v total="$total_size" '
    {
        # Poimitaan tavumäärä stracen tulosteen lopusta (esim. "= 131072")
        if (match($0, /= [0-9]+$/)) {
            bytes = substr($0, RSTART + 2, RLENGTH - 2)
            count += bytes
            
            percent = int((count / total) * 100)
            if (percent > 100) percent = 100
            
            # Tehdään palkista siisti 50 merkin pituinen (skaalautuu paremmin kuin 100 merkkiä)
            bar_width = 50
            filled = int((percent / 100) * bar_width)
            empty = bar_width - filled
            
            printf "\r%3d%% [", percent
            for (i=0; i<filled; i++) printf "="
            if (filled < bar_width) printf ">"
            else printf "="
            for (i=0; i<empty; i++) printf " "
            printf "]"
            
            fflush() 
        }
    }
    END { print "" }'
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

# bun completions
[ -s "/home/botmanu/.bun/_bun" ] && source "/home/botmanu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. "$HOME/.local/bin/env"
