Title: Using the localhost cloud offline

## Using the localhost cloud offline

*This is in connection with the [Working offline][charms-offline] page. See
that resource for background information.*

Here we present a popular offline use case. Running Juju with the localhost
cloud in a network-restricted environment.

Begin by defining the HTTP and HTTPS proxies. In this example they happen to be
the same:

```bash
PROXY_HTTP=http://squid.internal:3128
PROXY_HTTPS=http://squid.internal:3128
```

Now we employ a slightly ingenious method to define the 'no proxy' settings in
order to prevent some destinations from using the proxies (see
[No proxy and the localhost cloud][anchor__no-proxy-and-the-localhost-cloud]
for clarity):

```bash
PROXY_NO=$(echo localhost 127.0.0.1 10.245.67.130 10.44.139.{1..255} | sed 's/ /,/g')
```

Besides those related to the local system, you will need to change these values
according to your specific setup.

Configure the client to use these three setting:

```bash
export http_proxy=$PROXY_HTTP
export https_proxy=$PROXY_HTTP
export no_proxy=$PROXY_NO
```

Finally, apply these settings to all Juju models during the controller-creation
process:

```bash
juju bootstrap \
--model-default http-proxy=$PROXY_HTTP \
--model-default https-proxy=$PROXY_HTTPS \
--model-default no-proxy=$PROXY_NO \
localhost lxd
```


<!-- LINKS -->

[charms-offline]: ./charms-offline.html
