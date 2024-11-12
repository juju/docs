(scaling)=
# Scaling

> See also: {ref}`How to scale an application <13137md>`

In the context of a cloud deployment in general, **scaling**  means modifying the amount of resources thrown at an application, which can be done *vertically* (modifying the memory, CPU, or disk for a cloud resource) or *horizontally* (modifying the number of resources), where each can be *up* (more) or down (*less*). In the context of Juju, scaling means exactly the same, with the mention that 

- Vertical scaling is handled through {ref}`constraints <constraint>` and horizontal scaling through {ref}`units <unit>`. 
- Horizontal scaling up can be used to achieve {ref}`high availability (HA) <high-availability-ha>` -- though, depending on whether the charm delivering the application supports HA natively or not, you may also have to perform additional steps.


<!--UNNECESSARY because already covered in the HTG:
- Vertical scaling is handled through {ref}`constraints <constraint>` and horizontal scaling through {ref}`units <unit>`. 

> See more: {ref}`How to manage machine constraints for an application <13137md>`

- Horizontal scaling up can be used to achieve {ref}`high availability (HA) <high-availability-ha>` -- though, depending on how the charm was designed, other steps (integration with a load balancer or a proxy) may be needed as well.
-->