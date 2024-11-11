(juju-reference)=
# Juju Reference

<!--Technical information - specifications, APIs, architecture, etc., related to Juju-->


Welcome to Juju Reference docs -- our cast of characters (tools, concepts, entities, and processes) for the Juju story!

When you install a Juju {ref}`client <client>`, for example the  {ref}``juju` CLI client <juju-juju-client>`, and give Juju access to your {ref}`cloud <cloud-substrate>` (Kubernetes or otherwise), your Juju client {ref}`bootstraps <bootstrapping>` a  {ref}`controller <controller>` into the cloud. 

From that point onward you are officially a Juju  {ref}`user <user>` with a {ref}``superuser` access level <5348md>` and therefore able to use Juju and {ref}`charms <charm>` or {ref}`bundles <bundle>` from our large collection on {ref}`Charmhub <charmhub>` to manage {ref}`applications <application>` on that cloud.

In fact, you can also go ahead and add another cloud definition to your controller, for any cloud in our long {ref}`list of supported clouds <list-of-supported-clouds>`.      

On any of the clouds, you can use the controller to set up a {ref}`model <model>`, and then use Juju for all your application management needs -- from application {ref}`deployment <deploying>` to {ref}`configuration <configuration>` to {ref}`constraints <constraint>` to {ref}`scaling <scaling>` to {ref}`high-availability <high-availability-ha>`  to {ref}`integration <relation-integration>` (within and between models and their clouds!) to {ref}`actions <action>` to {ref}`secrets <secret>` to {ref}`upgrading <upgrading-things>` to {ref}`teardown <removing-things>`.     

You don't have to worry about the infrastructure -- the Juju controller {ref}`agent <agent>` takes care of all of that automatically for you. But, if you care, Juju also lets you manually control {ref}`availability zones <zone>`, {ref}`machines <machine>`, {ref}`subnets <subnet>`, {ref}`spaces <space>`, {ref}`secret backends <secret-backend>`, {ref}`storage <storage>`.                        

      
<!--      
- {ref}`Channel <channel>`          
                   
    - {ref}`List of controller configuration keys <list-of-controller-configuration-keys>`      
    - {ref}`List of model configuration keys <list-of-model-configuration-keys>`           
-                                
                        
- {ref}`Credential <credential>`
-                              
- {ref}`Endpoint <endpoint>`                                   
-                    
- Juju
    - {ref}`Juju roadmap & releases <roadmap--releases>`                                        
    - {ref}`Juju version compatibility matrix <5348md>`                   
- {ref}``juju` (CLI client) <juju-juju-client>`                          
    - {ref}``juju` CLI commands <juju-cli-commands>`                     
    - {ref}``juju` environment variables <juju-environment-variables>`   
- {ref}``juju-dashboard` (the Juju dashboard) <the-juju-dashboard>`        
- {ref}``juju` (web CLI) <the-juju-web-cli>`
- {ref}``jujuc` (binary) <binary-jujuc>`             
- {ref}``jujud` (binary) <binary-jujud>`                      
- {ref}`Leader <leader>`                                     
- {ref}`Log <log>`                                        
                        
- {ref}`Metric <metric>`                                     
- 
- {ref}`Offer <offer>`                                      
- {ref}`Operation <operation>`                                                   
- {ref}`Placement directive <placement-directive>`                        
- {ref}`Plugin <plugin>`                                     
    - {ref}`List of known plugins <list-of-known-juju-plugins>`                      
    - {ref}`Plugin flags <plugin-flags>`
- {ref}`python-libjuju (client) <python-libjuju-juju-client>`                               
                                              
- 
- {ref}`Resource (charm) <resource-charm>`       
                            
- {ref}`SSH key <ssh-key>`    
- {ref}`Status <status>`                                
- {ref}`                               
    - [Storage constraint <storage-constraint-directive>`                         
    - {ref}`Storage pool <storage-pool>`                               
    - {ref}`Storage provider <storage-provider>`                           
    - {ref}`Dynamic storage <dynamic-storage>`                            
    - {ref}`Storage support <storage-support>`                             
- 
- {ref}`Task <task>`                                       
- {ref}`Telemetry <telemetry>`
- {ref}``terraform` (CLI client) <terraform-juju-juju-client>`                                  
- {ref}`Unit <unit>`                                       
                                        
- ->