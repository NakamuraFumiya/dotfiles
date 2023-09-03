#!/bin/bash

mkdir -p ~/.config

ln -snf ~/dotfiles/.config/.zshrc ~/
ln -snf ~/dotfiles/.config/nvim ~/.config
ln -snf ~/dotfiles/.config/alacritty ~/.config
ln -snf ~/dotfiles/.config/gotests ~/.config
