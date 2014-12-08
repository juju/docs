
build:
	PYTHONPATH="$(CURDIR)/tools/plugins:$(CURDIR)/tools/plugins/gfm:$(PYTHONPATH)" tools/build-from-source $(doc)

sysdeps:
	sudo apt-get install python-html2text python-markdown python-cheetah

watch:
	@echo "Requires watchdog module to be installed. - to install pip install watchdog."	
	@tools/watch.sh
