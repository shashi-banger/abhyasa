
#[derive(Debug)]
struct Person {
    name: String,
    age: u8,

}

fn main() {
    let mut b = Box::new(Person{name: String::from("Shashi"), age: 32});
    println!("b = {:?}", b);
    b.age = 33;
    b.name.push_str(&String::from("Banger"));
    //*b.name.push_str("Banger");
    println!("b = {:?}", b);
}