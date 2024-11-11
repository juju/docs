(how-to-configure-charmcraft)=
# How to configure Charmcraft

> See also:
> - {ref}`How to install Charmcraft <how-to-install-charmcraft>`
> - {ref}`About Charmcraft <charmcraft-charmcraft>`
> - {ref}`About the `charmcraft.yaml` file <4138md>`

You have installed Charmcraft. This document shows you how you can configure it.

```{note}

Configuring Charmcraft is mandatory for all project-handling commands, though optional for some store-related commands.

```

**Contents:**

- [Find the configuration file](#heading--find-the-configuration-file)
- [Get acquainted with its contents](#heading--get-acquainted-with-its-contents)
- [Consult some examples](#heading--consult-some-examples)
- [Start configuring!](#heading--start-configuring)


<a href="#heading--find-the-configuration-file"><h2 id="heading--find-the-configuration-file">Find the configuration file</h2></a>

The `charmcraft` tool configuration is specified in a `charmcraft.yaml` file located in the project's root directory. 

By default, Charmcraft will try to find that file in the current directory, but in case of needing to run `charmcraft` outside the project's directory, it can be specified using the global option `--project-dir`.


<a href="#heading--get-acquainted-with-its-contents"><h2 id="heading--get-acquainted-with-its-contents">Get acquainted with its contents</h2></a>

See {ref}``charmcraft.yaml` <file-charmcraftyaml>`.


<a href="#heading--consult-some-examples"><h2 id="heading--consult-some-examples">Consult some examples</h2></a>


The following illustrate some implementations of the above spec:

```yaml
type: bundle
charmhub:
  # these fields are set to the default value to illustrate field usage
  # likely not required in most cases
  api-url: https://api.charmhub.io
  storage-url: https://storage.snapcraftcontent.com
parts:
  bundle:
    prime: ["README.md"]
```

A different example, with a more comprehensive base definition:

```yaml
type: charm
bases:
    - build-on:
        - name: ubuntu
          channel: "20.04"
          architectures: ["amd64"]
      run-on:
        - name: ubuntu
          channel: "21.04"
          architectures: 
              - amd64
              - aarch64
              - arm64
```

<a href="#heading--start-configuring"><h2 id="heading--start-configuring">Start configuring!</h2></a>


Start modifying the examples above to suit your own needs.

-------------------------

jnsgruk | 2021-06-16 14:19:09 UTC | #3



-------------------------

sed-i | 2021-07-21 23:36:48 UTC | #4

[quote="facundo, post:1, topic:4138"]
`    channel: 20.04`
[/quote]

@facundo without quotation marks I am getting 

    Bad charmcraft.yaml content:
    - string type expected in field 'bases[0].channel'

not sure if it should be a feature (convert to string) or should add quotation marks here

-------------------------

facundo | 2021-07-22 14:18:20 UTC | #5

`20.04` is a float. While we could convert *this one* to string automatically (and get `"20.04"`, we do NOT want to get into the situation of converting `20.10` to `"20.1"`. 

So please use quotation marks around it. Thanks!

-------------------------

sed-i | 2021-07-22 14:24:08 UTC | #6

[quote="facundo, post:5, topic:4138"]
So please use quotation marks around it.
[/quote]

Thanks. Added.

-------------------------

davigar15 | 2021-08-23 12:33:54 UTC | #7

[quote="facundo, post:1, topic:4138"]
`    - run-on:`
[/quote]

@facundo The dash ("-") should be removed. With the current yaml I get the following error:

```
ERROR    Bad charmcraft.yaml content:
- field 'run-on' required in 'bases[0]' configuration
- field 'build-on' required in 'bases[1]' configuration
```

-------------------------

facundo | 2021-08-26 14:04:19 UTC | #8

Thanks! Fixed.

-------------------------

mthaddon | 2021-09-15 07:39:38 UTC | #9

I understand there's also a `build-packages` option to `parts/charm`. Could that be added here, it's been asked about a few times by different people on https://chat.charmhub.io/charmhub/channels/charm-dev ?

-------------------------

bthomas | 2022-03-10 12:27:14 UTC | #10

Unless I misread this, it is not specified under what path, the files listed under `prime` are included in the charm container. Also in the case of a bundle what path are `prime` files mapped into and for which charm ?

-------------------------

facundo | 2022-03-14 13:47:17 UTC | #11

[quote="bthomas, post:10, topic:4138"]
it is not specified under what path, the files listed under `prime` are included in the charm container.
[/quote]

The files are included in the same path that are in the project (the root of the charm file would be root dir of the project itself).

[quote="bthomas, post:10, topic:4138"]
in the case of a bundle what path are `prime` files mapped into and for which charm ?
[/quote]

If it's a bundle, there are no "charms".  A bundle specifies a collection of charms but those charms are not inside the produced zip file.

-------------------------

thogarre | 2022-03-14 18:16:24 UTC | #12

Is it possible to have per-base configuration of the `charms-python-packages` property? See this [github discussion](https://github.com/canonical/charmcraft/issues/632#issuecomment-1019342531) for reference, where setuptools needs to be on v58 or lower for support on Bionic charms. It would be nice if charmcraft.yaml could have this specified for each Ubuntu base as needed.

-------------------------

mthaddon | 2022-06-10 10:35:02 UTC | #14

[quote="mthaddon, post:9, topic:4138, full:true"]
I understand there’s also a `build-packages` option to `parts/charm`. Could that be added here, it’s been asked about a few times by different people on [Mattermost](https://chat.charmhub.io/charmhub/channels/charm-dev) ?
[/quote]

Could this be added, and can anyone confirm if `stage-packages` should work as a way of installing packages in the charm at run time (or if there’s another way to do that - I’ve tried it without success)?

-------------------------

heitor | 2022-06-28 17:26:41 UTC | #15

Is it necessary to specify the `bases` for a bundle? What happens if the bases in the bundle differ from the charm's bases? Will the `run-on` from the charms be overwritten by the values on the bundle file?

-------------------------

facundo | 2022-06-28 18:48:51 UTC | #16

No. `bases` is not needed, and in fact forbidden as a key, when packing a bundle.

-------------------------

heitor | 2022-06-29 12:17:23 UTC | #17

Ah, got it! Do you know how to specify that a bundle can run on different OSes? We have charms that run on Ubuntu and Centos, but I can only specify one `series` in the bundle file, so when I upload to charmhub it shows only one OS in there. The bundle I am working on is: charmhub.io/slurm

-------------------------

nuccitheboss | 2022-09-09 15:19:31 UTC | #18

[quote="facundo, post:1, topic:4138"]
Get acquainted with its contents
[/quote]

Hey there @facundo! I was wondering if we could add `override-build` as an available key for the charm section of `parts`? As I had mentioned in my issue on the [charmcraft](https://github.com/canonical/charmcraft/issues/858) repository, I had no idea `override-build` was an available option for `charmcraft.yaml` until you showed me that separate discourse post. 

I think it would be beneficial to add `override-build` to the section I quoted above. This way, folks who have edge cases like myself will know they can inject some custom actions into the `charmcraft.yaml` file when reading the sdk documentation.

Let me know what your thoughts are!

-------------------------

pedroleaoc | 2022-10-14 11:30:13 UTC | #19