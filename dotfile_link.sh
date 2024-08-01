#!/bin/bash

mkdir -p ~/.config

ln -snf ~/dotfiles/.config/.zshrc ~/
ln -snf ~/dotfiles/.config/.tmux.conf ~/
ln -snf ~/dotfiles/.config/nvim ~/.config
ln -snf ~/dotfiles/.config/alacritty ~/.config
ln -snf ~/dotfiles/.config/gotests ~/.config
ln -snf ~/dotfiles/.config/.ideavimrc ~/
ln -snf ~/dotfiles/.config/.vimrc ~/

go install github.com/cweill/gotests/...
go install github.com/go-delve/delve/cmd/dlv@latest


# 以下は初回のセットアップ時のみ有効にする(基本的にはコメントアウト)
# 毎回実行してもいいがログが大量に出て邪魔なため

# # oh-my-zsh関連のインストール
# ## oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# ## fzf-zsh-plugin
# git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
# ## zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#
# # Nerd Font
# brew install font-hack-nerd-font
#
# # Neovim
# brew install neovim
#
# # Starship
# brew install starship
