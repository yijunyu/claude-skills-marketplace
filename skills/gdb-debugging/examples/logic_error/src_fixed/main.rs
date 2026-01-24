// Fixed: correct comparison operators
fn find_max(a: i32, b: i32, c: i32) -> i32 {
    if a > b && a > c {  // FIXED: use > for finding max
        a
    } else if b > c {    // FIXED: use > for finding max
        b
    } else {
        c
    }
}

fn main() {
    let result = find_max(5, 10, 3);
    println!("Max: {}", result);  // Correctly prints 10

    // Verify with assertion (will pass on fixed version)
    assert_eq!(result, 10, "Expected max to be 10");
}
