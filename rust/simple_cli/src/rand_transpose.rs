extern crate rand;
use rand::prelude::*;

fn generate_random_matrix(n: i32) -> Vec<Vec<i32>> {
    let mut rng = rand::thread_rng();
    let mut v = vec![vec![0; n as usize]; n as usize];
    for i in 0..n as usize {
        for j in 0..n as usize{
            v[i][j] = rng.gen_range(0..100);
        }
    }
    v
}

fn transpose_matrix(v: &mut Vec<Vec<i32>>) {
    let n = v.len();
    for i in 0..n {
        for j in i..n {
            let tmp = v[i][j];
            v[i][j] = v[j][i];
            v[j][i] = tmp;
        }
    }
}

fn main() {
    let mut m = generate_random_matrix(5);

    for i in 0..m.len() {
        for j in 0..m.len() {
            print!("{:<4} ", m[i][j]);
        }
        println!("");
    }

    transpose_matrix(&mut m);

    println!("");
    println!("");

    for i in 0..m.len() {
        for j in 0..m.len() {
            print!("{:<4} ", m[i][j]);
        }
        println!("");
    }

    
}

