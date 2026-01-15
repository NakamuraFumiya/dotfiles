package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestNippoManager_CreateTemplate(t *testing.T) {
	tempDir := t.TempDir()

	nippo := &NippoManager{
		BaseDir:  tempDir,
		FilePath: filepath.Join(tempDir, "test.md"),
		Date:     time.Now(),
	}

	err := nippo.CreateTemplate("テスト内容")
	if err != nil {
		t.Fatalf("CreateTemplate failed: %v", err)
	}

	content, err := os.ReadFile(nippo.FilePath)
	if err != nil {
		t.Fatalf("Failed to read template file: %v", err)
	}

	contentStr := string(content)
	if !strings.Contains(contentStr, "# 日報") {
		t.Errorf("Template should contain '# 日報'")
	}
	if !strings.Contains(contentStr, "テスト内容") {
		t.Errorf("Template should contain test content")
	}
}

func TestMain_NewFileWithSectionProcessing(t *testing.T) {
	// ファイルが存在しない状態で複数セクション処理をテスト
	tempDir := t.TempDir()

	nippo := &NippoManager{
		BaseDir:  tempDir,
		FilePath: filepath.Join(tempDir, "test_new.md"),
		Date:     time.Now(),
	}

	// ディレクトリを作成
	err := nippo.EnsureDirectoryExists()
	if err != nil {
		t.Fatalf("EnsureDirectoryExists failed: %v", err)
	}

	processor := NewSectionProcessor(nippo)
	content := "目標:新規ファイルテスト 進捗:テスト実行中"

	// ファイルが存在しないことを確認
	if _, err := os.Stat(nippo.FilePath); !os.IsNotExist(err) {
		t.Fatalf("File should not exist initially")
	}

	// テンプレート作成
	err = nippo.CreateTemplate(content)
	if err != nil {
		t.Fatalf("CreateTemplate failed: %v", err)
	}

	// セクション処理を実行（修正後のロジック）
	err = processor.ProcessSpecialSections(content)
	if err != nil {
		t.Fatalf("ProcessSpecialSections failed: %v", err)
	}

	// ファイル内容を確認
	fileContent, err := os.ReadFile(nippo.FilePath)
	if err != nil {
		t.Fatalf("Failed to read file: %v", err)
	}

	contentStr := string(fileContent)

	// テンプレートの基本構造が存在することを確認
	if !strings.Contains(contentStr, "# 日報") {
		t.Errorf("File should contain nippo header: %s", contentStr)
	}

	// セクション処理結果の確認
	if !strings.Contains(contentStr, "- [ ] 新規ファイルテスト") {
		t.Errorf("File should contain processed goal: %s", contentStr)
	}

	if !strings.Contains(contentStr, "• テスト実行中") {
		t.Errorf("File should contain processed progress: %s", contentStr)
	}
}

func TestMain_ExistingFileWithSectionProcessing(t *testing.T) {
	// 既存ファイルに対するセクション処理をテスト
	tempDir := t.TempDir()

	nippo := &NippoManager{
		BaseDir:  tempDir,
		FilePath: filepath.Join(tempDir, "test_existing.md"),
		Date:     time.Now(),
	}

	// 最初にファイルを作成
	err := nippo.CreateTemplate("初回作成")
	if err != nil {
		t.Fatalf("CreateTemplate failed: %v", err)
	}

	processor := NewSectionProcessor(nippo)
	content := "目標:既存ファイルテスト"

	// 作業ログを追記（既存ファイルの場合）
	err = nippo.AppendWorkLog(content)
	if err != nil {
		t.Fatalf("AppendWorkLog failed: %v", err)
	}

	// セクション処理を実行
	err = processor.ProcessSpecialSections(content)
	if err != nil {
		t.Fatalf("ProcessSpecialSections failed: %v", err)
	}

	// ファイル内容を確認
	fileContent, err := os.ReadFile(nippo.FilePath)
	if err != nil {
		t.Fatalf("Failed to read file: %v", err)
	}

	contentStr := string(fileContent)

	// 作業ログが追記されていることを確認
	if !strings.Contains(contentStr, content) {
		t.Errorf("File should contain work log: %s", contentStr)
	}

	// セクション処理結果の確認
	if !strings.Contains(contentStr, "- [ ] 既存ファイルテスト") {
		t.Errorf("File should contain processed goal: %s", contentStr)
	}
}

func TestMain_MultipleGoalsInNewFile(t *testing.T) {
	// 修正されたバグのテスト：新規ファイルで複数目標が正しく処理される
	tempDir := t.TempDir()

	nippo := &NippoManager{
		BaseDir:  tempDir,
		FilePath: filepath.Join(tempDir, "test_multiple.md"),
		Date:     time.Now(),
	}

	err := nippo.EnsureDirectoryExists()
	if err != nil {
		t.Fatalf("EnsureDirectoryExists failed: %v", err)
	}

	processor := NewSectionProcessor(nippo)
	content := "目標:aa 目標:bb"

	// ファイルが存在しないことを確認
	if _, err := os.Stat(nippo.FilePath); !os.IsNotExist(err) {
		t.Fatalf("File should not exist initially")
	}

	// テンプレート作成とセクション処理（修正後のロジック）
	err = nippo.CreateTemplate(content)
	if err != nil {
		t.Fatalf("CreateTemplate failed: %v", err)
	}

	err = processor.ProcessSpecialSections(content)
	if err != nil {
		t.Fatalf("ProcessSpecialSections failed: %v", err)
	}

	// ファイル内容を確認
	fileContent, err := os.ReadFile(nippo.FilePath)
	if err != nil {
		t.Fatalf("Failed to read file: %v", err)
	}

	contentStr := string(fileContent)

	// 両方の目標が処理されていることを確認
	if !strings.Contains(contentStr, "- [ ] aa") {
		t.Errorf("File should contain first goal 'aa': %s", contentStr)
	}

	if !strings.Contains(contentStr, "- [ ] bb") {
		t.Errorf("File should contain second goal 'bb': %s", contentStr)
	}
}

func TestNippoManager_AppendWorkLog(t *testing.T) {
	tempDir := t.TempDir()

	nippo := &NippoManager{
		BaseDir:  tempDir,
		FilePath: filepath.Join(tempDir, "test.md"),
		Date:     time.Now(),
	}

	// 最初にテンプレートを作成
	err := nippo.CreateTemplate("初回作成")
	if err != nil {
		t.Fatalf("CreateTemplate failed: %v", err)
	}

	// 作業ログを追記
	err = nippo.AppendWorkLog("追加の作業内容")
	if err != nil {
		t.Fatalf("AppendWorkLog failed: %v", err)
	}

	// ファイル内容を確認
	content, err := os.ReadFile(nippo.FilePath)
	if err != nil {
		t.Fatalf("Failed to read file: %v", err)
	}

	contentStr := string(content)
	if !strings.Contains(contentStr, "追加の作業内容") {
		t.Errorf("File should contain appended work log")
	}
}

func TestNippoManager_EnsureDirectoryExists(t *testing.T) {
	tempDir := t.TempDir()
	subDir := filepath.Join(tempDir, "2026", "01")

	nippo := &NippoManager{
		BaseDir:  subDir,
		FilePath: filepath.Join(subDir, "test.md"),
		Date:     time.Now(),
	}

	// ディレクトリが存在しないことを確認
	if _, err := os.Stat(subDir); !os.IsNotExist(err) {
		t.Fatalf("Directory should not exist initially")
	}

	// ディレクトリを作成
	err := nippo.EnsureDirectoryExists()
	if err != nil {
		t.Fatalf("EnsureDirectoryExists failed: %v", err)
	}

	// ディレクトリが作成されたことを確認
	if _, err := os.Stat(subDir); os.IsNotExist(err) {
		t.Fatalf("Directory was not created")
	}
}

func TestNewNippoManager(t *testing.T) {
	nippo := NewNippoManager()

	if nippo == nil {
		t.Fatalf("NewNippoManager returned nil")
	}

	if nippo.BaseDir == "" {
		t.Errorf("BaseDir should not be empty")
	}

	if nippo.FilePath == "" {
		t.Errorf("FilePath should not be empty")
	}

	// パスが年月構造になっていることを確認
	year := time.Now().Format("2006")
	month := time.Now().Format("01")

	if !strings.Contains(nippo.BaseDir, year) {
		t.Errorf("BaseDir should contain year: %s", nippo.BaseDir)
	}

	if !strings.Contains(nippo.BaseDir, month) {
		t.Errorf("BaseDir should contain month: %s", nippo.BaseDir)
	}
}

func TestCopyFile(t *testing.T) {
	tempDir := t.TempDir()

	// ソースファイルを作成
	srcFile := filepath.Join(tempDir, "source.txt")
	dstFile := filepath.Join(tempDir, "dest.txt")
	testContent := "test content"

	err := os.WriteFile(srcFile, []byte(testContent), 0644)
	if err != nil {
		t.Fatalf("Failed to create source file: %v", err)
	}

	// ファイルをコピー
	err = copyFile(srcFile, dstFile)
	if err != nil {
		t.Fatalf("copyFile failed: %v", err)
	}

	// コピー先の内容を確認
	content, err := os.ReadFile(dstFile)
	if err != nil {
		t.Fatalf("Failed to read destination file: %v", err)
	}

	if string(content) != testContent {
		t.Errorf("Copied content mismatch: expected %s, got %s", testContent, string(content))
	}
}

func TestCopyDir(t *testing.T) {
	tempDir := t.TempDir()

	// ソースディレクトリ構造を作成
	srcDir := filepath.Join(tempDir, "source")
	dstDir := filepath.Join(tempDir, "dest")

	err := os.MkdirAll(filepath.Join(srcDir, "subdir"), 0755)
	if err != nil {
		t.Fatalf("Failed to create source directory: %v", err)
	}

	// テストファイルを作成
	testFile := filepath.Join(srcDir, "test.txt")
	subTestFile := filepath.Join(srcDir, "subdir", "subtest.txt")

	err = os.WriteFile(testFile, []byte("test content"), 0644)
	if err != nil {
		t.Fatalf("Failed to create test file: %v", err)
	}

	err = os.WriteFile(subTestFile, []byte("sub test content"), 0644)
	if err != nil {
		t.Fatalf("Failed to create sub test file: %v", err)
	}

	// ディレクトリをコピー
	err = copyDir(srcDir, dstDir)
	if err != nil {
		t.Fatalf("copyDir failed: %v", err)
	}

	// コピー先のファイルが存在することを確認
	dstTestFile := filepath.Join(dstDir, "test.txt")
	dstSubTestFile := filepath.Join(dstDir, "subdir", "subtest.txt")

	if _, err := os.Stat(dstTestFile); os.IsNotExist(err) {
		t.Errorf("Destination test file was not created")
	}

	if _, err := os.Stat(dstSubTestFile); os.IsNotExist(err) {
		t.Errorf("Destination sub test file was not created")
	}

	// 内容を確認
	content, err := os.ReadFile(dstTestFile)
	if err != nil {
		t.Fatalf("Failed to read destination file: %v", err)
	}

	if string(content) != "test content" {
		t.Errorf("Copied content mismatch")
	}
}
