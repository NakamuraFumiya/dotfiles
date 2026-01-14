.PHONY: nippo-copy nippo-build help

# nippo関連のコマンド
nippo-copy:
	@echo "Copying nippos directory to ~/nippo..."
	@$(HOME)/dotfiles/scripts/nippo-go/nippo copy

nippo-build:
	@echo "Building nippo..."
	@cd $(HOME)/dotfiles/scripts/nippo-go && go build -o nippo .

help:
	@echo "Available commands:"
	@echo "  nippo-copy   - Copy nippos directory to ~/nippo"
	@echo "  nippo-build  - Build nippo Go program"