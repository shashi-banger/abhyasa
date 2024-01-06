use std::fs::File;
use std::io::{self, Read};


fn print_type_name<T>(_: &T) {
    println!("{}", std::any::type_name::<T>());
}

fn read_chunk_from_file(fd: &mut File, buf: &mut Vec<u8>) -> usize {
    let n = fd.read(buf).unwrap();
    if n != buf.len() {
        println!("n = {}", n);
    }
    return n;
}

fn process_chunk(buf: &Vec<u8>) -> i32 {
    let mut zeros = 0;
    for i in 0..buf.len() {
        if buf[i] == 0 {
            zeros += 1;
        }
    }
    return zeros;
}

fn main() -> io::Result<()> {
    let v = vec![100,32,37];
    for i in 0..v.len() {
        println!("i = {}", v[i]);
    }

    let mut file = File::open("/Users/shashidhar/sb_media/open_movies/BigBuckBunny1080pHD-huVVKz8P3vU.mp4")?;

    let mut buf: Vec<u8> = vec![0; 1024];
    let mut all_zeros = 0;
    loop {
        let n = read_chunk_from_file(&mut file, &mut buf);
        if n == 0 {
            break;
        }
        all_zeros += process_chunk(&buf);
    }
    println!("zeros = {}", all_zeros);
    Ok(())
}
