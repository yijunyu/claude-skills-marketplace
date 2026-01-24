// Fixed: correct range iteration
fn sum_array(arr: &[i32]) -> i32 {
    let mut sum = 0;
    for i in 0..arr.len() {  // FIXED: use exclusive range
        sum += arr[i];
    }
    sum
}

fn main() {
    let arr = [1, 2, 3, 4, 5];
    println!("Sum: {}", sum_array(&arr));
}
