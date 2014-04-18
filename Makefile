
build:
	PYTHONPATH="$(CURDIR)/tools/plugins:$(CURDIR)/tools/plugins/gfm:$(PYTHONPATH)" tools/build-from-source

sysdeps:
	sudo apt-get install python-html2text python-markdown python-cheetah
