package main

import (
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
	// 振り返り処理
	if err := s.processReflection(content); err != nil {
		return err
	}

	// 学び処理
	if err := s.processLearning(content); err != nil {
		return err
	}

	// 気づき処理
	if err := s.processInsights(content); err != nil {
		return err
	}

	// 明日処理
	if err := s.processTomorrow(content); err != nil {
		return err
	}

	// 目標処理
	if err := s.processGoals(content); err != nil {
		return err
	}

	// 進捗処理
	if err := s.processProgress(content); err != nil {
		return err
	}

	// 目標達成処理
	if err := s.processGoalAchievement(content); err != nil {
		return err
	}

	return nil
}

func (s *SectionProcessor) processReflection(content string) error {
	re := regexp.MustCompile(`振り返り:([^学気明目進]*)`)
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
	re := regexp.MustCompile(`学び:([^気明目進]*)`)
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
	re := regexp.MustCompile(`気づき:([^学明目進]*)`)
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
	re := regexp.MustCompile(`明日:([^学気目進]*)`)
	matches := re.FindStringSubmatch(content)
	if len(matches) > 1 {
		tomorrow := strings.TrimSpace(matches[1])
		if tomorrow != "" {
			return s.appendToSection("## 🚀 明日への申し送り", "• "+tomorrow)
		}
	}
	return nil
}

func (s *SectionProcessor) processGoals(content string) error {
	re := regexp.MustCompile(`目標:([^明進学気]*)`)
	matches := re.FindStringSubmatch(content)
	if len(matches) > 1 {
		goal := strings.TrimSpace(matches[1])
		if goal != "" {
			return s.appendToSection("## 🎯 今日の目標", "- [ ] "+goal)
		}
	}
	return nil
}

func (s *SectionProcessor) processProgress(content string) error {
	re := regexp.MustCompile(`進捗:([^学気明目]*)`)
	matches := re.FindStringSubmatch(content)
	if len(matches) > 1 {
		progress := strings.TrimSpace(matches[1])
		if progress != "" {
			return s.appendToSection("## 📊 進捗状況", "• "+progress)
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
	added := false
	i := 0

	for i < len(lines) {
		line := lines[i]
		result = append(result, line)

		if !added && line == sectionHeader {
			// 次の行を確認
			if i+1 < len(lines) {
				nextLine := lines[i+1]
				if strings.Contains(nextLine, "（本日終了時に記入）") ||
					strings.Contains(nextLine, "（随時追記）") ||
					strings.Contains(nextLine, "（後で記入）") ||
					strings.Contains(nextLine, "（セッション終了時に記入）") {
					result = append(result, nextLine)
					result = append(result, newContent)
					added = true
					i += 2 // 次の行をスキップしてさらに進む
					continue
				}
			}
		}
		i++
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
