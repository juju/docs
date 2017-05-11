PY := .venv/bin/python
PIP := .venv/bin/pip

build:
	tools/mdbuild.py

clean:
	find . -name '*.bak' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	rm -rf htmldocs/en

serve:
	tools/serve.py htmldocs 8000

todo:
	tools/mdbuild.py --todo


.venv: .venv/bin/python
.venv/bin/python:
	virtualenv -p python3 .venv
	$(PIP) install html2text Markdown mdx-anchors-away mdx-callouts mdx-foldouts

sysdeps:
	sudo apt-get install python-html2text python3-markdown python-pip python3-pip git spell ispell ibritish python3-setuptools
	sudo pip3 install mdx-anchors-away mdx-callouts mdx-foldouts
	sudo pip install linkchecker

multi:
	tools/make_versions.sh

spell:
	spell -b `find src/en -name "*.md" | grep -v commands.md` | sort | uniq

spell-commands:
	spell -b src/en/commands.md | sort | uniq

check-links-build: clean build
	linkchecker htmldocs/en

check-links-production:
	linkchecker \
	  --ignore-url=^https://jujucharms.com/docs/1.25 \
	  --ignore-url=^https://jujucharms.com/docs/2.0 \
	  --ignore-url=https://jujucharms.com/docs/stable \
	  https://jujucharms.com/docs/devel/getting-started

.PHONY: build check-links-build check-links-production clean multi serve spell spell-commands sysdeps
