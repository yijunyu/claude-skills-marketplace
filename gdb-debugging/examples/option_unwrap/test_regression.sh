#!/bin/bash
# Regression test for option unwrap bug
set -e

cd "$(dirname "$0")"

echo "=== Testing option_unwrap example ==="

# Build and test buggy version (should panic)
echo "Testing buggy version..."
cp src/main.rs src/main.rs.bak
cargo build 2>&1

if ./target/debug/option_unwrap 2>/dev/null; then
    echo "UNEXPECTED: buggy version passed (should have panicked)"
    mv src/main.rs.bak src/main.rs
    exit 1
fi
echo "✓ Buggy version correctly panics"

# Build and test fixed version (should pass)
echo "Testing fixed version..."
cp src_fixed/main.rs src/main.rs
cargo build 2>&1

if ! ./target/debug/option_unwrap; then
    echo "FAIL: fixed version failed"
    mv src/main.rs.bak src/main.rs
    exit 1
fi
echo "✓ Fixed version runs correctly"

# Restore original
mv src/main.rs.bak src/main.rs
echo "=== PASS: option_unwrap regression test passed ==="
