(performance-with-juju)=
# Performance with Juju

Juju is designed with performance in mind. With Juju, your cloud operations become:


- **Quick and easy.** 

Juju is intuitive. To deploy an application, run `juju deploy`. To configure it, run `juju config`.  And so on.

> See more: {ref}`Get started with Juju <get-started-with-juju>`

- **Powerful.** 

In Juju, application integration is a first-class citizen: To integrate, run `juju integrate`.  With 160+ intuitive CLI commands, any operation is just one command line away.

> See more: {ref}`Juju CLI commands <juju-cli-commands>`

- **Optimizable.** 

When you `juju deploy`, Juju automatically provisions infrastructure for you. However, you can also fine-tune the CPU, memory, and network resources, or ssh into a machine or pod. And Juju applications ship with sensible defaults, but they also expose further knobs that you may wish to turn -- say hello to 'configurations' and 'actions'!

> See more: {ref}`How to manage machines <how-to-manage-machines>`, {ref}`How to manage storage <how-to-manage-storage>`, {ref}`How to manage spaces <how-to-manage-spaces>`

- **Scalable.** 

You need to make an application highly available? Just add a few more applications units!

> See more: {ref}`How to scale an application <12246md>`

- **Portable.** 

Juju is model-driven. It separates application logic from business logic, and takes care of the former so you can focus on the latter. Whatever you want done, declare it in a model. The model is attached to a controller bootstrapped into a cloud. You can export and share it or migrate it to another controller on another cloud. You can also connect workloads on different models and even different clouds. With Juju supporting a long list of clouds -- public or private, machine or Kubernetes, branded or entirely ad hoc -- the possibilities are endless.  

> See more: 
> - {ref}`How to migrate a model <12246md>`
> - {ref}`How to manage cross-model integrations <how-to-manage-offers>`
> - {ref}`List of supported clouds <list-of-supported-clouds>`

- **Responsive and efficient.** 

Juju is designed to be both concurrent and parallel. It can manage multiple applications, services, and environments responsively and efficiently.

- **Observable.** 

Juju's performance can be monitored using built-in tools and third-party solutions.