**Usage:** `juju add-relation [options] <application1>[:<endpoint name1>] <application2>[:<endpoint name2>]`

**Summary:**

Add a relation between two application endpoints.

**Options:**

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--via (= "")`

for cross model relations, specify the egress subnets for outbound traffic

**Details:**

Add a relation between 2 local application endpoints or a local endpoint and a remote application endpoint. Adding a relation between two remote application endpoints is not supported. Application endpoints can be identified either by:

     <application name>[:<relation name>]
          where application name supplied without relation will be internally expanded to be well-formed
or `.[:]` where the application is hosted in another model owned by the current user, in the same controller

or `/.[:]` where user/model is another model in the same controller

For a cross model relation, if the consuming side is behind a firewall and/or NAT is used for outbound traffic, it is possible to use the `--via` option to inform the offering side the source of traffic so that any required firewall ports may be opened.

**Examples:**

       $ juju add-relation wordpress mysql
            where "wordpress" and "mysql" will be internally expanded to "wordpress:db" and "mysql:server" respectively

        $ juju add-relation wordpress someone/prod.mysql
            where "wordpress" will be internally expanded to "wordpress:db"

        $ juju add-relation wordpress someone/prod.mysql --via 192.168.0.0/16

        $ juju add-relation wordpress someone/prod.mysql --via 192.168.0.0/16,10.0.0.0/8
**Aliases:**

relate
