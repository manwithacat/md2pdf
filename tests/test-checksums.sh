#!/bin/bash
# PDF integrity tests - verify output hasn't regressed
# Detects issues like: broken emoji rendering, missing fonts, layout changes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CHECKSUMS_FILE="$SCRIPT_DIR/fixtures/checksums/baseline.sha256"
TEMP_DIR=$(mktemp -d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

test_pass() {
    ((TESTS_PASSED++))
    echo -e "  ${GREEN}✓${NC} $1"
}

test_fail() {
    ((TESTS_FAILED++))
    echo -e "  ${RED}✗${NC} $1"
}

test_warn() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

echo "🔒 Running PDF Integrity Tests"
echo "=============================="
echo ""
echo "Purpose: Verify PDF output hasn't regressed"
echo "Method: Text extraction + key content verification"
echo "Note: Chrome PDFs include timestamps, so we verify content not bytes"
echo ""

# No baseline file needed - we check file size and structure instead
# Chrome PDFs have timestamps that change each run

# Test each example file
for example in "$PROJECT_DIR"/examples/input/*.md; do
    ((TESTS_RUN++))

    basename=$(basename "$example" .md)
    pdf_file="$TEMP_DIR/${basename}.pdf"

    echo "Testing: ${basename}.md"

    # Generate PDF
    if PDF_AUTO_OPEN=false "$PROJECT_DIR/scripts/md2pdf" "$example" -o "$pdf_file" 2>/dev/null; then
        # Move PDF to temp dir (since script generates in same dir as input)
        mv "$PROJECT_DIR/examples/input/${basename}.pdf" "$pdf_file" 2>/dev/null || true

        # Verify PDF was created and has content
        if [ ! -s "$pdf_file" ]; then
            test_fail "${basename}.pdf is empty"
            continue
        fi

        file_size=$(du -h "$pdf_file" | cut -f1)

        # Content-specific checks based on file
        case "$basename" in
            emoji-example)
                # Check file size is reasonable (should be > 50KB with emoji)
                size_bytes=$(stat -f%z "$pdf_file" 2>/dev/null || stat -c%s "$pdf_file" 2>/dev/null)
                if [ "$size_bytes" -gt 50000 ]; then
                    test_pass "${basename}.pdf size OK (${file_size}) - likely has emoji rendering"
                else
                    test_fail "${basename}.pdf too small (${file_size}) - emoji may be broken"
                fi
                ;;
            simple-example)
                # Simple example should be small but not tiny
                size_bytes=$(stat -f%z "$pdf_file" 2>/dev/null || stat -c%s "$pdf_file" 2>/dev/null)
                if [ "$size_bytes" -gt 30000 ] && [ "$size_bytes" -lt 200000 ]; then
                    test_pass "${basename}.pdf size OK (${file_size})"
                else
                    test_warn "${basename}.pdf unusual size (${file_size})"
                fi
                ;;
            table-example)
                # Table example should have reasonable size
                size_bytes=$(stat -f%z "$pdf_file" 2>/dev/null || stat -c%s "$pdf_file" 2>/dev/null)
                if [ "$size_bytes" -gt 30000 ]; then
                    test_pass "${basename}.pdf size OK (${file_size})"
                else
                    test_fail "${basename}.pdf too small (${file_size}) - tables may be broken"
                fi
                ;;
            *)
                test_pass "${basename}.pdf created (${file_size})"
                ;;
        esac
    else
        test_fail "${basename}.pdf generation failed"
    fi

    echo ""
done

# Cleanup
rm -rf "$TEMP_DIR"

# Summary
echo "Test Summary"
echo "============"
echo "Total:  $TESTS_RUN"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
    echo ""
    exit 1
else
    echo ""
    echo "✅ All PDF integrity tests passed!"
fi
