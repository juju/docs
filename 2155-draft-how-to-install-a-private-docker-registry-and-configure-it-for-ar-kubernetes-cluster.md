[note status=Warning]
Very early draft
[/note]

Adding a private Docker registry is essential for enterprises wishing to maintain control of hosting their proprietary software while utilising container technology.

Reasons why you might want to deploy a private Docker registry:

- speed up deployments by hosting popular images within your own infrastructure
- use Docker-enabled technologies, such as Kubernetes from, within an air-gapped hosting environment  
- increase resilience by not needing to rely on the global public registry
- increase security by reducing the likelihood of sidechannel attacks by only allowing whitelisting images to be installed by your teams 

The tool that we'll be using for this tutorial is Juju.  To install Juju, visit [Getting Started with Juju](/t/getting-started-with-juju/1970).

[note status="What is Juju?"]
Juju is devops software. It's the easiest way to deploy, configure and maintain workloads in containers, VMs and bare metal.
[/note]

## Deploy a Docker registry with 4 commands

On a command line prompt:


### Command 1: Deploy the registry

The `deploy` command accesses the Juju charm store. I

Command to run:

```plain
juju deploy ~containers/docker-registry
```

Output: 

```plain
Located charm "cs:~containers/docker-registry-152".
Deploying charm "cs:~containers/docker-registry-152"
```

### Commands 2 and 3: Add relations

[note status=hello] 
This  fd
[/note]

If you have also installed the charmed-kubernetes or kubernetes-core bundles, then the process


```
juju expose docker-registry
```
Dockerfile
```
FROM ubuntu:18.04
LABEL \
  description="Example Dockerfile used for illustrating deploying a private Docker registry with Juju" \
  maintainer="tsm@canonical.com" \
  vendor="Canonical"

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE=/var/run/apache2/apache2$SUFFIX.pid
ENV APACHE_LOCK_DIR=/var/lock/apache2
VOLUME /var/www/html

RUN apt-get update
RUN apt-get install -y apache2 
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR
 
EXPOSE 80
 
CMD ["apache2","-DFOREGROUND"]
```

```
docker build -t httpd:testing .
```

View status

```plain
$ juju status
Model   Controller  Cloud/Region                   Version      SLA          Timestamp
docker  bos         canonistack/canonistack-bos01  2.7-beta1.1  unsupported  15:56:25+13:00

App              Version  Status   Scale  Charm            Store       Rev  OS      Notes
docker-registry           active       1  docker-registry  jujucharms  152  ubuntu  exposed
easyrsa          3.0.1    active       1  easyrsa          jujucharms  277  ubuntu  

Unit                Workload  Agent  Machine  Public address  Ports     Message
docker-registry/0*  active    idle   0        10.48.131.236   5000/tcp  Ready at 10.48.131.236:5000 (https).
easyrsa/0*          active    idle   1        10.48.130.170             Certificate Authority connected.

Machine  State    DNS            Inst id                               Series  AZ    Message
0        started  10.48.131.236  f74afe5f-a8f2-4d68-8c3c-dcd5bfcf45be  bionic  nova  ACTIVE
1        started  10.48.130.170  2bdc56d9-1820-4004-8750-99379c11a9fb  bionic  nova  ACTIVE
```

Use variables to make things easier
```
export IP=`juju run --unit docker-registry/0 'network-get website --ingress-address'`
export PORT=`juju config docker-registry registry-port`
export REGISTRY=$IP:$PORT

```

Optional: Set basic auth password

```
juju config docker-registry auth-basic-password=password
```

Fetch IP address

```plain
juju run --unit docker-registry/0 'network-get website --ingress-address'
```

upload a docker image to the custom registry

```plain
docker tag httpd:testing 10.48.131.236:5000/httpd:testing
```
We can verify that the self-hosted Docker repository has been tagged correctly.


```plain
docker images
```

```plain
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
10.48.131.236:5000/ubuntu   http                c89514e93594        2 minutes ago       188MB
...
```

Because we use a self-signed certificate, pushing the image fails by default:

```plain
docker push 10.48.131.236:5000/ubuntu:http
```

```plain
The push refers to repository [10.48.131.236:5000/ubuntu]
Get https://10.48.131.236:5000/v2/: x509: certificate signed by unknown authority
```

We need to extract the CA cert file that our locally hosted Certificate Authority created. Oh yeah, by the way, we also installed a Certificate Authority to ensure that all communication with our private Docker registry occurs over TLS.

```plain
juju config docker-registry tls-ca-path
``` 
```
/etc/docker/registry/ca.crt
```

To extract it, Juju has a built-in SCP helper for working with machines. Machine `0` hosts the `docker-registry/0` unit.

SCP the ca.cert file to the current working directory.

```plain
# juju scp 0:/usr/local/share/ca-certificates/juju-docker-registry.crt ```

juju scp 0:/etc/docker/registry/ca.crt ./
sudo chown root ca.crt
sudo chgrp root ca.crt
```

Move it its new home

Create a new `certs.d` directory
 
When using snap:

```plain
sudo mkdir -p  /var/snap/docker/common/etc/certs.d/$REGISTRY
sudo mv ca.crt /var/snap/docker/common/etc/certs.d/$REGISTRY/ca.crt
```

Standard docker

```plain
```



Restart 

```plain
sudo snap restart docker
```
or

```plain
sudo systemctl restart docker.service
```



## Configuring Docker to use your custom registry

## Configuring Kubernetes to use your custom Docker register

## Next Steps

-
