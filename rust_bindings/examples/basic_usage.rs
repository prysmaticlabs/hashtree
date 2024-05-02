extern crate hashtree_rs;

fn main() {
    println!("Initializing hashtree...");
    hashtree_rs::init();
    println!("Hashtree initialized.");

    let chunks: [u8; 64] = [0xAB; 64];
    let mut out = [0u8; 32];

    hashtree_rs::hash(&mut out, &chunks, 1);

    let hex_string: String = out.iter().map(|byte| format!("{:02x}", byte)).collect();

    println!("Computed hash: 0x{}", hex_string);
}
