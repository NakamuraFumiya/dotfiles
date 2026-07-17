#!/bin/bash
# herdr 関連の冪等セットアップ。dotfile_link.sh から呼ばれる（単体実行も可）。
# sudo が必要な手順やスマホ側の手順は自動化しない。README.md を参照。
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

# herdr 本体設定。ランタイムファイル（ログ・ソケット等）が同居するため config.toml のみ symlink する
mkdir -p ~/.config/herdr
ln -snf "$DIR/config.toml" ~/.config/herdr/config.toml

# セッション監視スクリプト（herdr agent list をポーリングして ntfy へプッシュ）
mkdir -p ~/.local/bin
ln -snf "$DIR/bin/herdr-ntfy-watch" ~/.local/bin/herdr-ntfy-watch

# ntfy トピックはトークン相当の秘匿情報のためリポジトリ外で管理。無ければ生成する
mkdir -p ~/.config/herdr-ntfy-watch
if [ ! -f ~/.config/herdr-ntfy-watch/topic ]; then
  printf 'herdr-%s-%s\n' "$(whoami)" "$(openssl rand -hex 6)" > ~/.config/herdr-ntfy-watch/topic
  echo "ntfy トピックを生成: $(cat ~/.config/herdr-ntfy-watch/topic)"
  echo "→ スマホの ntfy アプリでこのトピックを購読してください"
fi

# LaunchAgent。symlink の plist は launchd に拒否されることがあるため実体を生成する
mkdir -p ~/Library/LaunchAgents
sed "s|__HOME__|$HOME|g" "$DIR/launchd/dev.herdr.ntfy-watch.plist.template" \
  > ~/Library/LaunchAgents/dev.herdr.ntfy-watch.plist
launchctl bootout "gui/$(id -u)/dev.herdr.ntfy-watch" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/dev.herdr.ntfy-watch.plist

echo "herdr setup done（手動ステップは $DIR/README.md 参照）"
