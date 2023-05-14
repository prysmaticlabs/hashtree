# MIT License
# 
# Copyright (c) 2021 Prysmatic Labs
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

ARM = $(shell $(CC) -dM -E - < /dev/null | grep "aarch" | awk '{ print $$3 }')
WIN = $(shell $(CC) -dM -E - < /dev/null | grep "__WIN64__" | awk '{ print $$3 }')

ASFLAGS += -g -fpic
CFLAGS +=  -g -Wall -Werror
LDFLAGS += -L .
testlibs = -lhashtree
benchlibs = -lhashtree -lm

ifeq ($(HAVE_OPENSSL),1)
CFLAGS += -DHAVE_OPENSSL
benchlibs += -lcrypto
testlibs += -lcrypto
endif

objarm = sha256_armv8_neon_x4.o\
	sha256_armv8_neon_x1.o\
	sha256_armv8_crypto.o\
	hashtree.o\

objx86 = sha256_shani.o\
	sha256_avx_x16.o\
	sha256_avx_x8.o\
	sha256_avx_x4.o\
	sha256_avx_x1.o\
	sha256_sse_x1.o\
	hashtree.o\

.PHONY : clean

ifeq ($(WIN),1)
libname = libhashtree.lib
else
libname = libhashtree.a
endif

ifeq ($(ARM),1)
libhashtree.a: $(objarm)
	$(AR) rcs libhashtree.a $(objarm)
else
$(libname): $(objx86)
	$(AR) rcs $(libname) $(objx86)
endif

all: $(libname) test bench

test: hashtree.h acutest.h test.c $(libname)
	$(CC) $(CFLAGS) $(LDFLAGS) -o test test.c $(testlibs)

bench: hashtree.h ubench.h bench.c $(libname)
	$(CC) $(CFLAGS) $(LDFLAGS) -o bench bench.c $(benchlibs)

clean:
	-rm -f $(objarm) $(objx86) libhashtree.a libhashtree.lib test test.exe bench 
