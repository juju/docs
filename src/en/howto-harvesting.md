Title: Juju and machine utilization  

# Juju and utilized machines

Juju can manage the entire life cycle of a service. When deploying a
Charm, Juju will start and provision machines. Likewise, when
expanding capacity for services, Juju can automatically utilize your
provider's elastic computing capabilities and add more machines with
the services provisioned.

Should you ever need to destroy machines or services, Juju can help
with that too. Juju keeps a model of what it thinks the environment
looks like, and based on that model, can harvest machines which it
deems are no longer required. This can help keep your costs low, and
keep you out of web consoles.

So how does harvesting in Juju work?

# Machine states

To discuss how Juju manages machines, it's important to first
understand how Juju perceives machines in the environment.

Juju slots machines into 4 different states:

## Alive

The machine is up and being utilized.

## Dying

The machine is in the process of being terminated by Juju, but hasn't
yet finished.

## Dead

The machine has been successfully brought down by Juju, but is still
being tracked for removal.

## Unknown

The machine is alive, but Juju knows nothing about it.

# Harvesting modes

## None

Using this method, Juju won't harvest any machines. This is the
most conservative, and a good choice if you manage your machines
utilizing a separate process outside of Juju.

## Destroyed

This is Juju's default. Using this methodology, Juju will harvest only
machine instances that are dead, and that Juju knows about. Unknown
instances will not be harvested.

## Unknown

Utilizing this method, Juju will harvest only instances that Juju
doesn't know about.

## All

This is the most aggressive setting. Utilizing this, Juju will
terminate all instances &#x2013; destroyed or unknown &#x2013; that it
finds. This is a good option if you are only utilizing Juju for your
environment.

# Modifying harvesting mode

Juju's harvesting behaviour is set through the environments.yaml file.
To change the default behaviour, edit this file and set the
"provisioner-harvest-mode" key to the desired harvesting mode.
