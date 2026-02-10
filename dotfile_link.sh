#!/bin/bash

mkdir -p ~/.config

ln -snf ~/dotfiles/.config/.zshrc ~/
ln -snf ~/dotfiles/.config/.tmux.conf ~/
ln -snf ~/dotfiles/.config/nvim ~/.config
ln -snf ~/dotfiles/.config/alacritty ~/.config
ln -snf ~/dotfiles/.config/wezterm ~/.config
ln -snf ~/dotfiles/.config/gotests ~/.config
ln -snf ~/dotfiles/.config/.ideavimrc ~/
ln -snf ~/dotfiles/.config/.vimrc ~/

# 以下は初回のセットアップ時のみ有効にする(基本的にはコメントアウト)
# 毎回実行してもいいがログが大量に出て邪魔なため
#
# go install github.com/cweill/gotests/...@latest
# go install github.com/go-delve/delve/cmd/dlv@latest
#
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
# # JetBrainsMono Nerd Font
# brew search jetbrains
# brew install font-jetbrains-mono-nerd-font
#
# # Neovim
# brew install neovim
#
# # ripgrep
# ## TelescopeのLive Grepで必要になる
# brew install ripgrep
#
# # Starship
# brew install starship
#
# # tmux
# brew install tmux
#
# # node
# brew install node
#
# # awscli
# brew install awscli
#
# # pipx
# brew install pipx
# pipx ensurepath
# sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
#
# # aws-mfa
# pipx install aws-mfa
#
# # jq
# brew install jq
#
# # python
# brew install python
#
# # vacuum(openapi linter)
# brew install daveshanley/vacuum/vacuum
#
# # sqldef
# brew install sqldef/sqldef/mysqldef
#
# # mysql
# brew install mysql@8.4 
#
# # ast-grep
# brew install ast-grep
#
# # Atcoder
# npm install -g atcoder-cli
# pipx install online-judge-tools
#
# # lsd
# brew install lsd
#
# # kubernetes
# brew install kubernetes-cli
#
# # grpcurl
# brew install grpcurl
#
# # k8s relation tools
# brew install helm
# brew install helmfile
# helm plugin install https://github.com/databus23/helm-diff
# brew install kube-ps1
# brew install derailed/k9s/k9s
# brew install stern
#
# # tree
# brew install tree
#
# # terraform
# brew install terraform
#
# # tsc
# brew install tsc

