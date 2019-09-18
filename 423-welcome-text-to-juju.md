Looking at the intro to Juju on its [README](https://github.com/juju/juju/blob/develop/README.md), I don't think the project explains what the benefits of Juju are for developers/teams clearly. 

> Juju enables you to use Charms to deploy your application architectures to EC2, OpenStack, Azure, GCE, your data center, and even your own Ubuntu based laptop. Moving between models is simple giving you the flexibility to switch hosts whenever you want — for free.

If you don't understand what a "Charm" is, then it looks like the only benefit that you would get from Juju is the ability to migrate hosts. And that assumes that you are comfortable with the term "application architectures". A smaller point is that Juju can be driven from anywhere, not just an Ubuntu-based laptop.

Here's an alternative introduction that's hopefully better at explaining how Juju helps (although it's far far longer :confused: ):

> Juju is a devops system that is ideal for complex software stacks. It is a configuration management system that allows you to focus on your application by freeing you from details. Instead of deploying single applications and wiring them together manually, you work with sets of applications that work as a cohesive whole. We call this working with charms.
>
> As an example, let's consider deploying a "simple" LAMP stack application: MediaWiki. Traditionally you would need to configure a web server, PHP and a database, plus manage their ports and security. Adding a load balancer adds more complexity. With Juju, the story is much simpler:
>     
>     juju bootstrap ec2
>     juju deploy wiki-scalable 
>     juju expose loadbalancer
>
> With these 3 lines, you would have provisioned 5 virtual machines and deployed inter-connected services running on each of them. The only VM exposed to the internet is your correctly-configured HAProxy instanced, that we're calling `loadbalancer`. 
>
> Juju allows you to use the same tool to deploy to your preferred hosting environment, whether that's bare metal, virtual machines or containers.  Juju is supported by Canonical, the company that delivers Ubuntu. Charms have been developed by Canonical, its partners such as HPE & IBM, and the wider devops community.
