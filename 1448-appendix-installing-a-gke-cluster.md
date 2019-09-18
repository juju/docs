This appendix contains a concise how-to for installing a Google GKE Kubernetes cluster and running a demo application on it.

It assumes you have a GCP account and project. When encountered, replace **${PROJECT_ID}** with your own project's ID. In this document the project ID is 'juju-239814'.

These instructions are based largely on [upstream GKE documentation][google-gcloud-docs].

This appendix was written using Google Cloud SDK `v.244.0.0` and Docker CE `v.18.09.6`, all running on Ubuntu 18.04.2 LTS (Bionic). Although both the SDK and Docker can be installed via snaps, it was found that doing so led to problems later on.

<h2 id='heading--install-the-google-cli-tools'>Install the Google CLI tools</h2> 

Install the Google CLI tools. This will provide the `gcloud` binary. 

```text
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update && sudo apt install google-cloud-sdk
```

Set values for GCP project and region (use your own values):

```text
gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone us-east4
```

## Install Docker

Set up groups:

```text
sudo addgroup --system docker
sudo adduser $(whoami) docker
newgrp docker
```

Install Docker (community edition):

```text
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -c -s) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```

Verify the install:

```text
docker run hello-world
```

## Build an application

Build a sample application container image called 'hello-app':

```text
cd
git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples
cd kubernetes-engine-samples/hello-app
docker build -t gcr.io/${PROJECT_ID}/hello-app:v1 .
```

List the application image:

```text
docker images
```

Output:

```text
REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
gcr.io/juju-239814/hello-app     v1                  1b98f4b8499f        2 seconds ago       11.4MB
```

## Set up authentication and APIs

Allow the `docker` command to use `glcoud` for authentication, then log in:

```text
gcloud auth configure-docker --quiet
gcloud auth login --brief
```

Ensure that the Container Registry API and the Kubernetes Engine API are enabled:

```text
gcloud services enable containerregistry.googleapis.com --project ${PROJECT_ID}
gcloud services enable container.googleapis.com --project ${PROJECT_ID}
```

Use `gcloud services list` to see currently enabled services. Add option `--available` to see a list of all available services.

## Upload the container image and create the cluster

Upload the container image:

```text
docker push gcr.io/${PROJECT_ID}/hello-app:v1
```

Create a two-node Kubernetes cluster called 'hello-cluster':

```text
gcloud container clusters create hello-cluster --num-nodes=2
```

## Deploy your application

Install the `kubectl` utility:

```text
sudo snap install kubectl --classic
```

Define a deployment called 'hello-web' in `~/hello-web.yaml`:

```text
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-web
  labels:
    app: hello-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello-app
        image: gcr.io/juju-239814/hello-app:v1
```

Create the deployment:

```text
kubectl apply -f ~/hello-web.yaml
```

Expose the application externally. Have it listen on port 8080 and redirect to it from port 80: 

```text
kubectl expose deployment hello-web --type=LoadBalancer --port 80 --target-port 8080
```

Discover the assigned external IP address of the application (it may take a minute):

```text
kubectl get service hello-web
```

Output:

```text
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
hello-web    LoadBalancer   10.7.247.133   35.245.115.183   80:31446/TCP   56s
```

The exposed IP address of the application is '35.245.115.183'.

Pointing a browser to http://35.245.115.183 (port 80) should give you output similar to:

```text
Hello, world!
Version: 1.0.0
Hostname: hello-web-7969d89bd5-hjdbz
```

Where the hostname is the name of the pod:

```text
kubectl get pods
```

Output:

```text
NAME                         READY   STATUS    RESTARTS   AGE
hello-web-7969d89bd5-hjdbz   1/1     Running   0          2m
```

## Viewing information

Miscellaneous methods for viewing information:

```text
docker images
gcloud container clusters list
kubectl cluster-info
kubectl get deployments --all-namespaces
kubectl get services
kubectl get pods
kubectl get nodes
gcloud compute instances list
```

## Cleaning up

The below commands are given in order of increasing destruction.

Undo the `expose` sub-command:

```text
kubectl delete service hello-web
```

Remove the deployment (and pod(s)):

```text
kubectl delete deployment hello-web
```

Remove the cluster:

```text
gcloud container clusters delete hello-cluster
```

Remove Docker:

```text
sudo apt purge docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
```


<!-- LINKS -->

[google-gcloud-docs]: https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app#option_b_use_command-line_tools_locally
