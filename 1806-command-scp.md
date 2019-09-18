**Usage:** `juju scp [options] <source> <destination>`

**Summary:**

Transfers files to/from a Juju machine.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-host-key-checks (= false)`

Skip host key checking (INSECURE)

`--proxy (= false)`

Proxy through the API server

**Details:**

The source or destination arguments may either be a local path or a remote location. The syntax for a remote location is:

         [<user>@]<target>:[<path>]
If the user is not specified, "ubuntu" is used. If is not specified, it defaults to the home directory of the remote user account.

The may be either a 'unit name' or a 'machine id'. These can be obtained from the output of `juju status`.

Options specific to scp can be provided after a `--`. Refer to the scp(1) man page for an explanation of those options. The `-r` option to recursively copy a directory is particularly useful.

The SSH host keys of the target are verified. The `--no-host-key-checks` option can be used to disable these checks. Use of this option is not recommended as it opens up the possibility of a man-in-the-middle attack.

**Examples:**

Copy file /var/log/syslog from machine 2 to the client's current working directory:

`   juju scp 2:/var/log/syslog .`

Recursively copy the /var/log/mongodb directory from a mongodb unit to the client's local remote-logs directory:

`   juju scp -- -r mongodb/0:/var/log/mongodb/ remote-logs`

Copy foo.txt from the client's current working directory to an apache2 unit of model "prod". Proxy the SSH connection through the controller and turn on scp compression:

`   juju scp -m prod --proxy -- -C foo.txt apache2/1:`

Copy multiple files from the client's current working directory to machine 2:

`   juju scp file1 file2 2:`

Copy multiple files from the bob user account on machine 3 to the client's current working directory:

`   juju scp bob@3:'file1 file2' .`

Copy file.dat from machine 0 to the machine hosting unit foo/0 (-3 causes the transfer to be made via the client):

`   juju scp -- -3 0:file.dat foo/0:`

**See also:**

[ssh](https://discourse.jujucharms.com/t/command-ssh/1834)
