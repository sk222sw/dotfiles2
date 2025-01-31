# Install

## Programs
### tmux
`sudo apt install tmux`

`git clone https://github.com/tmux-plugins/tpm ~/.config/.tmux/plugins/tpm`

Enter tmux, run `Ctrl-B I` to install tmux packages

### eza
`https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu`

### bat
`sudo apt install bat`

### zsh
`apt install zsh`

make zsh default `chsh -s $(which zsh)`

restart ghostty 

### mise
install mise `https://mise.jdx.dev/getting-started.html`

## my zsh
### oh my zsh  
`https://ohmyz.sh/#install`

### p10k
`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"`

### zsh-autosuggestions 
`git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

### zsh syntax highlighting 
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`

## Stow
`sudo apt install stow`

`$ cd dotfiles`

run stow `stow --adopt .`

make sure `~/.zshrc` is overwritten by stow else remove it and run stow again


