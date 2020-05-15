#! /usr/bin/env bash

documentation-builder --template-path src/base.tpl --source-folder src --media-path src/en/media --output-media-path build/en/media --tag-manager-code 'GTM-K92JCQ' --search-domain 'docs.jujucharms.com' --search-url 'https://www.ubuntu.com/search' --search-placeholder 'Search Juju docs' --no-link-extensions --build-version-branches --site-root https://jujucharms.com/
