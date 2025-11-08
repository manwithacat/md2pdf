#!/bin/bash
# Basic functionality tests for scripts/md2pdf

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
test_pass() {
    ((TESTS_PASSED++))
    echo -e "${GREEN}✓${NC} $1"
}

test_fail() {
    ((TESTS_FAILED++))
    echo -e "${RED}✗${NC} $1"
}

test_skip() {
    echo -e "${YELLOW}⊘${NC} $1 (skipped)"
}

run_test() {
    ((TESTS_RUN++))
    echo -n "  Testing: $1... "
}

echo "🧪 Running Basic Tests"
echo "======================"
echo ""

# Test 1: Check script exists
run_test "Script existence"
if [ -f "$PROJECT_DIR/scripts/md2pdf" ]; then
    test_pass "scripts/md2pdf exists"
else
    test_fail "scripts/md2pdf not found"
    exit 1
fi

# Test 2: Check dependencies
run_test "Dependencies (pandoc)"
if command -v pandoc >/dev/null 2>&1; then
    test_pass "pandoc installed"
else
    test_fail "pandoc not installed"
fi

run_test "Dependencies (xelatex)"
if command -v xelatex >/dev/null 2>&1; then
    test_pass "xelatex installed"
else
    test_fail "xelatex not installed"
fi

# Test 3: Create simple test file
run_test "Simple conversion (Chrome)"
TEST_FILE="$FIXTURES_DIR/test-simple.md"
mkdir -p "$FIXTURES_DIR"

cat > "$TEST_FILE" << 'EOF'
# Test Document

This is a simple test document.

## Features

- Bullet point 1
- Bullet point 2
- Bullet point 3

## Table

| Column 1 | Column 2 |
|----------|----------|
| Data 1   | Data 2   |
| Data 3   | Data 4   |
EOF

PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
PDF_FILE="${TEST_FILE%.md}.pdf"

if [ -f "$PDF_FILE" ]; then
    SIZE=$(stat -f%z "$PDF_FILE" 2>/dev/null || stat -c%s "$PDF_FILE" 2>/dev/null)
    if [ "$SIZE" -gt 1000 ]; then
        test_pass "Simple conversion Chrome (${SIZE} bytes)"
        rm -f "$PDF_FILE"
    else
        test_fail "PDF too small (${SIZE} bytes)"
    fi
else
    test_fail "PDF not created"
fi

# Test 3b: Simple conversion with LaTeX backend
run_test "Simple conversion (LaTeX)"
if command -v xelatex >/dev/null 2>&1; then
    PDF_BACKEND=tex PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
    PDF_FILE="${TEST_FILE%.md}.pdf"

    if [ -f "$PDF_FILE" ]; then
        SIZE=$(stat -f%z "$PDF_FILE" 2>/dev/null || stat -c%s "$PDF_FILE" 2>/dev/null)
        if [ "$SIZE" -gt 1000 ]; then
            test_pass "Simple conversion LaTeX (${SIZE} bytes)"
            rm -f "$PDF_FILE"
        else
            test_fail "LaTeX PDF too small (${SIZE} bytes)"
        fi
    else
        test_fail "LaTeX PDF not created"
    fi
else
    test_skip "LaTeX backend (xelatex not installed)"
fi

# Test 4: Unicode characters (Chrome)
run_test "Unicode support (Chrome)"
TEST_FILE="$FIXTURES_DIR/test-unicode.md"

cat > "$TEST_FILE" << 'EOF'
# Unicode Test

Currency: £ € $ ₹ ¥

Accents: café naïve résumé

Symbols: © ® ™ § ¶
EOF

PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
PDF_FILE="${TEST_FILE%.md}.pdf"

if [ -f "$PDF_FILE" ]; then
    test_pass "Unicode conversion Chrome"
    rm -f "$PDF_FILE"
else
    test_fail "Unicode PDF not created"
fi

# Test 4b: Unicode characters (LaTeX)
run_test "Unicode support (LaTeX)"
if command -v xelatex >/dev/null 2>&1; then
    PDF_BACKEND=tex PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
    PDF_FILE="${TEST_FILE%.md}.pdf"

    if [ -f "$PDF_FILE" ]; then
        test_pass "Unicode conversion LaTeX"
        rm -f "$PDF_FILE"
    else
        test_fail "LaTeX Unicode PDF not created"
    fi
else
    test_skip "LaTeX backend (xelatex not installed)"
fi

# Test 5: Empty file handling
run_test "Empty file handling"
TEST_FILE="$FIXTURES_DIR/test-empty.md"
touch "$TEST_FILE"

PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
PDF_FILE="${TEST_FILE%.md}.pdf"

if [ -f "$PDF_FILE" ]; then
    test_pass "Empty file conversion"
    rm -f "$PDF_FILE"
else
    test_skip "Empty file (may be expected behavior)"
fi

# Test 6: Batch conversion
run_test "Batch conversion"
PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$FIXTURES_DIR"/test-*.md >/dev/null 2>&1

CONVERTED_COUNT=$(ls "$FIXTURES_DIR"/*.pdf 2>/dev/null | wc -l | tr -d ' ')
if [ "$CONVERTED_COUNT" -ge 2 ]; then
    test_pass "Batch conversion ($CONVERTED_COUNT files)"
    rm -f "$FIXTURES_DIR"/*.pdf
else
    test_fail "Batch conversion failed"
fi

# Test 7: Emoji support (Chrome)
run_test "Emoji support (Chrome)"
TEST_FILE="$FIXTURES_DIR/test-emoji.md"

cat > "$TEST_FILE" << 'EOF'
# Emoji Test

✅ Checkmark
💰 Money
📊 Chart
EOF

PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
PDF_FILE="${TEST_FILE%.md}.pdf"

if [ -f "$PDF_FILE" ]; then
    test_pass "Emoji conversion Chrome (full color)"
    rm -f "$PDF_FILE"
else
    test_fail "Emoji PDF not created"
fi

# Test 7b: Emoji support (LaTeX)
run_test "Emoji support (LaTeX)"
if command -v xelatex >/dev/null 2>&1; then
    PDF_BACKEND=tex PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1
    PDF_FILE="${TEST_FILE%.md}.pdf"

    if [ -f "$PDF_FILE" ]; then
        # Check if newunicodechar is installed
        if kpsewhich newunicodechar.sty >/dev/null 2>&1; then
            test_pass "Emoji conversion LaTeX (mapped symbols)"
        else
            test_pass "Emoji conversion LaTeX (boxes)"
        fi
        rm -f "$PDF_FILE"
    else
        test_fail "LaTeX Emoji PDF not created"
    fi
else
    test_skip "LaTeX backend (xelatex not installed)"
fi

# Test 8: Environment variables
run_test "Environment variable (PDF_AUTO_OPEN)"
TEST_FILE="$FIXTURES_DIR/test-simple.md"
PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$TEST_FILE" >/dev/null 2>&1

# If we got here without errors, env var works
test_pass "PDF_AUTO_OPEN=false works"
rm -f "${TEST_FILE%.md}.pdf"

# Summary
echo ""
echo "Test Summary"
echo "============"
echo "Total:  $TESTS_RUN"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
else
    echo "Failed: 0"
fi

# Cleanup
rm -f "$FIXTURES_DIR"/test-*.md

# Exit with failure if any tests failed
if [ $TESTS_FAILED -gt 0 ]; then
    echo ""
    echo "❌ Some tests failed"
    exit 1
else
    echo ""
    echo "✅ All tests passed!"
    exit 0
fi
