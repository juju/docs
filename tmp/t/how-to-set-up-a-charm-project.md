(how-to-set-up-a-charm-project)=
# How to set up a charm project

To set up a charm project, create a directory for your charm, enter it, then run `charmcraft init` with the `--profile` flag followed by a suitable profile name (for machine charms: `machine`; for Kubernetes charms: `kubernetes`, `simple`, or `flask-framework`); that will create all the necessary files and even prepopulate them with useful content. 

```text
charmcraft init --profile <profile>
```

----
```{dropdown} See sample session


```text
$ mkdir my-flask-app-k8s
$ cd my-flask-app-k8s/
$ charmcraft init --profile flask-framework
Charmed operator package file and directory tree initialised.                                                                                                                                
                                                                                                                                                                                             
Now edit the following package files to provide fundamental charm metadata                                                                                                                   
and other information:                                                                                                                                                                       
                                                                                                                                                                                             
charmcraft.yaml                                                                                                                                                                              
src/charm.py                                                                                                                                                                                 
README.md                                                                                                                                                                                    
                                                                                                                                                                                             
$ ls -R
.:
charmcraft.yaml  requirements.txt  src

./src:
charm.py
 


```

```
-----


The command also allows you to not specify any profile (in that case you get the `simple` profile -- a Kubernetes profile with lots of scaffolding, suitable for beginners) and has flags that you can use to specify a different directory to operate in, a charm name different from the name of the root directory, etc. 

> See more: {ref}``charmcraft init` <command-charmcraft-init>`, {ref}`Profile <profile>`, {ref}`List of files in the charm project <list-of-files-in-a-charm-project>`

> <small> Contributors: @jdkandersson, @mmkay, @tmihoc, @weii-wang </small>