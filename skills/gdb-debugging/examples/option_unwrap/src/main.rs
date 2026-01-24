// Bug: unwrap on None causes panic
use std::collections::HashMap;

fn get_value(map: &HashMap<&str, i32>, key: &str) -> i32 {
    *map.get(key).unwrap()  // BUG: panics if key missing
}

fn main() {
    let mut map = HashMap::new();
    map.insert("a", 1);
    map.insert("c", 3);

    // This will panic because "b" doesn't exist
    println!("Value for 'b': {}", get_value(&map, "b"));
}
