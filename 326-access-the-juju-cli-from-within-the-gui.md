In the Juju GUI 2.11.1 release, we are excited to bring a new feature we’ve been working on for a while now: the shell in the GUI.

The GUI is a powerful tool, but at times the command-line is necessary. For instance, the ability to SSH into a unit helps for debugging processes or accessing data directly. Running debug-hooks is another: if a unit is stopped during one of its hooks and you need to see if you can get it up and running, sometimes debug-hooks is your best bet.

However, not all developer situations have the CLI available. If you’re accessing your environment from Windows, getting to the tools you need from the CLI isn’t trivial.

To address these cases, we’ve developed the jujushell functionality.

The shell in the GUI consists of a few different, parallel lines of work. The first is an update in the GUI. This adds the ability to connect to a jujushell server through the browser using the xterm.js library. This will give you a pane into which you can read and write from a terminal.

The terminal itself is hosted through terminado, a means of providing a shell over a websocket connection. In this instance, the goal is to give access to a terminal running on a server.

The server is, appropriately enough, a charm. When you deploy this charm to your environment, it will spin up a unit which you will connect to via terminado.

Naturally, this would be a less than ideal situation in many respects. For one, it might not be secure to run the terminal directly on a unit. If you mess something up on the unit, it can be pretty easy to wind up in an error state in your environment.

To this end, the shell is not structured to allow connecting to the unit itself, but to LXC containers spun up on the unit.

These containers are simple and lightweight by design, taking up a minimum of ram, CPU, and disk space. They all have juju installed on them, of course, and as soon as one is spun up, you will have access to your environment. No additional work is needed. You’re already logged into your model from the GUI, so there is no need to log in from the shell, either.

This connection is managed and proxied via the jujushell service itself. This is a simple service written in Go which will perform a handshake with the GUI, set up your LXC, and then start proxying your connection from the browser, through the unit, to the terminado service running within the container itself.

That’s a lot of moving parts, but we’ve made it simple to set up.

The first step is to bootstrap a controller. This will get you up and running with a default model. If you already have a non-JAAS controller, you can do this in one of your already existing models or a new model to play around in.

Once your controller is bootstrapped, you can open the controller and log in with the address and credentials available from the <code class="highlighter-rouge">juju gui</code> command or provided to you by someone with the credentials.

From within the GUI, search for the jujushell charm (for instance, <code class="highlighter-rouge">cs:~juju-gui/jujushell</code>) and deploy it. This will add the application to your model to connect to with the shell.

Here is a setup done via the CLI following the same steps:

<a href="http://writing.drab-makyo.com/assets/tech/gitg/0.png"><img src="http://writing.drab-makyo.com/assets/tech/gitg/0.png" alt="CLI example" /></a>

Once this application is deployed, you will need to expose it and configure it.

For the configuration you will need a DNS name. This is necessary to allow secure websockets. Internally, the charm uses Lets Encrypt to generate certs, which require a domain name. In the <code class="highlighter-rouge">dns-name</code> configuration setting, enter this domain (e.g: example.com).

<a href="http://writing.drab-makyo.com/assets/tech/gitg/1.png"><img src="http://writing.drab-makyo.com/assets/tech/gitg/1.png" alt="Configure the charm" /></a>

You will also need to set up your domain name with the IP address of the unit. This can be found in the inspector in the GUI by viewing the unit details.

<a href="http://writing.drab-makyo.com/assets/tech/gitg/2.png"><img src="http://writing.drab-makyo.com/assets/tech/gitg/2.png" alt="Setting up the domain" /></a>

Once you have configured and exposed your application, save your changes and click to commit the changes with the button at the bottom right of the GUI. Then, wait for the DNS to propagate and for the unit to be ready.

At this point, the application is ready to serve Juju CLI sessions. Anyone connected to the controller can use the application, once they’ve set their GUI up to recognize the terminal.

For this, you will need to open the GUI settings by typing <code class="highlighter-rouge">shift+1</code>. In the settings pane, enter in the DNS name for the service in the provided input (e.g: example.com), and click save.

<a href="http://writing.drab-makyo.com/assets/tech/gitg/3.png"><img src="http://writing.drab-makyo.com/assets/tech/gitg/3.png" alt="Setting up the shell address" /></a>

From there, you can switch to a model (or click back to the canvas), and you should see a new button appear in the header with a prompt icon.

When clicked, all of the magic begins to happen. The websocket connection between the browser and the jujushell service is made, the service starts spinning up an LXC. This part may take a second, but once the container is set up, a shell prompt will appear, showing the name of the currently connected model.

<a href="http://writing.drab-makyo.com/assets/tech/gitg/4.png"><img src="http://writing.drab-makyo.com/assets/tech/gitg/4.png" alt="The shell" /></a>

There you have it, a shell into your model! From here, you can run juju any juju commands — try it out with <code class="highlighter-rouge">juju status</code> — and you’re ready to go.

(Originally written by Madison Scott-Clary on the Juju GUI blog)
