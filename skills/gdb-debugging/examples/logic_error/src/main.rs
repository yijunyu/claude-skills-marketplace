// Bug: wrong comparison operator (finds min instead of max)
fn find_max(a: i32, b: i32, c: i32) -> i32 {
    if a < b && a < c {  // BUG: should be > not <
        a
    } else if b < c {    // BUG: should be > not <
        b
    } else {
        c
    }
}

fn main() {
    let result = find_max(5, 10, 3);
    println!("Max: {}", result);  // Should print 10, prints 5

    // Verify with assertion (will fail on buggy version)
    assert_eq!(result, 10, "Expected max to be 10");
}
