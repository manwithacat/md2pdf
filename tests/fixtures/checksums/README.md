# PDF Integrity Tests

Tests verify PDF output quality without relying on byte-perfect checksums.

## Purpose

The integrity tests catch issues like:
- 🎨 Broken emoji rendering (file size drops significantly)
- 🔤 Missing fonts or CSS
- 📐 Major layout/formatting regressions
- 🐛 Output quality degradation

## Testing Approach

**Size-based verification** instead of checksums:
- Chrome PDFs embed timestamps and internal IDs that vary per run
- Checksums would require constant baseline updates
- File size is a reliable proxy for content integrity

### What We Check

1. **File creation**: PDF actually generated
2. **Non-empty**: Has content (not 0 bytes)
3. **Reasonable size**: Within expected ranges:
   - `emoji-example.pdf`: > 50KB (emoji rendering adds size)
   - `simple-example.pdf`: 30KB - 200KB (basic content)
   - `table-example.pdf`: > 30KB (tables with styling)

## Why Not Checksums?

Chrome PDFs are **intentionally non-deterministic**:
- Embedded creation timestamps
- Internal document IDs
- Font rendering cache keys
- Layout engine state

Even with flags like `--virtual-time-budget`, output varies slightly.

### When to Update Baseline

Update checksums when:

1. **Intentional changes**: New features, improved formatting
2. **Dependency updates**: Chrome, Pandoc, Typst version changes
3. **Backend switches**: Switching between Chrome/Typst/LaTeX
4. **Environment changes**: Different OS, fonts, or system libraries

```bash
# Regenerate baseline
PDF_AUTO_OPEN=false ./scripts/md2pdf examples/input/*.md
shasum -a 256 examples/input/*.pdf > tests/fixtures/checksums/baseline.sha256
```

### Alternative: Content-Based Verification

For more stable testing, consider:

1. **PDF text extraction**: Verify text content with `pdftotext`
2. **Image comparison**: Visual regression testing with `pdftoppm` + ImageMagick
3. **Metadata stripping**: Remove timestamps before hashing
4. **LaTeX backend**: More deterministic output (no timestamps)

## Running Tests

```bash
# Run checksum verification only
make test-integrity

# Run all tests (includes checksums)
make test
```

## Test Output

**Pass:** Checksums match baseline
```
✓ emoji-example.pdf matches baseline
```

**Fail:** Checksums differ
```
✗ emoji-example.pdf checksum mismatch
  Expected: 90ac49a213a3dd17...
  Actual:   b6355f1fb638400d...
```

## Limitations

- **Not byte-perfect**: Chrome PDFs vary slightly between runs
- **Metadata sensitive**: Creation dates, file paths embedded in PDFs
- **Platform dependent**: May differ between macOS versions
- **False positives**: Cosmetic changes trigger failures

Consider this test as a **smoke test** rather than strict verification.
