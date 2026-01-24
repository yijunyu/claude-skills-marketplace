#!/bin/bash
# Regression test for logic error bug
set -e

cd "$(dirname "$0")"

echo "=== Testing logic_error example ==="

# Build and test buggy version (should fail assertion)
echo "Testing buggy version..."
cp src/main.rs src/main.rs.bak
cargo build 2>&1

if ./target/debug/logic_error 2>/dev/null; then
    echo "UNEXPECTED: buggy version passed (assertion should have failed)"
    mv src/main.rs.bak src/main.rs
    exit 1
fi
echo "✓ Buggy version correctly fails assertion"

# Build and test fixed version (should pass)
echo "Testing fixed version..."
cp src_fixed/main.rs src/main.rs
cargo build 2>&1

if ! ./target/debug/logic_error; then
    echo "FAIL: fixed version failed"
    mv src/main.rs.bak src/main.rs
    exit 1
fi
echo "✓ Fixed version runs correctly"

# Restore original
mv src/main.rs.bak src/main.rs
echo "=== PASS: logic_error regression test passed ==="
