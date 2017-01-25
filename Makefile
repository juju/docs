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

check-links-localhost:
	linkchecker \
	  --ignore-url=^http://localhost:6543/docs/devel \
	  --ignore-url=^http://localhost:6543/docs/1.25 \
	  --ignore-url=^http://localhost:6543/docs/2.0 \
	  --ignore-url=http://localhost:6543/docs/stable \
	  http://localhost:6543/docs/fix-404/getting-started

.PHONY: build check-links-build check-links-production clean multi serve spell spell-commands sysdeps
