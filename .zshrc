PROMPT='$ %F{cyan}%~%f: '

# Always show helpers
alias ls="ls -F"

export GREP_OPTIONS="--color=auto"

export NVM_DIR="/Users/bchanx/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(/bin/cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Make zsh tab behave like bash
setopt noautomenu
setopt nomenucomplete

# Map home and end keys so fn+left and fn+right work
# when in terminal and in vim
# https://apple.stackexchange.com/questions/419657/how-do-i-get-home-and-end-working-for-both-iterm2-and-vim
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# usr/bin
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
