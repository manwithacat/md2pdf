# LaTeX Unicode Support Guide

## Current Limitation

The comprehensive markdown test file (`markdown-test-comprehensive.md`) contains extensive international character sets that require additional LaTeX configuration to render properly.

**Current Status:**
- ✅ **Chrome Backend**: Full Unicode support out-of-the-box
- ⚠️ **LaTeX Backend**: Requires font configuration for CJK/Arabic/Hebrew scripts

## What's Needed for Full Unicode Support in LaTeX

### 1. Font Packages

The LaTeX backend would need to specify fonts for different Unicode scripts:

```latex
\usepackage{fontspec}
\setmainfont{Helvetica Neue}  % Already configured

% Additional fonts for scripts
\newfontfamily\arabicfont{Arial}[Script=Arabic]
\newfontfamily\hebrewfont{Arial}[Script=Hebrew]
\newfontfamily\cjkfont{Hiragino Sans GB}
\newfontfamily\greekfont{Arial}[Script=Greek]
\newfontfamily\cyrillicfont{Arial}[Script=Cyrillic]
```

### 2. Package Requirements

Additional LaTeX packages needed:

```latex
\usepackage{polyglossia}  % Multi-language support
\setmainlanguage{english}
\setotherlanguage{arabic}
\setotherlanguage{hebrew}
\setotherlanguage{chinese}
\setotherlanguage{greek}
\setotherlanguage{russian}
```

Or simpler approach:

```latex
\usepackage{unicode-math}  % Unicode math symbols
\usepackage{bidi}          % Bidirectional text (Arabic, Hebrew)
```

### 3. Script Detection

Automatic script detection and font switching would be needed:

```latex
% Example using babel or polyglossia
\babelprovide[import, main]{english}
\babelprovide[import]{arabic}
\babelprovide[import]{hebrew}
```

### 4. Installation Commands

For users who need full Unicode support:

```bash
# Install required LaTeX packages
sudo tlmgr install polyglossia
sudo tlmgr install bidi
sudo tlmgr install unicode-math
sudo tlmgr install xecjk
sudo tlmgr install soul           # For strikethrough text support

# Or install full TeX Live
brew install --cask mactex  # ~7GB, includes everything
```

## Why Chrome is Recommended

The Chrome backend handles all of this automatically:

1. **Zero Configuration**: Works out-of-the-box on macOS
2. **System Fonts**: Uses macOS system fonts for all scripts
3. **Automatic Detection**: Browser handles script detection
4. **Full Emoji**: Native color emoji support
5. **Faster**: No TeX compilation needed

## Current Workaround

For documents with extensive Unicode:

```bash
# Use Chrome backend (recommended)
bash md2pdf your-file.md

# Or explicitly
PDF_BACKEND=chrome bash md2pdf your-file.md
```

For LaTeX-specific features (math, academic formatting):

```bash
# Use LaTeX backend with Latin/Western text only
PDF_BACKEND=tex bash md2pdf your-file.md
```

## Future Enhancement Options

### Option 1: Enhanced LaTeX Header (Complex)

Modify `scripts/md2pdf` to include comprehensive font configuration:

**Pros:**
- Full Unicode support
- Professional LaTeX typography
- Math equation support

**Cons:**
- Requires ~7GB MacTeX installation
- Slower compilation (30-60 seconds)
- Complex font configuration
- Potential font availability issues

### Option 2: Keep Chrome as Unicode Default (Current)

**Pros:**
- ✅ Zero setup
- ✅ Fast (2-5 seconds)
- ✅ Works on all Macs
- ✅ Full emoji support

**Cons:**
- Limited page-break control
- Less precise typography
- No LaTeX math equations

### Option 3: Hybrid Approach (Recommended)

Add a `PDF_LATEX_UNICODE` environment variable:

```bash
# Standard LaTeX (current behavior)
PDF_BACKEND=tex bash md2pdf file.md

# Enhanced LaTeX with Unicode (requires MacTeX)
PDF_BACKEND=tex PDF_LATEX_UNICODE=true bash md2pdf file.md
```

This would:
1. Keep default LaTeX fast and simple
2. Offer opt-in Unicode support for advanced users
3. Show clear error message if fonts missing

## Recommendation

**For most users:** Use Chrome backend (default)
- Fast, zero setup, handles all Unicode

**For academic papers:** Use LaTeX backend with Western text
- Professional typography, math equations
- Avoid CJK/Arabic/Hebrew scripts

**For advanced users:** Install MacTeX and contribute Unicode configuration
- PR welcome to add `PDF_LATEX_UNICODE` support!

## Testing

Test which characters your LaTeX installation supports:

```bash
cat > test.tex << 'EOF'
\documentclass{article}
\usepackage{fontspec}
\setmainfont{Helvetica Neue}
\begin{document}
Latin: Hello
Greek: α β γ
Cyrillic: Привет
Chinese: 你好
Arabic: مرحبا
Hebrew: שלום
\end{document}
EOF

xelatex test.tex && open test.pdf
```

If you see blank boxes, you need additional font configuration.

## Related Files

- `scripts/md2pdf` - Main conversion script (lines 587-664: LaTeX header)
- `examples/input/markdown-test-comprehensive.md` - Comprehensive test file
- `examples/README.md` - Example documentation

---

**Last Updated:** 2024-11-07
**Version:** 3.1.0
