extern crate libc;
use libc::c_int;
use std::ptr;

type HashFunction = extern "C" fn(*mut u8, *const u8, u64);

extern "C" {
    fn hashtree_init(override_: *const HashFunction) -> c_int;
    fn hashtree_hash(output: *mut u8, input: *const u8, count: u64);
}

pub fn init() -> i32 {
    unsafe { hashtree_init(ptr::null()) }
}

pub fn hash(out: &mut [u8], chunks: &[u8], count: usize) {
    unsafe { hashtree_hash(out.as_mut_ptr(), chunks.as_ptr(), count as u64) }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_init() {
        assert_eq!(init(), 1);
    }

    #[test]
    fn test_hash() {
        let chunks: [u8; 64] = [0xAB; 64];
        let mut out = [0u8; 32];

        hash(&mut out, &chunks, 1);

        let expected_hash: [u8; 32] = [
            0xec, 0x65, 0xc8, 0x79, 0x8e, 0xcf, 0x95, 0x90, 0x24, 0x13, 0xc4, 0x0f, 0x7b, 0x9e,
            0x6d, 0x4b, 0x00, 0x68, 0x88, 0x5f, 0x5f, 0x32, 0x4a, 0xba, 0x1f, 0x9b, 0xa1, 0xc8,
            0xe1, 0x4a, 0xea, 0x61,
        ];

        assert_eq!(
            out, expected_hash,
            "The generated hash did not match the expected hash."
        );
    }
}
