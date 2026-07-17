# Looking for local system settings? See $HOME/.zprofile
# Start or attach tmux on login
if [[ -z $TMUX && $- == *i* ]] && command -v tmux > /dev/null; then
  exec tmux new -A -s main
fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Extra PATH locations
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.npm/_global/bin:$PATH"
#
# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
#
# Name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"
#
# Disables the auto-generated title
DISABLE_AUTO_TITLE="true"
#
# Disable omz auto-update
zstyle ':omz:update' mode disabled
#
# List of plugins to load
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-history-substring-search
)
#
source $ZSH/oh-my-zsh.sh
#
# Use right colors
export COLORTERM=truecolor
#
# Custom go path
export GOPATH="$HOME/.go"
#
# Language environment setting
export LANG=en_US.UTF-8
#
# Preferred text editor
export EDITOR='nvim'
#
# Preferred man pager
export MANPAGER='nvim +Man!'
#
# Preferred browser
export BROWSER='firefox'
#
# Run fastfetch instead of neofetch
alias neofetch="fastfetch"
#
# Dotfiles git alias
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
#
# History Substring Search Options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
#
# Autosuggestions Accept Key
bindkey '^[l' autosuggest-accept
#
# Bind Alt+j/k to up/down arrow keys
bindkey '^[j' down-line-or-search
bindkey '^[k' up-line-or-search
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
