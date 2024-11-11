(how-to-create-an-ubuntu-virtual-machine-with-multipass)=
# How to create an Ubuntu virtual machine with Multipass

<!--NOTE: -This doc is linked in both the OLM and the SDK docs so clicking on it wouldn't take the user out, e.g., from the SDK docs to the OLM docs. Ideally, though, it should be hosted on multipass.run .-->

Multipass is a tool for quickly running an Ubuntu virtual machine from any host operating system.  It allows you to obtain an instance of Linux on your Windows or macOS machine, or to create a fully-isolated instance of Linux on your existing Linux.

To install Multipass on Linux, Windows, or macOS, follow the instructions provided at {ref}`multipass.run <5212md>`.

To use Multipass to create a virtual machine `microcloud` with 8 GB RAM allocated to it, execute:

```bash
multipass launch -n microcloud -m 8g -c 2 -d 20G 
```
Multipass will confirm the creation of the `microcloud` virtual machine:

```bash
Launched: microcloud
```
Multipass will then also download the latest Long Term Support version of the Ubuntu operating system. Once that is done, to use Multipass to access your newly created `microcloud` Ubuntu virtual machine via the command-line interface, execute:

```bash
multipass shell microcloud
```
If this is successful, you should see the following (or similar, depending on the version installed):

```bash
ubuntu@microcloud:~$
```
To use your newly created Ubuntu, all you have to do is type commands in this shell. 

Once you are done, if you would like to remove any trace of your `microcloud` Ubuntu virtual machine, simply run:

```bash
$ multipass delete microcloud
```

To remove all traces of the steps you've followed in this guide, also uninstall Multipass.