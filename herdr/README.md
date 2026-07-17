# herdr

[Herdr](https://herdr.dev) 関連の設定一式。並列で動かしている Claude Code セッションを
スマホから扱えるようにする（通知を受ける・外からアタッチして応答する）ためのセットアップを含む。

```
指示を出す → 放置 → スマホに通知（入力待ち/完了）→ スマホからアタッチして応答
```

## 構成

| ファイル | 役割 |
|---|---|
| `config.toml` | Herdr 本体の設定（`~/.config/herdr/config.toml` へ symlink） |
| `bin/herdr-ntfy-watch` | 全セッション監視スクリプト。`herdr agent list` を5秒ポーリングし、blocked（入力待ち）/ working→idle（完了）の遷移を [ntfy](https://ntfy.sh) にプッシュ |
| `launchd/dev.herdr.ntfy-watch.plist.template` | 監視スクリプト常駐用 LaunchAgent（`$HOME` を埋めて生成） |
| `setup.sh` | 上記すべての冪等セットアップ |
| `topic.example` | ntfy トピック名の例。**実トピックは `~/.config/herdr-ntfy-watch/topic` に置き、コミットしない**（知っていれば誰でも読める・送れるトークン相当のため） |

## 新 PC セットアップ

### 1. 自動部分

```bash
bash ~/dotfiles/herdr/setup.sh
```

symlink 作成、ntfy トピック生成（初回のみ）、LaunchAgent 登録まで行う。

### 2. Mac 側の手動ステップ（sudo が必要）

```bash
# 電源接続時にシステムスリープさせない（セッションと SSH 受付の生存条件）
sudo pmset -c sleep 0

# SSH リモートログインを有効化
sudo systemsetup -setremotelogin on
```

- Tailscale をインストールしてログイン（tailnet に参加）
- 離席時は Cmd+Ctrl+Q でロック（画面ロックはシステムを止めない）。MacBook の蓋は閉じない

### 3. スマホ側の手動ステップ

1. **ntfy** アプリを入れ、`cat ~/.config/herdr-ntfy-watch/topic` のトピックを購読
2. **Tailscale** アプリを入れ、同じ tailnet にログイン
3. **Termius**（または Blink Shell）から `ssh <mac のホスト名>` → `herdr` でアタッチ

### 4. 動作確認

```bash
herdr-ntfy-watch --once   # 全セッションの状態が表示されること
herdr-ntfy-watch --test   # スマホにテスト通知が届くこと
```

## 運用メモ

- セッションに名前を付けると通知で識別しやすい: `herdr agent rename <pane_id> <名前>`
- 監視デーモンのログ: `~/.config/herdr-ntfy-watch/watch.log`
- 再起動: `launchctl kickstart -k gui/$(id -u)/dev.herdr.ntfy-watch`
- トピック変更: `~/.config/herdr-ntfy-watch/topic` を編集して上の kickstart
- ポーリング間隔は env `HERDR_NTFY_POLL_SEC`、ntfy サーバーは `HERDR_NTFY_SERVER` で変更可
