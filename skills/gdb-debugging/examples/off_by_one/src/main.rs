// Bug: array index out of bounds (off-by-one error)
fn sum_array(arr: &[i32]) -> i32 {
    let mut sum = 0;
    for i in 0..=arr.len() {  // BUG: should be 0..arr.len()
        sum += arr[i];
    }
    sum
}

fn main() {
    let arr = [1, 2, 3, 4, 5];
    println!("Sum: {}", sum_array(&arr));
}
