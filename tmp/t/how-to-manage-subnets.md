(how-to-manage-subnets)=
# How to manage subnets

> See also: {ref}`Subnet <subnet>`


**Contents:**

- [List subnets](#heading--list-subnets)
- [Move a subnet to another space](#heading--move-a-subnet-to-another-space) 

<!-- THIS FEATURE IS BEING REMOVED. ADDING A SUBNET IS SOMETHING YOU DO OUTSIDE OF JUJU.
- [Add a subnet](#heading--add-a-subnet)

<a href="#heading--add-a-subnet"><h2 id="heading--add-a-subnet">Add a subnet</h2></a>
> See also: {ref}``juju add-subnet` <6663md>`

-->

<a href="#heading--list-subnets"><h2 id="heading--list-subnets">List subnets</h2></a>

To view the subnets known to `juju`, run:

```text
juju subnets

```

```{dropdown} Expand to see a sample output

```
subnets:
  172.31.0.0/20:
    type: ipv4
    provider-id: subnet-9b4ed4fc
    provider-network-id: vpc-54a7112e
    status: in-use
    space: alpha
    zones:
    * us-east-1c
  172.31.16.0/20:
    type: ipv4
    provider-id: subnet-eca389a6
    provider-network-id: vpc-54a7112e
    status: in-use
    space: alpha
    zones:
    * us-east-1a
...
```

```

> See more: {ref}``juju subnets` <command-juju-subnets>`

<a href="#heading--move-a-subnet-to-another-space"><h2 id="heading--move-a-subnet-to-another-space">Move a subnet to another space</h2></a>

For all providers other than MAAS, all subnets are initially in a default `alpha` space. 
To move a subnet `172.31.16.0/20` to a different space, `db-space`, execute:

```text
juju move-to-space db-space 172.31.16.0/20
```
----
```{dropdown} Expand to see a sample output

Subnet 172.31.16.0/20 moved from alpha to db-space

```

----

> See more: {ref}``juju move-to-space` <command-juju-move-to-space>`

<br>

> <small>**Contributors:** @manadart, @tmihoc </small>