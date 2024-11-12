(how-to-create-a-track-for-your-charm)=
# How to create a track for your charm

> See also: {ref}`Channel > Track <11102md>`

This document shows how to create a track for your charm.

**Contents:**

1. [Request a track guardrail](#heading--request-a-track-guardrail)
1. [Create the track](#heading--create-the-track)


 <a href="#heading--request-a-track-guardrail"><h2 id="heading--request-a-track-guardrail">Request a track guardrail</h2></a>
> See also: {ref}`Channel > Track > Guardrail <11102md>`

To request a track guardrail, contact a Charmhub admin by creating a post on Discourse under the **charmhub requests** category, that is, here: https://discourse.charmhub.io/c/charmhub-requests/46 .

 <a href="#heading--create-the-track"><h2 id="heading--create-the-track">Create the track</h2></a>

Once you've requested a track guardrail, there are two ways to create a new track for your charm -- you can keep contacting a Charmhub admin every time or you can self-service. For most cases the latter option is likely to be more convenient and faster.

<!--
If you anticipate having a lot of tracks, or if you are maintaining a lot of charms, you might want to follow the latter option.
-->


- [Contact a Charmhub admin](#heading--contact-a-charmhub-admin)
- [Self-service](#heading--self-service)

 <a href="#heading--contact-a-charmhub-admin"><h3 id="heading--contact-a-charmhub-admin">Contact a Charmhub admin</h3></a>

To create a new track by contacting a Charmhub admin, create a post on Discourse under the **charmhub requests** category, that is, here: https://discourse.charmhub.io/c/charmhub-requests/46 . The admin will create the new track that fits within the track guardrail you’ve set up for your charm.

 <a href="#heading--self-service"><h3 id="heading--self-service">Self-service</h3></a>

To create a new track yourself, follow the steps below:

```{important}

As you might notice, this path is currently a little hacky. In the long-term it should become a lot smoother as there are plans to support it through the Charmcraft CLI.

```

```{important}

As you will see, this method currently relies on `charmcraft`+ `curl`. We recommend the Charmcraft bit because Charmcraft already understands the authentication mechanism used by Charmhub and can generate a suitable authentication token (macaroon) that will make it possible to then use `curl` directly to interact with the Charmhub API. This method also has the advantage that it can be adapted to use any HTTP client or library as long as it can pass custom headers.

```


**1. Enable `curl` access to the Charmhub API.**

First, install `curl` and `jq`.

```{important}

You might already have both.

``` 

Then, use Charmcraft to log in to Charmhub and export your Charmhub credentials / token (macaroon) to a file:

```text
charmcraft login --export charmhub-creds.dat
```

Next, decode and extract the macaroon from the .dat file and place it in a header in an environment variable:

```text
export CHARMHUB_MACAROON_HEADER="Authorization: Macaroon $(cat charmhub-creds.dat | base64 -d | jq -r .v)"
```

At this point you can use this variable in `curl` commands -- just make sure to specify the correct `Content-Type`.

**2. Use `curl` to view the existing guardrails and tracks.** To view the guardrails and tracks associated with your charm, issue an HTTP `GET` request to `/v1/<namespace>/<name>`. For example, for a charm named `hello-world-charm`:

```text
curl https://api.charmhub.io/v1/charm/hello-world-charm -H'Content-type: application/json' -H "$CHARMHUB_MACAROON_HEADER"
```

The guardrails and tracks of the package will be under the `track-guardrails` and `tracks` keys of `metadata`. Now you know what the new track may look like.

> See more: [Charmhub API docs > `package_metadata`](https://api.charmhub.io/docs/default.html#package_metadata)

```{important}

**If you want to view the guardrails and tracks for *all* published charms:** Issue an HTTP `GET` request to `/v1/<namespace>`, as below:

```text
curl https://api.charmhub.io/v1/charm -H'Content-type: application/json' -H "$CHARMHUB_MACAROON_HEADER"
```

> See more: [Charmhub API docs > `list_registered_names`](https://api.charmhub.io/docs/default.html#list_registered_names) 



```


**3. Use `curl` to create a new track.** Finally, to create a new track for your charm, issue an HTTP `POST` request to `/v1/<namespace>/<name>/tracks`, where `name` and `namespace` refer to the name and type of the package respectively. For example,  given a charm named `hello-world-charm`, one can create two tracks `v.1` and `v.2` as follows:

```text
curl https://api.charmhub.io/v1/charm/hello-world-charm/tracks -X POST -H'Content-type: application/json' -H "$CHARMHUB_MACAROON_HEADER" -d '[{"name": "v.1"}, {"name": "v.2"}]'
```

Of course, the tracks must conform to the existing guardrail for the charm.


> See more: [Charmhub API docs > `create_tracks`](https://api.charmhub.io/docs/default.html#create_tracks)


That's it, you now have a new track for your charm!