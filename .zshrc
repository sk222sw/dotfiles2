
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# mise
eval "$(/usr/bin/mise activate zsh)"
eval "$(/home/sonny/.local/bin/mise activate zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo docker zsh-autosuggestions zsh-syntax-highlighting dirhistory history)

# User configuration
alias lss='eza --icons'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PATH=~/bin:$PATH
alias cat=batcat

export ERL_AFLAGS="-kernel shell_history enabled"
alias rad='./build/packages/rad/priv/rad'

# add /usr/bin to path
export PATH=~/usr/bin:$PATH

# erlang
export ERL_AFLAGS="-kernel shell_history enabled"

# neovim
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH=~/bin:$PATH
export PATH=$PATH:/snap/bin


export FLYCTL_INSTALL="/home/sonny/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

export PATH="/home/sonny/.local/share/nvimexample/mason/packages/omnisharp:$PATH"
export PATH="/home/sonny/.local/share/nvimexample/mason/packages/omnisharp/OmniSharp:$PATH"
alias omnisharp=OmniSharp
export PATH="$PATH:/home/sonny/.dotnet/tools"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/sonny/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
alias lzd='lazydocker'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fnm
FNM_PATH="/home/sonny/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/sonny/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

source $ZSH/oh-my-zsh.sh

source ~/.zsh_secrets
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets
