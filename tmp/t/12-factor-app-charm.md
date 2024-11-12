(12-factor-app-charm)=
# 12-Factor app charm

A **12-Factor app charm** is a {ref}`charm <charm>` that has been created using certain coordinated pairs of {ref}`Rockcraft <charmcraft-charmcraft>` and {ref}`Charmcraft <charmcraft-charmcraft>` {ref}`profiles <profile>` designed to give you most of the content you will need to generate a [rock^](https://documentation.ubuntu.com/rockcraft/en/latest/explanation/rocks/) for a charm, and then the charm itself, for a particular type of workload (e.g., an application developed with Flask). 

```{tip}

**Did you know?** The OCI images produced by the 12-Factor-app-geared Rockcraft extension are designed to work standalone and are also well integrated with the rest of the Flask framework tooling.

```

When you initialise a rock with a 12-Factor-app-charm-geared profile, the initialisation will generate all the basic structure and content you'll need for the rock, including a  [`rockcraft.yaml`^](https://canonical-rockcraft.readthedocs-hosted.com/en/latest/reference/rockcraft.yaml/#) prepopulated with an extension matching the profile. Similarly, when you initialise a charm with a 12-Factor-app-charm-geared profile, that will generate all the basic structure content you'll need for the charm, including a {ref}``charmcraft.yaml` <file-charmcraftyaml>` pre-populated with an extension matching the profile as well as a `src/charm.py` pre-loaded with a library (`paas_charm`) with constructs matching the profile and the extension.


At present, there are four pairs of profiles: 
- `flask-framework` ({ref}`Rockcraft extension 'flask-framework' <rockcraft-extension-flask-framework>`, {ref}`Charmcraft extension 'flask-framework' <charmcraft-extension-flask-framework>`)
- `django-framework` ({ref}`Rockcraft extension 'django-framework' <rockcraft-extension-django-framework>`, {ref}`Charmcraft extension 'django-framework' <charmcraft-extension-django-framework>`)
- `fastapi-framework` ({ref}`Rockcraft extension 'fastapi-framework' <rockcraft-extension-fastapi-framework>`, {ref}`Charmcraft extension 'fastapi-framework' <charmcraft-extension-fastapi-framework>`)
- `go-framework` (Rockcraft extension 'go-framework', {ref}`Charmcraft extension 'go-framework' <charmcraft-extension-go-framework>`)

<br>

> **Contributors:** @econley, @jdkandersson, @javierdelapuente, @tmihoc