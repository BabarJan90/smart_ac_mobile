SHELL := /bin/bash

# Declare phony targets (these are commands, not files)
.PHONY: init gen get clean install-hooks check-hooks test-hooks test
# Color Ref: https://linuxhandbook.com/change-echo-output-color/
R='\033[0;31m'   #'0;31' is Red's ANSI color code
G='\033[0;32m'   #'0;32' is Green's ANSI color code
Y='\033[1;32m'   #'1;32' is Yellow's ANSI color code
B='\033[0;34m'   #'0;34' is Blue's ANSI color code
NOCOLOR='\033[0m'

PUBSPEC_FILES := $(shell find . -name 'pubspec.yaml')
MAKE_FILES := $(shell find . -mindepth 1 -name 'Makefile')

init: get gen
	cd app/ios && pod update && pod install
	@echo "${G}Finished Project Setup${NOCOLOR}"

gen:
	@for file in $(PUBSPEC_FILES); do \
		cd $${file%pubspec.yaml} && \
		pwd && \
		dart run build_runner build --delete-conflicting-outputs && \
		cd "$$OLDPWD"; \
	done
	@echo "${G}Build runner completed successfully${NOCOLOR}"

get:
	@for file in $(PUBSPEC_FILES); do \
		echo "Processing $$file"; \
		cd $${file%pubspec.yaml} && \
		flutter pub get && \
		cd "$$OLDPWD"; \
	done
	@echo "${G}Flutter pub get completed successfully${NOCOLOR}"

clean:
	@for file in $(PUBSPEC_FILES); do \
		cd $${file%pubspec.yaml} && \
		pwd && \
		flutter clean && \
		cd "$$OLDPWD"; \
	done
	@echo "${G}Flutter clean completed successfully${NOCOLOR}"

# Install git hooks
install-hooks:
	@echo "📋 Installing git hooks..."
	@cp .githooks/pre-commit .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@git config --local core.hooksPath .git/hooks
	@echo "✅ Git hooks installed successfully!"
	@echo ""
	@echo "💡 Hooks will now run automatically on every commit"
	@echo "   Test with: git commit --allow-empty -m \"test(setup): verify hooks\""

# Verify hooks are installed
check-hooks:
	@if [ -f .git/hooks/pre-commit ]; then \
		echo "✅ Git hooks are installed"; \
	else \
		echo "❌ Git hooks are NOT installed"; \
		echo "   Run: make install-hooks"; \
	fi

# Test commit (to verify hooks work)
test-hooks:
	@echo "🧪 Testing pre-commit hooks..."
	@git commit --allow-empty -m "test(setup): verify hooks work"

# Run tests
test:
	@for file in $(PUBSPEC_FILES); do \
		cd $${file%pubspec.yaml} && \
		pwd && \
		flutter test --no-pub --coverage; \
		if [ $$? -ne 0 ]; then \
			exit 1; \
		fi; \
		cd "$$OLDPWD"; \
	done
	@echo "${G}Tests have passed successfully${NOCOLOR}"
#
#analyze:
#	@for file in $(PUBSPEC_FILES); do \
#		cd $${file%pubspec.yaml} && \
#		pwd && \
#		dart analyze . --fatal-infos && \
#		cd "$$OLDPWD"; \
#	done
#	@echo "${G}Analyze passed successfully${NOCOLOR}"
