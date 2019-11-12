[note type=caution status="Early draft"]
This guide contains gaps.
[/note]

Database performance is heavily dependent on the underlying I/O substrate. Production databases perform best when they are a sole tenant on a physical host. But containers provide much better density 

With Juju, you can have the best of both worlds.  

## Why not deploy databases to Kubernetes?

Systems administrators are always (rightfully) sceptical when a tool tries to take control. Databases are the foundation upon which applications are built. 

Databases are sensitive to latency. No application likes to receive its data late. Users like to know that when they ciick save, that something is actually saved. Fast transaction speeds reduce the likelihood of a transaction being affected by power outages and forced shutdowns. When accessing the disk slows down, performance problems cascade.

High-density, multi-tenant deployments create contention on central systems, such as I/O. Introducing another abstraction, such as Kubernetes :k8s: masks what is actually going on. Debugging becomes more difficult as there is less visibility about what is happening under the hood. Administrators also loose access to tweaks.    

Database systems are often engineered to make use of common 

## What does Juju offer?

Juju gives you the control to deploy and manage your workloads where you feel they're best deployed. You do not need to sacrifice you existing infrastructure choices to make use of Kubernetes. Juju allows you to retain stability and provide agility.


Juju provides you with the ability to host applications wherever you feel is appropriate, and have them work together in the 

## Walkthrough

Outline:
- add cloud infra (MAAS nice but not required)
- add-model storage, deploy cs:postgresql 
- offer postgresql:db
- add k8s, switch
- add-model app
- deploy app
- consume infra/postgresql:db


## How is this achieved?

Juju relations.

---- 

## References 

https://discourse.jujucharms.com/t/k8s-on-metal-storage-configuration-for-use-with-juju/2281
