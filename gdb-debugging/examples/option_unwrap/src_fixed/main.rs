// Fixed: handle missing key gracefully
use std::collections::HashMap;

fn get_value(map: &HashMap<&str, i32>, key: &str) -> Option<i32> {
    map.get(key).copied()  // FIXED: return Option instead of panicking
}

fn main() {
    let mut map = HashMap::new();
    map.insert("a", 1);
    map.insert("c", 3);

    // Handle missing key gracefully
    match get_value(&map, "b") {
        Some(v) => println!("Value for 'b': {}", v),
        None => println!("Key 'b' not found"),
    }
}
