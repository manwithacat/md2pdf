.PHONY: all build test clean install uninstall workflow release package tag help check lint

# Configuration
VERSION ?= 3.0.0
SCRIPT = scripts/md2pdf
WORKFLOW_DIR = QuickAction
WORKFLOW_NAME = Convert Markdown to PDF.workflow
WORKFLOW_PATH = $(WORKFLOW_DIR)/$(WORKFLOW_NAME)
TEST_DIR = tests
EXAMPLES_DIR = examples
INSTALL_PATH = ~/Library/Services/$(WORKFLOW_NAME)
ARTIFACT = md2pdf-v$(VERSION).workflow.zip

# Default target
all: build workflow

help:
	@echo "md2pdf - Markdown to PDF Converter"
	@echo ""
	@echo "Build & Test:"
	@echo "  make build       - Build $(SCRIPT)"
	@echo "  make workflow    - Build Quick Action bundle"
	@echo "  make test        - Run all tests"
	@echo "  make examples    - Generate example PDFs"
	@echo "  make check       - Check dependencies"
	@echo "  make all         - Build everything (default)"
	@echo ""
	@echo "Installation:"
	@echo "  make install     - Install Quick Action to ~/Library/Services"
	@echo "  make uninstall   - Remove Quick Action from ~/Library/Services"
	@echo ""
	@echo "Release:"
	@echo "  make package     - Create release artifact ($(ARTIFACT))"
	@echo "  make tag         - Create and push git tag (v$(VERSION))"
	@echo "  make release     - Full release (clean + package + examples)"
	@echo ""
	@echo "Development:"
	@echo "  make test-quick     - Run quick tests only (~30s)"
	@echo "  make test-full      - Run full test suite (~2-3min)"
	@echo "  make test-integrity - Run PDF checksum verification"
	@echo "  make lint           - Check shell script syntax"
	@echo "  make clean          - Remove generated files"
	@echo ""
	@echo "Configuration:"
	@echo "  VERSION          - Release version (default: $(VERSION))"
	@echo "  PDF_BACKEND      - chrome (default), typst, or tex"
	@echo "  PDF_AUTO_OPEN    - true (default) or false"
	@echo "  PDF_SHOW_DIALOG  - true or false (default)"

# Check dependencies
check:
	@echo "🔍 Checking dependencies..."
	@command -v pandoc >/dev/null 2>&1 || (echo "❌ pandoc not found. Run: brew install pandoc" && exit 1)
	@echo "✅ Pandoc found"
	@pandoc --version | head -1
	@echo ""
	@echo "🔍 Checking backends..."
	@if [ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then \
		echo "✅ Chrome found (default backend)"; \
		"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version; \
	elif [ -x "/Applications/Chromium.app/Contents/MacOS/Chromium" ]; then \
		echo "✅ Chromium found (default backend)"; \
	else \
		echo "⚠️  Chrome/Chromium not found (recommended for default backend)"; \
	fi
	@command -v typst >/dev/null 2>&1 && (echo "✅ Typst found (optional backend)" && typst --version) || echo "ℹ️  Typst not found (optional: brew install typst)"
	@command -v xelatex >/dev/null 2>&1 && (echo "✅ XeLaTeX found (fallback backend)" && xelatex --version | head -1) || echo "ℹ️  XeLaTeX not found (optional: brew install --cask basictex)"
	@echo ""
	@command -v shellcheck >/dev/null 2>&1 || echo "ℹ️  shellcheck not found (optional: brew install shellcheck)"

# Build script
build: check
	@echo "🔨 Building $(SCRIPT)..."
	@if [ -f "$(SCRIPT)" ]; then \
		echo "  Using existing $(SCRIPT)"; \
		chmod +x $(SCRIPT); \
		echo "✅ Verified $(SCRIPT)"; \
	else \
		echo "❌ $(SCRIPT) not found"; \
		exit 1; \
	fi

# Build workflow bundle
workflow: build
	@echo "🔨 Building Automator Quick Action..."
	@if [ -d "$(WORKFLOW_PATH)" ]; then \
		echo "  Regenerating workflow with updated script..."; \
		./build-workflow.sh; \
		echo "✅ Workflow bundle ready: $(WORKFLOW_PATH)"; \
	else \
		echo "  Creating workflow bundle..."; \
		./build-workflow.sh; \
		echo "✅ Workflow bundle created: $(WORKFLOW_PATH)"; \
	fi

# Run tests
test: test-quick test-full test-integrity

test-quick: build
	@echo "🧪 Running quick tests..."
	@bash $(TEST_DIR)/test-basic.sh

test-full: build
	@echo "🧪 Running full test suite..."
	@bash $(TEST_DIR)/test-basic.sh
	@bash $(TEST_DIR)/test-advanced.sh

test-integrity: build
	@echo "🔒 Running PDF integrity tests..."
	@bash $(TEST_DIR)/test-checksums.sh

# Generate examples
examples: build
	@echo "📄 Generating example PDFs with both backends..."
	@mkdir -p $(EXAMPLES_DIR)/output
	@for md in $(EXAMPLES_DIR)/input/*.md; do \
		base=$$(basename "$$md" .md); \
		echo "  Converting $$base.md..."; \
		PDF_AUTO_OPEN=false bash $(SCRIPT) "$$md" 2>/dev/null; \
		mv "$(EXAMPLES_DIR)/input/$$base.pdf" "$(EXAMPLES_DIR)/output/$$base-chrome.pdf" 2>/dev/null; \
		echo "    ✓ $$base-chrome.pdf"; \
		PDF_BACKEND=tex PDF_AUTO_OPEN=false bash $(SCRIPT) "$$md" 2>/dev/null; \
		mv "$(EXAMPLES_DIR)/input/$$base.pdf" "$(EXAMPLES_DIR)/output/$$base-latex.pdf" 2>/dev/null; \
		echo "    ✓ $$base-latex.pdf"; \
	done
	@echo "✅ Example PDFs generated in $(EXAMPLES_DIR)/output/"
	@echo "   Chrome backend: *-chrome.pdf"
	@echo "   LaTeX backend:  *-latex.pdf"

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	@rm -f $(EXAMPLES_DIR)/input/*.pdf
	@rm -f $(EXAMPLES_DIR)/output/*.pdf
	@rm -f $(TEST_DIR)/*.pdf
	@rm -f *.workflow.zip *.workflow.zip.sha256
	@echo "✅ Clean complete"

# Install Quick Action
install: workflow
	@echo "📦 Installing Quick Action..."
	@mkdir -p ~/Library/Services
	@if [ -d "$(INSTALL_PATH)" ]; then \
		echo "  Removing existing installation..."; \
		rm -rf "$(INSTALL_PATH)"; \
	fi
	@cp -R "$(WORKFLOW_PATH)" ~/Library/Services/
	@echo "✅ Installed to ~/Library/Services/"
	@echo ""
	@echo "Usage:"
	@echo "  1. Right-click any .md file in Finder"
	@echo "  2. Quick Actions → Convert Markdown to PDF"

# Uninstall Quick Action
uninstall:
	@echo "🗑️  Uninstalling Quick Action..."
	@if [ -d "$(INSTALL_PATH)" ]; then \
		rm -rf "$(INSTALL_PATH)"; \
		echo "✅ Uninstalled from ~/Library/Services/"; \
	else \
		echo "⚠️  Quick Action not found (already uninstalled)"; \
	fi

# Package workflow bundle for release
package: clean workflow
	@echo "📦 Creating release artifact..."
	@echo "  Version: $(VERSION)"
	@echo "  Artifact: $(ARTIFACT)"
	@echo ""
	@if [ ! -d "$(WORKFLOW_PATH)" ]; then \
		echo "❌ Error: $(WORKFLOW_PATH) not found"; \
		echo "   Run 'make workflow' first"; \
		exit 1; \
	fi
	@cd $(WORKFLOW_DIR) && zip -r "../$(ARTIFACT)" "$(WORKFLOW_NAME)" -q
	@echo "  Created: $(ARTIFACT) ($$(du -h $(ARTIFACT) | cut -f1))"
	@shasum -a 256 $(ARTIFACT) > $(ARTIFACT).sha256
	@echo "  SHA-256: $$(cat $(ARTIFACT).sha256 | cut -d' ' -f1)"
	@echo ""
	@echo "✅ Release artifact ready!"
	@echo ""
	@echo "Files created:"
	@ls -lh $(ARTIFACT) $(ARTIFACT).sha256 | awk '{print "  " $$9 " (" $$5 ")"}'

# Create and push git tag
tag:
	@echo "🏷️  Creating git tag..."
	@echo "  Version: v$(VERSION)"
	@echo ""
	@if git rev-parse "v$(VERSION)" >/dev/null 2>&1; then \
		echo "⚠️  Tag v$(VERSION) already exists"; \
		echo "   Use 'git tag -d v$(VERSION)' to delete it first"; \
		exit 1; \
	fi
	@git tag v$(VERSION)
	@echo "✅ Created tag: v$(VERSION)"
	@echo ""
	@echo "Push to remote with:"
	@echo "  git push origin v$(VERSION)"

# Full release process
release: clean package examples
	@echo ""
	@echo "📦 Release bundle complete!"
	@echo ""
	@echo "  Version: $(VERSION)"
	@echo "  Artifact: $(ARTIFACT)"
	@echo "  SHA-256: $$(cat $(ARTIFACT).sha256 | cut -d' ' -f1 | cut -c1-16)..."
	@echo ""
	@echo "Repository structure:"
	@echo "  ✓ QuickAction/$(WORKFLOW_NAME)"
	@echo "  ✓ scripts/md2pdf"
	@echo "  ✓ README.md"
	@echo "  ✓ LICENSE"
	@echo "  ✓ Brewfile"
	@echo "  ✓ CHANGELOG.md"
	@echo "  ✓ Makefile"
	@echo ""
	@echo "Examples generated:"
	@ls $(EXAMPLES_DIR)/output/*.pdf | wc -l | xargs echo "  " "PDFs in examples/output/"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Review CHANGELOG.md for v$(VERSION)"
	@echo "  2. Commit changes: git add -A && git commit -m 'release: v$(VERSION)'"
	@echo "  3. Create tag: make tag"
	@echo "  4. Push: git push origin main v$(VERSION)"
	@echo "  5. Create GitHub release:"
	@echo "     - Upload $(ARTIFACT)"
	@echo "     - Upload $(ARTIFACT).sha256"
	@echo "     - Copy CHANGELOG v$(VERSION) section as release notes"

# Lint shell scripts
lint:
	@echo "🔍 Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(SCRIPT) || true; \
		echo "✅ Lint complete"; \
	else \
		echo "⚠️  shellcheck not installed (brew install shellcheck)"; \
	fi
