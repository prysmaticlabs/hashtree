libhashtree:
	$(MAKE) -C src

clean:
	$(MAKE) -C src clean

test:
	$(MAKE) -C src test

bench:
	$(MAKE) -C src bench

all:
	$(MAKE) -C src all

install:
	$(MAKE) -C src install

uninstall:
	$(MAKE) -C src uninstall
