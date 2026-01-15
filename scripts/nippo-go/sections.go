package main

import (
	"fmt"
	"os"
	"regexp"
	"strings"
)

type SectionProcessor struct {
	nippo *NippoManager
}

func NewSectionProcessor(nippo *NippoManager) *SectionProcessor {
	return &SectionProcessor{nippo: nippo}
}

// セクション別の特別処理
func (s *SectionProcessor) ProcessSpecialSections(content string) error {
	// スペースで分割してから各部分を処理
	parts := strings.Fields(content)

	var currentKeyword, currentValue strings.Builder

	for _, part := range parts {
		// キーワードを検出
		if strings.Contains(part, ":") && (strings.HasPrefix(part, "目標:") ||
			strings.HasPrefix(part, "進捗:") || strings.HasPrefix(part, "学び:") ||
			strings.HasPrefix(part, "気づき:") || strings.HasPrefix(part, "明日:") ||
			strings.HasPrefix(part, "振り返り:")) {

			// 前のキーワードがあれば処理
			if currentKeyword.Len() > 0 {
				s.processSingleKeyword(currentKeyword.String(), strings.TrimSpace(currentValue.String()))
			}

			// 新しいキーワードを開始
			currentKeyword.Reset()
			currentValue.Reset()

			keywordParts := strings.SplitN(part, ":", 2)
			currentKeyword.WriteString(keywordParts[0])
			if len(keywordParts) > 1 {
				currentValue.WriteString(keywordParts[1])
			}
		} else {
			// 現在の値に追加
			if currentValue.Len() > 0 {
				currentValue.WriteString(" ")
			}
			currentValue.WriteString(part)
		}
	}

	// 最後のキーワードを処理
	if currentKeyword.Len() > 0 {
		s.processSingleKeyword(currentKeyword.String(), strings.TrimSpace(currentValue.String()))
	}

	// 目標達成処理
	if err := s.processGoalAchievement(content); err != nil {
		return err
	}

	return nil
}

func (s *SectionProcessor) processSingleKeyword(keyword, value string) error {
	if value == "" {
		return nil
	}

	switch keyword {
	case "目標":
		return s.appendToSection("## 🎯 今日の目標", "- [ ] "+value)
	case "進捗":
		return s.appendToSection("## 📊 進捗状況", "• "+value)
	case "学び":
		return s.appendToSection("## 💡 学びと気づき", "• "+value)
	case "気づき":
		return s.appendToSection("## 💡 学びと気づき", "• "+value)
	case "明日":
		return s.appendToSection("## 🚀 明日への申し送り", "• "+value)
	case "振り返り":
		return s.appendToSection("## 💡 学びと気づき", "• "+value)
	}

	return nil
}

func (s *SectionProcessor) processReflection(content string) error {
	re := regexp.MustCompile(`振り返り:([^学気明目進]*?)(?:\s+(?:目標:|進捗:|学び:|気づき:|明日:)|$)`)
	matches := re.FindStringSubmatch(content)
	if len(matches) > 1 {
		reflection := strings.TrimSpace(matches[1])
		if reflection != "" {
			return s.appendToSection("## 💡 学びと気づき", "• "+reflection)
		}
	}
	return nil
}

func (s *SectionProcessor) processLearning(content string) error {
	re := regexp.MustCompile(`学び:([^気明目進]*?)(?:\s+(?:目標:|進捗:|気づき:|明日:)|$)`)
	matches := re.FindAllStringSubmatch(content, -1)
	for _, match := range matches {
		if len(match) > 1 {
			learning := strings.TrimSpace(match[1])
			if learning != "" {
				if err := s.appendToSection("## 💡 学びと気づき", "• "+learning); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func (s *SectionProcessor) processInsights(content string) error {
	re := regexp.MustCompile(`気づき:([^学明目進]*?)(?:\s+(?:目標:|進捗:|学び:|明日:)|$)`)
	matches := re.FindAllStringSubmatch(content, -1)
	for _, match := range matches {
		if len(match) > 1 {
			insight := strings.TrimSpace(match[1])
			if insight != "" {
				if err := s.appendToSection("## 💡 学びと気づき", "• "+insight); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func (s *SectionProcessor) processTomorrow(content string) error {
	re := regexp.MustCompile(`明日:([^学気目進]*?)(?:\s+(?:目標:|進捗:|学び:|気づき:)|$)`)
	matches := re.FindAllStringSubmatch(content, -1)
	for _, match := range matches {
		if len(match) > 1 {
			tomorrow := strings.TrimSpace(match[1])
			if tomorrow != "" {
				if err := s.appendToSection("## 🚀 明日への申し送り", "• "+tomorrow); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func (s *SectionProcessor) processGoals(content string) error {
	re := regexp.MustCompile(`目標:([^目]+?)(?:\s+(?:目標:|進捗:|学び:|気づき:|明日:)|$)`)
	matches := re.FindAllStringSubmatch(content, -1)
	for _, match := range matches {
		if len(match) > 1 {
			goal := strings.TrimSpace(match[1])
			if goal != "" {
				if err := s.appendToSection("## 🎯 今日の目標", "- [ ] "+goal); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func (s *SectionProcessor) processProgress(content string) error {
	re := regexp.MustCompile(`進捗:([^進]+?)(?:\s+(?:目標:|進捗:|学び:|気づき:|明日:)|$)`)
	matches := re.FindAllStringSubmatch(content, -1)
	for _, match := range matches {
		if len(match) > 1 {
			progress := strings.TrimSpace(match[1])
			if progress != "" {
				if err := s.appendToSection("## 📊 進捗状況", "• "+progress); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func (s *SectionProcessor) processGoalAchievement(content string) error {
	re := regexp.MustCompile(`目標達成:(.*)`)
	matches := re.FindStringSubmatch(content)
	if len(matches) > 1 {
		goalText := strings.TrimSpace(matches[1])
		if goalText != "" {
			return s.checkDoneInGoals(goalText)
		}
	}
	return nil
}

func (s *SectionProcessor) appendToSection(sectionHeader, newContent string) error {
	fileContent, err := os.ReadFile(s.nippo.FilePath)
	if err != nil {
		return err
	}

	lines := strings.Split(string(fileContent), "\n")
	var result []string
	sectionFound := false
	insertIndex := -1

	for i, line := range lines {
		if line == sectionHeader {
			sectionFound = true
			result = append(result, line)

			// このセクションの最後の行を見つける
			j := i + 1
			for j < len(lines) {
				nextLine := lines[j]
				// 次のセクション（##で始まる）または空行が複数続く場合はセクション終了
				if strings.HasPrefix(nextLine, "## ") {
					insertIndex = j
					break
				}
				// 内容がある行の場合は追加
				if strings.TrimSpace(nextLine) != "" {
					result = append(result, nextLine)
				} else {
					// 空行の場合
					result = append(result, nextLine)
					// 次の行もチェックして、次がセクションヘッダーなら終了
					if j+1 < len(lines) && strings.HasPrefix(lines[j+1], "## ") {
						insertIndex = j + 1
						break
					}
				}
				j++
			}

			// セクションの最後に新しい内容を追加
			result = append(result, newContent)

			// セクション間の空行を確保
			if insertIndex != -1 && insertIndex < len(lines) {
				// 次がセクションヘッダーの場合、空行を追加
				if strings.HasPrefix(lines[insertIndex], "## ") {
					result = append(result, "")
				}
			}

			// 残りの行を追加
			if insertIndex != -1 {
				for k := insertIndex; k < len(lines); k++ {
					result = append(result, lines[k])
				}
			}
			break
		} else {
			result = append(result, line)
		}
	}

	if !sectionFound {
		return fmt.Errorf("section %s not found", sectionHeader)
	}

	return os.WriteFile(s.nippo.FilePath, []byte(strings.Join(result, "\n")), 0644)
}

func (s *SectionProcessor) checkDoneInGoals(goalText string) error {
	fileContent, err := os.ReadFile(s.nippo.FilePath)
	if err != nil {
		return err
	}

	lines := strings.Split(string(fileContent), "\n")

	for i, line := range lines {
		if strings.HasPrefix(line, "- [ ] ") && strings.Contains(line, goalText) {
			lines[i] = strings.Replace(line, "- [ ]", "- [x]", 1)
			break
		}
	}

	return os.WriteFile(s.nippo.FilePath, []byte(strings.Join(lines, "\n")), 0644)
}
