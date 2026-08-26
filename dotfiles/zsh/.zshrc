# ==========================================
# SHO'S STANDALONE ZSH CONFIG FOR ARCH LINUX
# ==========================================

# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme (leave blank for starship)
ZSH_THEME=""

# Plugins
plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting)

# Load oh-my-zsh if installed
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# Startup: Print logo and fastfetch
if [ -f "$HOME/.config/fastfetch/logo.txt" ]; then
    cat "$HOME/.config/fastfetch/logo.txt"
fi
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch -c "$HOME/.config/fastfetch/config.jsonc" --logo "$HOME/.config/fastfetch/ghost.txt" --logo-type file
fi

# Tab Completion Menu
zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete

# Aliases
alias code="code > /dev/null 2>&1"
alias ls="eza --icons"
alias ll="eza -la --icons"
alias v="nvim"
alias lg="lazygit"

# Initialize Starship Prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Initialize Zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
