use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let root_path = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap()).join("..");

    Command::new("make")
        .current_dir(&root_path)
        .output()
        .expect("Failed to build hashtree");

    println!(
        "cargo:rustc-link-search=native={}",
        root_path.join("src").display()
    );
    println!("cargo:rustc-link-lib=static=hashtree");
}
