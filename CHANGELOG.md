# Changelog

All notable changes to md2pdf will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2025-11-07

### 🎉 Major Release - Multi-Backend Architecture

This release represents a complete architectural shift from TeX-first to Chrome-first, making md2pdf accessible to all Mac users without complex LaTeX installations.

### Added

- **Chrome/Chromium backend (default)**: Zero-setup PDF generation with headless Chrome
  - Native full-color emoji support 🎨
  - GitHub-style markdown rendering
  - Beautiful table formatting
  - No TeX installation required
- **Typst backend (optional)**: Modern typesetting engine support via `brew install typst`
- **Intelligent backend selection**: Automatic detection with priority Chrome → Typst → LaTeX
- **Backend override**: `PDF_BACKEND` environment variable for explicit backend selection
- **Brewfile**: Automated dependency management via `brew bundle`
- **Release-ready structure**: Organized layout for GitHub releases

### Changed

- **Project name**: `md2pdf` → `md2pdf` for brevity and consistency
- **Script location**: `md2pdf` → `scripts/md2pdf` (no extension, Unix convention)
- **Workflow location**: Root → `QuickAction/` directory
- **Default behavior**: Chrome backend now default (previously XeLaTeX)
- **Prerequisites**: Chrome (usually pre-installed) instead of TeX (optional fallback)
- **Documentation**: Complete rewrite emphasizing zero-setup workflow

### Deprecated

- LaTeX backend is now **optional** (was required)
- Emoji package installation (`install-emoji-support.sh`) only needed for LaTeX backend

### Migration Guide

**For existing users:**

1. **No action required** - Chrome backend works with existing installations
2. **Optional**: Set preferred backend in `~/.zshrc`:
   ```bash
   export PDF_BACKEND=chrome  # default
   export PDF_BACKEND=typst   # requires: brew install typst
   export PDF_BACKEND=tex     # existing LaTeX workflow
   ```
3. **Optional**: Install via Brewfile:
   ```bash
   brew bundle  # Install pandoc and optional backends
   ```

**For new users:**

Install is now just:
```bash
brew install pandoc
# That's it! Chrome already installed on most Macs
```

### Technical Details

- **Lines of code**: 434 (was 196) - includes Chrome HTML/CSS styling and Typst support
- **Test coverage**: 9/9 tests passing (all backends verified)
- **Dependencies**: Pandoc (required), Chrome/Chromium (default), Typst (optional), TeX (optional)
- **Supported macOS**: 10.15+ (requires headless Chrome support)

---

## [2.2.0] - 2025-11-06

### Added
- Emoji support documentation and installation script
- `install-emoji-support.sh` for automated LaTeX package installation
- Comprehensive emoji mapping table (12 common emoji)

### Changed
- Enhanced README with emoji support section
- Updated troubleshooting guide for emoji rendering

---

## [2.1.0] - 2025-11-06

### Changed
- **Project rename**: `automator.sh` → `md2pdf` throughout entire codebase
- Updated all documentation (11 markdown files)
- Updated all test scripts (2 test suites)
- Regenerated workflow bundle with new script name

### Fixed
- Test suite now references correct script name
- Build system uses consistent naming

---

## [2.0.0] - 2025-11-05

### Added
- Comprehensive Makefile build system (15+ targets)
- Automated test suite (16 tests: 8 basic, 8 advanced)
- Example PDF generation system
- Pre-built Quick Action workflow bundle
- Professional table formatting (60% more content per page)
- Three notification modes (auto-open, dialog, quiet)
- Batch processing support
- Extensive documentation suite (11 files)

### Technical Improvements
- XeLaTeX with custom LaTeX headers
- Optimized table formatting (8pt font, 4pt padding)
- Unicode support via Helvetica Neue
- Multi-page table support with repeated headers
- Clickable links (blue styling)

---

## [1.0.0] - Initial Release

### Added
- Basic Markdown to PDF conversion via Pandoc + XeLaTeX
- macOS Finder Quick Action integration
- Simple notification system
- A4 paper size with custom margins

---

## Version History

- **v3.0.0** (2025-11-07): Multi-backend architecture (Chrome/Typst/LaTeX)
- **v2.2.0** (2025-11-06): Emoji support
- **v2.1.0** (2025-11-06): Rename to md2pdf
- **v2.0.0** (2025-11-05): Professional build system and testing
- **v1.0.0**: Initial release
