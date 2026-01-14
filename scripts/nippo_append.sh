#!/bin/bash

ARGUMENTS="$*"
DATE=$(date +%Y-%m-%d)
JPDAY=$(date +%Y年%m月%d日)
NOW=$(date +%H:%M)
DIR="$HOME/dotfiles/nippos"
mkdir -p "$DIR"
FILE="$DIR/nippo.${DATE}.md"

# テンプレート
create_template() {
cat <<EOF > "$FILE"
# 日報 ${JPDAY}

## 📝 作業ログ

### ${NOW} - 初回記録
${ARGUMENTS}

---

## 🎯 今日の目標
- [ ] （後で記入）

## 📊 進捗状況
（セッション終了時に記入）

## 💡 学びと気づき
（随時追記）

## 🚀 明日への申し送り
（本日終了時に記入）
EOF
}

# 既存ファイルに追記する関数
append_worklog() {
  SHORT_ARG=$(echo "$ARGUMENTS" | cut -c1-20)
  # 📝 作業ログ セクションの末尾を探して追記
  awk -v now="${NOW}" -v txt="${ARGUMENTS}" -v short="${SHORT_ARG}" '
    BEGIN { inserted=0 }
    {
      print
      if(!inserted && $0 ~ /^## 📝 作業ログ/) {
        sect=1
      } else if (sect && $0 ~ /^---/){
        print "### " now " - " short
        print txt
        print ""
        inserted=1
        sect=0
      }
    }
  ' "$FILE" > "${FILE}.tmp"
  mv "${FILE}.tmp" "$FILE"
}

# 特別な処理
append_to_section(){
  SECTION="$1"
  CONTENT="$2"
  awk -v target="$SECTION" -v new="$CONTENT" '
    BEGIN { added=0 }
    {
      print
      if(!added && $0 ~ target) {
        getline buf
        if(buf ~ /（本日終了時に記入）|（随時追記）|（後で記入）|（セッション終了時に記入）/) {
          print buf
          print new
          added=1
        } else {
          print buf
        }
      }
    }
  ' "$FILE" > "${FILE}.tmp"
  mv "${FILE}.tmp" "$FILE"
}

check_done_in_goals(){
  awk -v goaltext="$1" '
    /^- \[ \] /{ 
      if(index($0, goaltext) > 0) {
        sub("- \\[ \\]", "- [x]")
      } 
    }
    { print }
  ' "$FILE" > "${FILE}.tmp"
  mv "${FILE}.tmp" "$FILE"
}

# 本体実行部
# ファイルなければ新規作成
if [ ! -f "$FILE" ]; then
  create_template
  exit 0
fi

# -------- 既存ファイルへの通常追記
append_worklog

# -------- 特別処理
if echo "$ARGUMENTS" | grep -q "振り返り:"; then
  FB_CONTENT=$(echo "$ARGUMENTS" | sed -n 's/.*振り返り:\(.*\)/• \1/p' | sed 's/ *明日:.*$//')
  append_to_section "## 💡 学びと気づき" "$FB_CONTENT"
fi
if echo "$ARGUMENTS" | grep -q "学び:"; then
  # スペース区切りで分割し、学び:で始まる項目を処理
  echo "$ARGUMENTS" | tr ' ' '\n' | while read -r item; do
    if echo "$item" | grep -q "^学び:"; then
      CONTENT=$(echo "$item" | sed 's/^学び://')
      if [ -n "$CONTENT" ]; then
        append_to_section "## 💡 学びと気づき" "• $CONTENT"
      fi
    fi
  done
fi
if echo "$ARGUMENTS" | grep -q "気づき:"; then
  # スペース区切りで分割し、気づき:で始まる項目を処理
  echo "$ARGUMENTS" | tr ' ' '\n' | while read -r item; do
    if echo "$item" | grep -q "^気づき:"; then
      CONTENT=$(echo "$item" | sed 's/^気づき://')
      if [ -n "$CONTENT" ]; then
        append_to_section "## 💡 学びと気づき" "• $CONTENT"
      fi
    fi
  done
fi
if echo "$ARGUMENTS" | grep -q "明日:"; then
  NEXT_CONTENT=$(echo "$ARGUMENTS" | sed -n 's/.*明日:\(.*\)/• \1/p' | sed 's/ *目標達成:.*$//')
  append_to_section "## 🚀 明日への申し送り" "$NEXT_CONTENT"
fi
if echo "$ARGUMENTS" | grep -q "目標:"; then
  GOAL_CONTENT=$(echo "$ARGUMENTS" | sed -n 's/.*目標:\(.*\)/- [ ] \1/p' | sed 's/ *進捗:.*$//')
  append_to_section "## 🎯 今日の目標" "$GOAL_CONTENT"
fi
if echo "$ARGUMENTS" | grep -q "進捗:"; then
  PROGRESS_CONTENT=$(echo "$ARGUMENTS" | sed -n 's/.*進捗:\(.*\)/• \1/p' | sed 's/ *学び:.*$//' | sed 's/ *気づき:.*$//')
  append_to_section "## 📊 進捗状況" "$PROGRESS_CONTENT"
fi
if echo "$ARGUMENTS" | grep -q "目標達成:"; then
  GCHECK=$(echo "$ARGUMENTS" | sed -n 's/.*目標達成:\(.*\)/\1/p')
  check_done_in_goals "$GCHECK"
fi
