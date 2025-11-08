#!/bin/bash
# Advanced functionality tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

test_pass() {
    ((TESTS_PASSED++))
    echo -e "${GREEN}✓${NC} $1"
}

test_fail() {
    ((TESTS_FAILED++))
    echo -e "${RED}✗${NC} $1"
}

run_test() {
    ((TESTS_RUN++))
    echo -n "  Testing: $1... "
}

# Helper to test both backends
test_both_backends() {
    local test_name="$1"
    local test_file="$2"
    local min_size="${3:-1000}"

    # Test Chrome backend
    run_test "$test_name (Chrome)"
    PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$test_file" >/dev/null 2>&1
    PDF_FILE="${test_file%.md}.pdf"

    if [ -f "$PDF_FILE" ]; then
        SIZE=$(stat -f%z "$PDF_FILE" 2>/dev/null || stat -c%s "$PDF_FILE" 2>/dev/null)
        if [ "$SIZE" -gt "$min_size" ]; then
            test_pass "$test_name Chrome (${SIZE} bytes)"
        else
            test_fail "$test_name Chrome too small (${SIZE} bytes)"
        fi
        rm -f "$PDF_FILE"
    else
        test_fail "$test_name Chrome PDF not created"
    fi

    # Test LaTeX backend
    run_test "$test_name (LaTeX)"
    if command -v xelatex >/dev/null 2>&1; then
        PDF_BACKEND=tex PDF_AUTO_OPEN=false bash "$PROJECT_DIR/scripts/md2pdf" "$test_file" >/dev/null 2>&1
        PDF_FILE="${test_file%.md}.pdf"

        if [ -f "$PDF_FILE" ]; then
            SIZE=$(stat -f%z "$PDF_FILE" 2>/dev/null || stat -c%s "$PDF_FILE" 2>/dev/null)
            if [ "$SIZE" -gt "$min_size" ]; then
                test_pass "$test_name LaTeX (${SIZE} bytes)"
            else
                test_fail "$test_name LaTeX too small (${SIZE} bytes)"
            fi
            rm -f "$PDF_FILE"
        else
            test_fail "$test_name LaTeX PDF not created"
        fi
    else
        test_skip "$test_name LaTeX (xelatex not installed)"
    fi
}

echo "🧪 Running Advanced Tests"
echo "========================="
echo ""

mkdir -p "$FIXTURES_DIR"

# Test 1: Complex table formatting
TEST_FILE="$FIXTURES_DIR/test-complex-table.md"

cat > "$TEST_FILE" << 'EOF'
# Complex Table Test

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 |
|------|------|------|------|------|------|------|------|------|-------|
| A1   | A2   | A3   | A4   | A5   | A6   | A7   | A8   | A9   | A10   |
| B1   | B2   | B3   | B4   | B5   | B6   | B7   | B8   | B9   | B10   |
| C1   | C2   | C3   | C4   | C5   | C6   | C7   | C8   | C9   | C10   |
EOF

test_both_backends "Complex tables (10 columns)" "$TEST_FILE"

# Test 2: Long document (multi-page)
TEST_FILE="$FIXTURES_DIR/test-long.md"

{
    echo "# Long Document Test"
    echo ""
    for i in {1..100}; do
        echo "## Section $i"
        echo ""
        echo "This is section $i with some content. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        echo ""
        echo "| Item | Value |"
        echo "|------|-------|"
        echo "| Row $i | Data $i |"
        echo ""
    done
} > "$TEST_FILE"

test_both_backends "Multi-page document" "$TEST_FILE" 30000

# Test 3: Code blocks
TEST_FILE="$FIXTURES_DIR/test-code.md"

cat > "$TEST_FILE" << 'EOF'
# Code Block Test

Inline code: `var x = 5;`

Block code:

```javascript
function hello() {
    console.log("Hello, World!");
}
```

```python
def hello():
    print("Hello, World!")
```
EOF

test_both_backends "Code blocks" "$TEST_FILE"

# Test 4: Links
TEST_FILE="$FIXTURES_DIR/test-links.md"

cat > "$TEST_FILE" << 'EOF'
# Link Test

[External link](https://example.com)

[Internal link](#section)

## Section

Auto-link: https://example.com
EOF

test_both_backends "Hyperlinks" "$TEST_FILE"

# Test 5: Images (if test image exists)
TEST_FILE="$FIXTURES_DIR/test-image.md"

cat > "$TEST_FILE" << 'EOF'
# Image Test

![Alt text](https://via.placeholder.com/150)

Text after image.
EOF

test_both_backends "Image handling" "$TEST_FILE"

# Test 6: Special characters in filename
TEST_FILE="$FIXTURES_DIR/test file with spaces.md"

cat > "$TEST_FILE" << 'EOF'
# Filename Test

Testing filenames with spaces.
EOF

test_both_backends "Special characters in filename" "$TEST_FILE"

# Test 7: Nested lists
TEST_FILE="$FIXTURES_DIR/test-lists.md"

cat > "$TEST_FILE" << 'EOF'
# Nested Lists

1. First level
   - Second level
     - Third level
2. Another first level
   1. Numbered second level
   2. Another numbered
EOF

test_both_backends "Nested lists" "$TEST_FILE"

# Test 8: Blockquotes
TEST_FILE="$FIXTURES_DIR/test-blockquote.md"

cat > "$TEST_FILE" << 'EOF'
# Blockquote Test

> This is a blockquote
> with multiple lines

>> Nested blockquote
EOF

test_both_backends "Blockquotes" "$TEST_FILE"

# Cleanup
rm -f "$FIXTURES_DIR"/test-*.md
rm -f "$FIXTURES_DIR"/test*.md

# Summary
echo ""
echo "Advanced Test Summary"
echo "===================="
echo "Total:  $TESTS_RUN"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
else
    echo "Failed: 0"
fi

if [ $TESTS_FAILED -gt 0 ]; then
    echo ""
    echo "❌ Some advanced tests failed"
    exit 1
else
    echo ""
    echo "✅ All advanced tests passed!"
    exit 0
fi
