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

# 検証中コマンド
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
