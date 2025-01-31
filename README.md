# Install

eza `https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu`

zsh `apt install zsh`

make zsh default `chsh -s $(which zsh)`

restart ghostty 

oh my zsh  `https://ohmyz.sh/#install`

p10k `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"`

zsh-autosuggestions `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

zsh syntax highlighting `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`

install stow `sudo apt install stow`

`$ cd dotfiles`

run stow `stow .`

make sure ~/.zshrc is overwritten by stow else remove it and run stow again

install mise `https://mise.jdx.dev/getting-started.html`

