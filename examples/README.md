# Examples

This directory contains example Markdown files and their generated PDFs.

## Structure

```
examples/
├── input/       # Source Markdown files (.md)
└── output/      # Generated PDF files (.pdf)
```

## Example Files

### `simple-example.md`
Basic Markdown conversion example with headers, paragraphs, lists, and links.

### `emoji-example.md`
Demonstrates full color emoji support 🎨 in the Chrome backend.

### `table-example.md`
Professional table formatting with booktabs-style borders and alternating row colors.

### `pagination-test.md`
Lorem ipsum test document with element type labels (H1, H2, H3, etc.) for testing pagination and styling. Includes code blocks, tables, blockquotes, and various content patterns.

### `widow-orphan-test.md`
Comprehensive test document for widow/orphan control with realistic content structures including nested headers, code blocks, tables, and technical documentation patterns.

## Generating PDFs

To regenerate all example PDFs with both backends:

```bash
make examples
```

This generates two versions of each example:
- `*-chrome.pdf` - Chrome/Chromium backend (default)
- `*-latex.pdf` - XeLaTeX backend (alternative)

### Manual Generation

For a single file with a specific backend:

```bash
# Chrome backend (default)
PDF_AUTO_OPEN=false ./scripts/md2pdf examples/input/simple-example.md

# LaTeX backend
PDF_BACKEND=tex PDF_AUTO_OPEN=false ./scripts/md2pdf examples/input/simple-example.md

# Typst backend (if installed)
PDF_BACKEND=typst PDF_AUTO_OPEN=false ./scripts/md2pdf examples/input/simple-example.md
```

## Backend Comparison

All examples are generated with both backends for comparison:

### Chrome Backend (`*-chrome.pdf`)
- ✅ Full color emoji support 🎨
- ✅ Syntax-highlighted code blocks
- ✅ Fast generation (2-5 seconds)
- ✅ Zero TeX setup required
- ✅ GitHub-style rendering

### LaTeX Backend (`*-latex.pdf`)
- ✅ Text emoji substitutions (✅ → ✓, 📄 → [⎘], etc.)
- ✅ Professional typesetting
- ✅ Academic/math document support
- ✅ Repeating table headers across pages
- ⚠️ Requires BasicTeX or MacTeX installation
