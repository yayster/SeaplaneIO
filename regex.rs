use std::fs::File;
use std::io::{BufRead, BufReader};
extern crate regex;
use regex::Regex;

fn main() {
    let filename = "test/example.tasks.in";
    // Open the file in read-only mode (ignoring errors).
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    // Read the file line by line user lines() iterator from std::io:BufRead.
    for (index, line) in reader.lines().enumerate() {
	let line = line.unwrap(); // Ignore errors.
	// show the line and its number.
	println!("{}. {}", index + 1, line);
    }
}
