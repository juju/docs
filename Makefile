
sysdeps:
	sudo apt-get install python-html2text python-markdown cheetah

build:
	PYTHONPATH="$(CURDIR)/tools/plugins/gfm:$(PYTHONPATH)" tools/build-from-source
