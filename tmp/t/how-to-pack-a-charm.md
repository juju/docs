(how-to-pack-a-charm)=
# How to pack a charm

To pack a charm directory, in the charm's root directory, run the command below:

```text
charmcraft pack
```

This will fetch any dependencies (from PyPI, based on `requirements.txt`), compile any modules, check that all the key files are in place, and produce a compressed archive with the extension `.charm`. As you can verify, this archive is just a zip file with metadata and the operator code itself. 

```{dropdown} Expand to view a sample session for a charm called `microsample-vm`


```text
# Pack the charm:
~/microsample-vm$ charmcraft pack
Created 'microsample-vm_ubuntu-22.04-amd64.charm'.                                         
Charms packed:                                                                             
    microsample-vm_ubuntu-22.04-amd64.charm                                                

# (Optional) Verify that this has created a .charm file in your charm's root directory:
~/microsample-vm$ ls
CONTRIBUTING.md  charmcraft.yaml                          requirements.txt  tox.ini
LICENSE          microsample-vm_ubuntu-22.04-amd64.charm  src
README.md        pyproject.toml                           tests

# (Optional) Verify that the .charm file is simply a zip file that contains 
# everything you've packed plus any dependencies:
/microsample-vm$ unzip -l microsample-vm_ubuntu-22.04-amd64.charm | { head; tail;}
Archive:  microsample-vm_ubuntu-22.04-amd64.charm
  Length      Date    Time    Name
---------  ---------- -----   ----
      815  2023-12-05 12:12   README.md
    11337  2023-12-05 12:12   LICENSE
      250  2023-12-05 12:31   manifest.yaml
      102  2023-12-05 12:31   dispatch
      106  2023-12-01 14:59   config.yaml
      717  2023-12-05 12:31   metadata.yaml
      921  2023-12-05 12:26   src/charm.py
      817  2023-12-01 14:44   venv/setuptools/command/__pycache__/upload.cpython-310.pyc
    65175  2023-12-01 14:44   venv/setuptools/command/__pycache__/easy_install.cpython-310.pyc
     4540  2023-12-01 14:44   venv/setuptools/command/__pycache__/py36compat.cpython-310.pyc
     1593  2023-12-01 14:44   venv/setuptools/command/__pycache__/bdist_rpm.cpython-310.pyc
     6959  2023-12-01 14:44   venv/setuptools/command/__pycache__/sdist.cpython-310.pyc
     2511  2023-12-01 14:44   venv/setuptools/command/__pycache__/rotate.cpython-310.pyc
     2407  2023-12-01 14:44   venv/setuptools/extern/__init__.py
     2939  2023-12-01 14:44   venv/setuptools/extern/__pycache__/__init__.cpython-310.pyc
---------                     -------
 20274163                     1538 files


```

```

The command has a number of flags that allow you to specify a different charm directory to pack, whether to force pack if there are linting errors, etc.

> See more: {ref}``charmcraft pack` <command-charmcraft-pack>`

```{caution}


**If you've declared any resources :** This will *not* pack the resources. This means that, when you upload your charm to Charmhub (if you do), you will have to upload the resources separately.

> See more: {ref}`Publish a charm on Charmhub > Upload the charm and its resources <5548md>`


```

```{important}

When the charm is packed, a series of analyses and lintings will happen, you may receive warnings and even errors to help improve the quality of the charm.

> See more: {ref}`Charmcraft analyzers and linters <charmcraft-analyzers-and-linters>`

```