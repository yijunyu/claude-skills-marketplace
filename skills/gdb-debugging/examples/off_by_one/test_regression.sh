#!/bin/bash
# Regression test for off-by-one bug
set -e

cd "$(dirname "$0")"

echo "=== Testing off_by_one example ==="

# Build and test buggy version (should crash/panic)
echo "Testing buggy version..."
cp src/main.rs src/main.rs.bak
cargo build 2>&1

if ./target/debug/off_by_one 2>/dev/null; then
    echo "UNEXPECTED: buggy version passed (should have crashed)"
    mv src/main.rs.bak src/main.rs
    exit 1
fi
echo "✓ Buggy version correctly crashes"

# Build and test fixed version (should pass)
echo "Testing fixed version..."
cp src_fixed/main.rs src/main.rs
cargo build 2>&1

if ! ./target/debug/off_by_one; then
    echo "FAIL: fixed version crashed"
    mv src/main.rs.bak src/main.rs
    exit 1
fi
echo "✓ Fixed version runs correctly"

# Restore original
mv src/main.rs.bak src/main.rs
echo "=== PASS: off_by_one regression test passed ==="
