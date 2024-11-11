(list-of-files-in-a-charm-project)=
# List of files in a charm project

> See also: {ref}`How to set up a charm project <how-to-set-up-a-charm-project>`

Below is a list of the files you may encounter in a charm project. This includes:
- files created automatically for you when you set up a charm project with `charmcraft init` (e.g., all the 3 crucial files -- {ref}``charmcraft.yaml` <file-charmcraftyaml>`, {ref}``requirements.txt` <file-requirementstxt>`, and {ref}``src/charm.py` <file-srccharmpy>` -- but not just; you'll likely want to edit all)
- files created automatically for you when you pack a charm with `charmcraft pack` (e.g., {ref}``actions.yaml` <file-actionsyaml>`, {ref}``config.yaml` <file-configyaml>`, {ref}``dispatch` <file-dispatch>`,  {ref}``manifest.yaml` <file-manifestyaml>`, {ref}``metadata.yaml` <file-metadatayaml>`)
- files you may want to add on your own (e.g., {ref}``icon.svg` <file-iconsvg>`, {ref}``lxd-profile.yaml` <file-lxd-profileyaml>`). 

Click on a title to find out more. 

| Filename                                      | Created by <br> `charmcraft init` |  Created by <br> `charmcraft pack` |
|-----------------------------------------------|-----------------------------------|------------------------------------|
| {ref}``CONTRIBUTING.md` <file-contributingmd>`                  | :white_check_mark:                |                                    |
| {ref}``LICENSE` <file-license>`                          | :white_check_mark:                |                                    |
| {ref}``README.md` <file-readmemd>`                        | :white_check_mark:                |              |
| {ref}``actions.yaml` <file-actionsyaml>`                     |                                   |    :white_check_mark:                                |
| {ref}``charmcraft.yaml` <file-charmcraftyaml>`                  | :white_check_mark:                |                                    |
| {ref}``config.yaml` <file-configyaml>`                      |                                   |  :white_check_mark:                |
| {ref}``dispatch` <file-dispatch>`                        |                                   |  :white_check_mark:                |
| {ref}``icon.svg` <file-iconsvg>`                         |                                   |                                    |
| {ref}``lxd-profile.yaml` <file-lxd-profileyaml>`                 |                                   |                                    |
| {ref}``manifest.yaml` <file-manifestyaml>`                    |                                   |  :white_check_mark:                |
| {ref}``metadata.yaml` <file-metadatayaml>`                    |                                   |  :white_check_mark:                |
| {ref}``pyproject.toml` <file-pyprojecttoml>`                  | :white_check_mark:                |                                    |
| {ref}``requirements-dev.txt` <file-requirements-devtxt>`             |                                   |                                    |
| {ref}``requirements.txt` <file-requirementstxt>`                 | :white_check_mark:                |                                    |
| {ref}``src/charm.py` <file-srccharmpy>`                     | :white_check_mark:                |                                    |
| {ref}``tests/unit/test_charm.py` <file-testsunittest_charmpy>`         | :white_check_mark:                |                                    |
| {ref}``tests/integration/test_charm.py` <file-‘testsintegrationtest_charmpy’>` | :white_check_mark:                |                                    |
| {ref}``tox.ini` <file-toxini>`                         | :white_check_mark:                |                                    |




<!--No longer used. Removed with redirects:
| {ref}``run_tests` <4454md>`       |   |   |   |
| {ref}``tests/_init_.py` <4454md>` |   |   |   |
| {ref}``version` <4454md>`         |   |   |   |
|                              |   |   |   |
-->