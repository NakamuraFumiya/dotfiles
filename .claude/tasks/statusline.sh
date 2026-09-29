#!/bin/sh
# ccstatusline の custom-command widget から呼ばれる。
# current.txt の 1 行目をそのまま出す。ファイルが無ければ何も出さない（widget が消える）。
f="$HOME/.claude/tasks/current.txt"
[ -r "$f" ] || exit 0
head -n 1 "$f"
