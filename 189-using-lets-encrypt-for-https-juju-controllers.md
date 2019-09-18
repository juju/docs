To setup a Juju Controller with Let's Encrypt SSL you need to know what the DNS name will be before you bootstrap. That's passed into the controller config in the `autocert-dns-name` value. Once you know the DNS name you plan to use you can bootstrap like so:

    $ juju bootstrap google jujushow-dns --config autocert-dns-name=show.jujugui.org

The controller will come up and we need to setup the DNS for this controller. You will need to go into your DNS settings and set the IP address of the controller machine to the DNS entry you're setting up. Getting the IP address of the controller can be done using `juju status` of the controller model. 

    $ juju status -m controller
    Machine  State    DNS            Inst id        Series  AZ          Message
    0        started  35.231.72.223  juju-63bb34-0  xenial  us-east1-b  RUNNING

The address `35.231.72.223` will need to be set to the DNS entry *show.jujugui.org*. Note that it might take a few for the DNS changes to take effect. You can test that it's going through by ping'ing the controller

    $ ping show.jujugui.org
    PING show.jujugui.org (35.231.72.223) 56(84) bytes of data.
    64 bytes from 223.72.231.35.bc.googleusercontent.com (35.231.72.223): icmp_seq=1 ttl=58 time=65.2 ms

At this point you can attempt to reach the controller GUI using the URL and it will kick off the Let's Encrypt dance to setup your SSL certificate. Once the GUI loads you'll note that it'll have a valid SSL certificate provided by Let's Encrypt. 

https://show.jujugui.org

![https_gui|690x476](upload://soapJyEmFHBZ03sBezKDZ1fjdUn.jpg)
