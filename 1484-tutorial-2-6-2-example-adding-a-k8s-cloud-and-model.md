I want to give an example breakdown of what it actually took to get a k8s model added.

1. Deploy CDK + AWS Integrator

Deploy CDK, trusting and relating the aws-integrator. The resultant juju environment should resemble:
```bash
Model                   Controller     Cloud/Region   Version  SLA          Timestamp
k8s-jenkins-testing-00  aws-us-west-2  aws/us-west-2  2.6.2    unsupported  00:03:52Z

App                Version   Status  Scale  Charm              Store       Rev  OS      Notes
aws-integrator     1.16.148  active      1  aws-integrator     jujucharms    9  ubuntu  
easyrsa            3.0.1     active      1  easyrsa            jujucharms  235  ubuntu  
etcd               3.2.10    active      1  etcd               jujucharms  414  ubuntu  
flannel            0.10.0    active      2  flannel            jujucharms  403  ubuntu  
kubernetes-master  1.14.1    active      1  kubernetes-master  jujucharms  651  ubuntu  exposed
kubernetes-worker  1.14.1    active      1  kubernetes-worker  jujucharms  518  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
aws-integrator/0*     active    idle   2        172.31.103.169                  ready
easyrsa/0*            active    idle   0/lxd/0  252.100.42.13                   Certificate Authority connected.
etcd/0*               active    idle   0        34.210.121.68   2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  active    idle   0        34.210.121.68   6443/tcp        Kubernetes master running.
  flannel/1           active    idle            34.210.121.68                   Flannel subnet 10.1.76.1/24
kubernetes-worker/0*  active    idle   1        54.213.24.84    80/tcp,443/tcp  Kubernetes worker running.
  flannel/0*          active    idle            54.213.24.84                    Flannel subnet 10.1.6.1/24

Machine  State    DNS             Inst id              Series  AZ          Message
0        started  34.210.121.68   i-0a001a28ab902edbc  bionic  us-west-2a  running
0/lxd/0  started  252.100.42.13   juju-fee20a-0-lxd-0  bionic  us-west-2a  Container started
1        started  54.213.24.84    i-00b30638165b366b2  bionic  us-west-2a  running
2        started  172.31.103.169  i-0dd296592dfe14cb9  bionic  us-west-2b  running
```

2. SCP the kubeconfig, export, add-cloud
Following the deployment of our kubernetes cluster we scp the kubeconfig to local, export KUBECONFIG env var, and add a juju model (juju prevented us from doing this and landed a well phrased error).
```bash
$ juju scp kubernetes-master/0:config ~/.kube/
$ export KUBECONFIG=~/.kube/config
$ juju add-k8s bdx-k8s-cloud 

ERROR 	Juju needs to query the k8s cluster to ensure that the recommended
	storage defaults are available and to detect the cluster's cloud/region.
	This was not possible in this case so run add-k8s again, using
	--storage=<name> to specify the storage class to use and
	--region=<cloudType>/<region> to specify the cloud/region.
```

This led us to manually provision a storage class and provide the cloud/region and storage when running the `add-k8s` command.

Here are a few different storage classes that we use in AWS.

##### EBS StorageClass
```bash
$ kubectl create -f - <<EOY
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-1
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
EOY
```

##### Local StorageClass
```bash
kubectl create -f - <<EOY
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-1
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOY
```

With either of the above storage classes created we were able to successfully add a k8s cloud by specifying the StorageClass name when adding the cloud. For example, using `ebs-1` from above:
```bash
juju add-k8s bdx-k8s-cloud --storage=ebs-1 --region aws/us-west-2

k8s substrate "aws/us-west-2" added as cloud "bdx-k8s-cloud" with storage provisioned
by the existing "ebs-1" storage class
operator storage provisioned by the workload storage class.
```

3. Add K8S Model
Finally add the model.
```bash
juju add-model bdx-k8s-model bdx-k8s-cloud
Added 'bdx-k8s-model' model on bdx-k8s-cloud with credential 'admin' for user 'bdx'
```


This is how I was able to get a k8s model up using 2.6.2. I haven't yet come across any documentation that details the portion of creating a storage class using kubectl in the workflow of creating a model. Just thought I would document my experience.
