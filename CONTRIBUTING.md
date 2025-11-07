# Contributing to Markdown to PDF Converter

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## 🤝 How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:

1. **Clear title**: Brief description of the issue
2. **Steps to reproduce**: Detailed steps to reproduce the behavior
3. **Expected behavior**: What you expected to happen
4. **Actual behavior**: What actually happened
5. **Environment**:
   - macOS version (e.g., Sonoma 14.1)
   - Pandoc version (`pandoc --version`)
   - XeLaTeX version (`xelatex --version`)
   - BasicTeX or MacTeX
6. **Sample Markdown**: Minimal Markdown file that reproduces the issue
7. **Error output**: Full error output if applicable

**Example**:
```markdown
## Bug: Tables with 10+ columns overflow page

**Steps to reproduce:**
1. Create Markdown file with 10-column table
2. Run `bash md2pdf test.md`
3. Open generated PDF

**Expected:** Table fits within page margins
**Actual:** Table extends beyond right margin

**Environment:**
- macOS Sonoma 14.1
- Pandoc 3.1.2
- BasicTeX 2023
- Helvetica Neue font

**Sample Markdown:**
[Attach test.md]

**Error output:**
[Attach error log if applicable]
```

### Suggesting Features

Feature requests are welcome! Please create an issue with:

1. **Use case**: What problem does this solve?
2. **Proposed solution**: How should it work?
3. **Alternatives considered**: Other approaches you've thought about
4. **Examples**: Similar features in other tools

**Example**:
```markdown
## Feature Request: Custom CSS Styling

**Use case:** I want to apply custom CSS styles to specific elements (headings, code blocks)

**Proposed solution:**
- Add `--css` flag to accept custom CSS file
- Inject CSS into Pandoc conversion
- Document supported CSS properties

**Alternatives considered:**
- Edit LaTeX header directly (too technical)
- Use Pandoc variables (limited styling options)

**Examples:**
- Marked 2 supports custom CSS
- md-to-pdf allows CSS injection
```

### Pull Requests

We love pull requests! Here's the process:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** (see guidelines below)
4. **Test thoroughly** (see testing section)
5. **Commit with clear messages** (see commit guidelines)
6. **Push to your fork**: `git push origin feature/your-feature-name`
7. **Create a pull request** with:
   - Clear title and description
   - Link to related issue (if applicable)
   - Screenshots/examples (if UI changes)
   - Test results

## 🎯 Development Guidelines

### Code Style

#### Shell Script (md2pdf)

- **POSIX compliance**: Target POSIX-compliant shell (for portability)
- **Error handling**: Always check command exit codes
- **Comments**: Document complex logic
- **Variables**: Use descriptive names, UPPERCASE for environment variables
- **Quotes**: Always quote variables (`"$var"` not `$var`)
- **Functions**: Use functions for repeated logic

**Good**:
```bash
# Check if file exists before processing
if [ -f "$input_file" ]; then
    process_file "$input_file"
else
    echo "Error: File not found: $input_file" >&2
    exit 1
fi
```

**Bad**:
```bash
# No error checking
process_file $input_file
```

#### LaTeX Headers

- **Comments**: Document each package and customization
- **Organization**: Group related configurations
- **Fallbacks**: Provide graceful fallbacks for optional packages

**Good**:
```latex
% Emoji support (requires: sudo tlmgr install newunicodechar)
\IfFileExists{newunicodechar.sty}{
  \usepackage{newunicodechar}
  \newunicodechar{✅}{✓}
}{
  % Fallback: emojis render as empty boxes
}
```

### Testing

Before submitting a PR, test with:

1. **Basic conversion**:
   ```bash
   bash md2pdf test-complex-tables.md
   ```

2. **Batch conversion**:
   ```bash
   bash md2pdf *.md
   ```

3. **Edge cases**:
   - Empty Markdown file
   - Very large tables (10+ columns)
   - Unicode characters (£, €, $, ₹, ¥, café)
   - Emojis (with and without newunicodechar)
   - Multi-page content

4. **Environment variables**:
   ```bash
   PDF_AUTO_OPEN=false bash md2pdf test.md
   PDF_SHOW_DIALOG=true bash md2pdf test.md
   ```

5. **Different macOS versions** (if possible):
   - Test on at least macOS 12+ (Monterey or later)

### Documentation

When adding features:

1. **Update README.md**: Add feature to Features section
2. **Update CLAUDE.md** (if architectural changes)
3. **Create separate guide** (if complex feature)
4. **Add examples**: Show practical usage
5. **Update troubleshooting**: Add common issues

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): brief description

Detailed explanation (optional)

Fixes #issue-number (if applicable)
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Add/update tests
- `chore`: Maintenance (dependencies, build)

**Examples**:
```
feat(emoji): add support for 10 new emoji mappings

Added mappings for commonly used emojis in technical documentation:
🚀, ⚡, 🎯, 🔧, 📦, 🐛, 🔍, 🎨, 🔒, 🌐

Fixes #42
```

```
fix(tables): prevent column overlap in 8+ column tables

Reduced column padding from 4pt to 3pt for tables with 8 or more columns.
This prevents text overlap while maintaining readability.

Fixes #38
```

```
docs(readme): add Windows installation instructions

Added section documenting WSL-based installation process for Windows users.
Includes prerequisites, installation steps, and common issues.
```

## 🎯 Priority Contributions

We especially welcome contributions in these areas:

### 1. Windows Support ⭐⭐⭐

**Goal**: Create a Windows version of `md2pdf`

**Approaches**:
- **Option A**: PowerShell script for native Windows
- **Option B**: Bash script for WSL (Windows Subsystem for Linux)
- **Option C**: Both (recommended)

**Requirements**:
- Use Pandoc for Windows
- Use MiKTeX or TeX Live for Windows
- Support Windows file paths
- Provide Windows-native notifications
- Document installation process

**Bonus**:
- Right-click context menu integration
- Windows Quick Action equivalent

**File to create**: `automator.ps1` (PowerShell) or `automator-windows.sh` (WSL)

### 2. Additional Emoji Mappings ⭐⭐

#### (Claude generated the rest of this stuff. Some of it sounds interesting)

**Goal**: Expand emoji support to 50+ common emojis

**Process**:
1. Find Unicode symbols that work in Helvetica Neue
2. Add to `md2pdf` (lines 35-46)
3. Test rendering in PDF
4. Document in `EMOJI_SUPPORT.md`

**Popular emojis to add**:
```
🚀 🎯 ⚡ 🔧 📦 🐛 🔍 🎨 🔒 🌐
⚠️ 🔔 📢 🎓 🏆 💡 📌 🔗 📬 📈
```

### 3. GUI Application ⭐

**Goal**: Native macOS app or Electron app

**Features**:
- Drag-and-drop Markdown files
- Live PDF preview
- Batch conversion
- Configuration UI
- Template selection

**Technologies**:
- Swift/SwiftUI (native macOS)
- Electron (cross-platform)
- Tauri (Rust-based, lightweight)

### 4. Custom Styling ⭐⭐

**Goal**: Allow users to customize PDF appearance

**Features**:
- Custom fonts
- Color schemes
- Heading styles
- Code block styling
- Page layouts (A4, Letter, Legal)

**Implementation**:
- Configuration file (YAML or JSON)
- Command-line flags
- Environment variables

### 5. Watch Mode ⭐

**Goal**: Auto-convert on file changes

**Features**:
- Monitor directory for `.md` file changes
- Auto-convert when file is saved
- Debounce (don't convert on every keystroke)
- Optional desktop notification

**Implementation**:
- Use `fswatch` (macOS) or equivalent
- Background daemon mode

## 🔄 Development Workflow

### Setting Up Development Environment

```bash
# Fork and clone
git clone https://github.com/yourusername/md2pdfscript.git
cd md2pdfscript

# Create feature branch
git checkout -b feature/my-feature

# Install dependencies (if not already installed)
brew install pandoc
brew install --cask basictex

# Optional: emoji support
sudo tlmgr install newunicodechar
```

### Making Changes

```bash
# Edit files
vim md2pdf

# Test locally
bash md2pdf test-complex-tables.md

# Check for shell script errors
shellcheck md2pdf

# Test edge cases
bash md2pdf test-empty.md
bash md2pdf test-large-tables.md
```

### Submitting Changes

```bash
# Commit with conventional commit message
git add md2pdf
git commit -m "feat(tables): add landscape mode support"

# Push to your fork
git push origin feature/my-feature

# Create pull request on GitHub
# Include description, screenshots, test results
```

## 📦 Code Review Process

1. **Automated checks**: CI/CD runs shell linting
2. **Manual review**: Maintainer reviews code
3. **Testing**: Maintainer tests on macOS
4. **Feedback**: Comments on PR
5. **Iteration**: Address feedback
6. **Approval**: Maintainer approves
7. **Merge**: Merged to main branch

## 🐞 Bug Triage

**Priority Levels**:

- **P0 - Critical**: PDF generation fails completely
- **P1 - High**: Major feature broken (tables overflow, unicode fails)
- **P2 - Medium**: Minor feature broken (emoji not rendering)
- **P3 - Low**: Enhancement or nice-to-have

## 💬 Communication

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, ideas, showcase
- **Pull Request Comments**: Code review, implementation details

## 📜 Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior**:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards others

**Unacceptable behavior**:
- Trolling, insulting/derogatory comments
- Public or private harassment
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of unacceptable behavior may be reported to the project maintainers. All complaints will be reviewed and investigated promptly and fairly.

## 📚 Resources

- [Pandoc Documentation](https://pandoc.org/MANUAL.html)
- [XeLaTeX Documentation](https://www.latex-project.org/)
- [LaTeX Package Documentation](https://ctan.org/)
- [Shell Scripting Tutorial](https://www.shellscript.sh/)

## 🙏 Thank You!

Every contribution, no matter how small, is appreciated. Whether you're:

- Fixing typos in documentation
- Reporting bugs
- Suggesting features
- Writing code
- Testing on different systems
- Sharing the project

**You make this project better!**

⭐ Don't forget to star the repo if you find it useful!

---

**Questions?** Open a [GitHub Discussion](https://github.com/yourusername/md2pdfscript/discussions) or create an [issue](https://github.com/yourusername/md2pdfscript/issues).
