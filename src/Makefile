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

VERSION := 0.1.0


ASFLAGS += -g -fpic
CFLAGS +=  -g -Wall -Werror
CLANG_ASFLAGS = "-fno-integrated-as"
LDFLAGS += -L .
testlibs = -lhashtree
benchlibs = -lhashtree -lm

COMPILER_NAME := $(shell $(CC) --version 2>/dev/null | head -n 1)
IS_CLANG := $(findstring clang, $(COMPILER_NAME))

ifeq ($(IS_CLANG),clang)
ifneq ($(ARM),1)
	ASFLAGS += $(CLANG_ASFLAGS)
endif
endif

ifeq ($(HAVE_OPENSSL),1)
CFLAGS += -DHAVE_OPENSSL
benchlibs += -lcrypto
testlibs += -lcrypto
endif

OUT_DIR ?= $(CURDIR)/../build
OBJ_DIR := $(OUT_DIR)/obj
LIB_DIR := $(OUT_DIR)/lib

# Ensure these directories exist
$(shell mkdir -p $(OBJ_DIR))
$(shell mkdir -p $(LIB_DIR))

objarm = $(OBJ_DIR)/sha256_armv8_neon_x4.o\
         $(OBJ_DIR)/sha256_armv8_neon_x1.o\
         $(OBJ_DIR)/sha256_armv8_crypto.o\
         $(OBJ_DIR)/hashtree.o

objx86 = $(OBJ_DIR)/sha256_shani.o\
         $(OBJ_DIR)/sha256_avx_x16.o\
         $(OBJ_DIR)/sha256_avx_x8.o\
         $(OBJ_DIR)/sha256_avx_x4.o\
         $(OBJ_DIR)/sha256_avx_x1.o\
         $(OBJ_DIR)/sha256_sse_x1.o\
         $(OBJ_DIR)/hashtree.o

.PHONY : clean .FORCE
.FORCE: 

$(OBJ_DIR)/%.o: %.S
	$(CC) $(ASFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

ifeq ($(WIN),1)
libname = $(LIB_DIR)/libhashtree.lib
else
libname = $(LIB_DIR)/libhashtree.a
endif

ifeq ($(ARM),1)
$(LIB_DIR)/libhashtree.a: $(objarm)
	$(AR) rcs $@ $(objarm)
else
$(libname): $(objx86)
	$(AR) rcs $@ $(objx86)
endif

ifeq ($(WIN),1)
all: $(libname) test
else
all: $(libname) test bench
endif

test: hashtree.h acutest.h test.c $(libname)
	$(CC) $(CFLAGS) $(LDFLAGS) -L$(LIB_DIR) -o $(OUT_DIR)/test test.c $(testlibs)

bench: hashtree.h ubench.h bench.c $(libname)
	$(CC) $(CFLAGS) $(LDFLAGS) -L$(LIB_DIR) -o $(OUT_DIR)/bench bench.c $(benchlibs)

clean:
	-rm -f $(objarm) $(objx86) $(LIB_DIR)/libhashtree.a $(LIB_DIR)/libhashtree.lib $(OUT_DIR)/test $(OUT_DIR)/test.exe $(OUT_DIR)/bench hashtree.pc

ifeq ($(PREFIX),)
PREFIX := /usr
endif

hashtree.pc: .FORCE
	@echo 'prefix='$(PREFIX) > hashtree.pc
	@echo 'exec_prefix=$${prefix}' >> hashtree.pc
	@echo 'libdir=$${prefix}/lib' >> hashtree.pc
	@echo 'includedir=$${prefix}/include' >> hashtree.pc
	@echo '' >> hashtree.pc
	@echo 'Name: hashtree' >> hashtree.pc
	@echo 'Description: Fast hashing of Merkle trees' >> hashtree.pc
	@echo 'Version: '$(VERSION) >> hashtree.pc
	@echo 'URL: https://github.com/prysmaticlabs/hashtree' >> hashtree.pc
	@echo 'LIBS: -L$${libdir} -lhashtree' >> hashtree.pc
	@echo 'Cflags: -I$${includedir}'>> hashtree.pc

ifneq ($(WIN),1)
install: $(libname) hashtree.pc
	install -d $(DESTDIR)$(PREFIX)/lib
	install -m 644 $(libname) $(DESTDIR)$(PREFIX)/lib/ 
	install -d $(DESTDIR)$(PREFIX)/include
	install -m 644 hashtree.h $(DESTDIR)$(PREFIX)/include/
	install -d $(DESTDIR)$(PREFIX)/lib/pkgconfig
	install -m 644 hashtree.pc $(DESTDIR)$(PREFIX)/lib/pkgconfig/hashtree.pc

uninstall: $(libname)
	rm $(DESTDIR)$(PREFIX)/lib/libhashtree.a
	rm $(DESTDIR)$(PREFIX)/include/hashtree.h
endif

