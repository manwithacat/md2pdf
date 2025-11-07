#!/bin/bash
# Full test suite runner

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🧪 Running Full Test Suite"
echo "==========================="
echo ""

# Run basic tests
echo "▶ Basic Tests"
bash "$SCRIPT_DIR/test-basic.sh"
echo ""

# Run advanced tests
if [ -f "$SCRIPT_DIR/test-advanced.sh" ]; then
    echo "▶ Advanced Tests"
    bash "$SCRIPT_DIR/test-advanced.sh"
    echo ""
fi

# Run workflow tests
if [ -f "$SCRIPT_DIR/test-workflow.sh" ]; then
    echo "▶ Workflow Tests"
    bash "$SCRIPT_DIR/test-workflow.sh"
    echo ""
fi

echo "✅ All test suites completed!"
