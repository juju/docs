
build:
	PYTHONPATH="$(CURDIR)/tools/plugins:$(CURDIR)/tools/plugins/gfm:$(PYTHONPATH)" ./build.py $(doc)

sysdeps:
	sudo apt-get install python-html2text python-markdown python-cheetah python-git python-yaml

watch:
	@echo "Requires watchdog module to be installed. - to install pip install watchdog."
	@tools/watch.sh
