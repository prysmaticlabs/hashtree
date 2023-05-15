/*
MIT License

Copyright (c) 2021-2023 Prysmatic Labs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include "hashtree.h"
#ifdef __x86_64__
#include <cpuid.h>
#endif
#ifdef __aarch64__
#include <sys/auxv.h>
#include <asm/hwcap.h>
#endif

void (*hash_ptr)(unsigned char*, const unsigned char*, uint64_t);

void hashtree_init() {
#ifdef __x86_64__
    // Hard fail on processors that don't support SSE
    hash_ptr = &hashtree_sha256_sse_x1;
    uint32_t a,b,c,d; 
    __get_cpuid_count(7,0,&a,&b,&c,&d);
    if ((b & bit_AVX512F) && (b & bit_AVX512VL)) {
        // Benchmarks show AVX512 performs better than Shani on larger lists
        hash_ptr = &hashtree_sha256_avx512_x16;
        return;
    }
    if (b & bit_SHA) {
        hash_ptr = &hashtree_sha256_shani_x2;
        return;
    }
    if (b & bit_AVX2) {
        hash_ptr = &hashtree_sha256_avx2_x8;
        return;
    }
    __get_cpuid_count(1,0,&a,&b,&c,&d);
    if (c & bit_AVX) {
        hash_ptr = &hashtree_sha256_avx_x4;
        return;
    }
    hash_ptr = &hashtree_sha256_sse_x1;
#endif
#ifdef __aarch64__
    // Hard fail on processors that don't support NEON
    long hwcaps = getauxval(AT_HWCAP);
    if (hwcaps & HWCAP_SHA2) {
        hash_ptr = &hashtree_sha256_sha_x1;
        return;
    }
    hash_ptr = &hashtree_sha256_neon_x4;
#endif
}

void hashtree_hash(unsigned char *output, const unsigned char *input, uint64_t count) {
    (*hash_ptr)(output, input, count);
}
