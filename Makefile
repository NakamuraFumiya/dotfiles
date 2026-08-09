.PHONY: nippo-build help

# nippo関連のコマンド
nippo-build:
	@echo "Building nippo..."
	@cd $(HOME)/dotfiles/scripts/nippo-go && go build -o nippo .

help:
	@echo "Available commands:"
	@echo "  nippo-build  - Build nippo Go program"
