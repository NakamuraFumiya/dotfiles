package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
)

type NippoManager struct {
	BaseDir  string
	FilePath string
	Date     time.Time
}

func NewNippoManager() *NippoManager {
	now := time.Now()
	homeDir, _ := os.UserHomeDir()

	// 年度・月でディレクトリ分け
	year := now.Format("2006")
	month := now.Format("01")
	baseDir := filepath.Join(homeDir, "dotfiles", "nippos", year, month)

	fileName := fmt.Sprintf("nippo.%s.md", now.Format("2006-01-02"))
	filePath := filepath.Join(baseDir, fileName)

	return &NippoManager{
		BaseDir:  baseDir,
		FilePath: filePath,
		Date:     now,
	}
}

func (n *NippoManager) EnsureDirectoryExists() error {
	return os.MkdirAll(n.BaseDir, 0755)
}

func (n *NippoManager) CreateTemplate(content string) error {
	jpDay := n.Date.Format("2006年01月02日")
	now := n.Date.Format("15:04")

	template := fmt.Sprintf(`# 日報 %s

## 📝 作業ログ

### %s - 初回記録
%s

---

## 🎯 今日の目標

## 📊 進捗状況

## 💡 学びと気づき

## 🚀 明日への申し送り

`, jpDay, now, content)

	return os.WriteFile(n.FilePath, []byte(template), 0644)
}

func (n *NippoManager) AppendWorkLog(content string) error {
	now := n.Date.Format("15:04")
	shortContent := content
	if len(content) > 20 {
		shortContent = content[:20]
	}

	// ファイルを読み込む
	fileContent, err := os.ReadFile(n.FilePath)
	if err != nil {
		return err
	}

	lines := strings.Split(string(fileContent), "\n")
	var result []string
	inserted := false

	for _, line := range lines {
		result = append(result, line)

		// "---" セクションを見つけたら、その前に新しいエントリを挿入
		if !inserted && line == "---" {
			result = append(result, fmt.Sprintf("### %s - %s", now, shortContent))
			result = append(result, content)
			result = append(result, "")
			inserted = true
		}
	}

	return os.WriteFile(n.FilePath, []byte(strings.Join(result, "\n")), 0644)
}

func copyDir(src, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// 相対パスを取得
		relPath, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}

		// .gitディレクトリはスキップ
		if strings.Contains(relPath, ".git") {
			if info.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}

		dstPath := filepath.Join(dst, relPath)

		if info.IsDir() {
			return os.MkdirAll(dstPath, info.Mode())
		}

		// ファイルをコピー
		return copyFile(path, dstPath)
	})
}

func copyFile(src, dst string) error {
	sourceFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer sourceFile.Close()

	// ディレクトリが存在しない場合は作成
	if err := os.MkdirAll(filepath.Dir(dst), 0755); err != nil {
		return err
	}

	destFile, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer destFile.Close()

	_, err = io.Copy(destFile, sourceFile)
	return err
}

func showUsage() {
	fmt.Println("使用法:")
	fmt.Println("  nippo <内容>          日報に内容を追記")
	fmt.Println("  nippo copy           nipposディレクトリを$HOME/nippoにコピー")
}

func main() {
	if len(os.Args) < 2 {
		showUsage()
		os.Exit(1)
	}

	// copyサブコマンドの処理
	if os.Args[1] == "copy" {
		homeDir, _ := os.UserHomeDir()
		srcDir := filepath.Join(homeDir, "dotfiles", "nippos")
		dstDir := filepath.Join(homeDir, "nippo")

		// ソースディレクトリが存在するかチェック
		if _, err := os.Stat(srcDir); os.IsNotExist(err) {
			log.Fatalf("ソースディレクトリが存在しません: %s", srcDir)
		}

		fmt.Printf("コピー中: %s → %s\n", srcDir, dstDir)

		if err := copyDir(srcDir, dstDir); err != nil {
			log.Fatalf("コピーに失敗しました: %v", err)
		}

		fmt.Println("コピー完了！")
		return
	}

	// 通常の日報追記処理
	content := strings.Join(os.Args[1:], " ")
	nippo := NewNippoManager()
	processor := NewSectionProcessor(nippo)

	// ディレクトリが存在することを確認
	if err := nippo.EnsureDirectoryExists(); err != nil {
		log.Fatalf("ディレクトリの作成に失敗: %v", err)
	}

	// ファイルが存在しない場合、テンプレートを作成
	if _, err := os.Stat(nippo.FilePath); os.IsNotExist(err) {
		if err := nippo.CreateTemplate(content); err != nil {
			log.Fatalf("テンプレートの作成に失敗: %v", err)
		}
		return
	}

	// 既存ファイルに追記
	if err := nippo.AppendWorkLog(content); err != nil {
		log.Fatalf("作業ログの追記に失敗: %v", err)
	}

	// セクション別の特別処理
	if err := processor.ProcessSpecialSections(content); err != nil {
		log.Fatalf("セクション処理に失敗: %v", err)
	}
}
