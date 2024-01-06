extern crate serde;
extern crate serde_json;

use serde::Deserialize;

static JSON_STR: &str = r#"
{
    "name": "John Doe",
    "age": 43,
    "phones": [
        "+44 1234567",
        "+44 2345678"
    ]
}"#;

#[derive(Deserialize, Debug)]
struct Person {
    name: String,
    age: u8,
    phones: Vec<String>,
}

fn main() {
    let v: Person = serde_json::from_str(JSON_STR).unwrap();
    println!("{:?}", v);
}