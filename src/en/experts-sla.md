Title: Managed solutions

# Managed solutions

A Juju Expert is a partner backed by professional support at Canonical Ltd.
Such a partner deploys and supports an infrastructure based on Juju. We call
this a *managed solution*.

Any support requests beyond the build, workload, and operation of a particular
solution can be escalated to Canonical by means of their Ubuntu Advantage
support framework. Prime examples of such requests are for issues relating to
Juju itself, Ubuntu-specific software, or the operating system kernel. The
escalated support case will be treated by Canonical at the same support level
currently ascribed to the partner. Hence, support level names used by both a
Juju Expert and by Canonical are the same:

 - Essential
 - Standard
 - Advanced

See [Ubuntu Advantage for Servers][ubuntu-advantage-servers] for more
information on Canonical support levels.

The Juju Expert will provide details such as support levels and costs on a
per-solution basis but ultimately an SLA will be conferred upon a specific Juju
model (see [Models][models]).

Consult the external [Juju Experts][juju-experts] page to find a managed
solution partner for your project.

## Requirements

The following requirements need to be met before setting an SLA for the first
time:

 1. The Juju operator will need an [Ubuntu SSO][ubuntu-sso] account.
 1. The Juju operator will need to have logged in to [Launchpad][launchpad]
    (via Ubuntu SSO) at least once.

## Setting an SLA

Once you have contracted out a Juju Expert you are ready to set an SLA. This is
done within Juju itself via the `sla` command, which will trigger a dialog to
authenticate to your Ubuntu SSO account.

An SLA is set on a per-model basis, and includes two key parameters in order
for support to become active:

 1. Support level
 1. Budget limit

Support costs will not be billed for more than the budget limit. If metered
costs exceed this amount, the limit will need to be increased in order for
support to remain active.

For example, to set an Essential SLA on model 'default', with a monthly budget
limit of USD 100:

```bash
juju sla -m default essential --budget 100
```

```no-highlight
Model                   SLA                                                        Message
lxd:admin/default       essential       the new sla will become effective on 2018-11-05   
                                        19:22:31.433640933 +0000 UTC
```

The SLA for a model is shown at the top of the output to the `status` command:

```
Model    Controller  Cloud/Region         Version    SLA        Timestamp
default  lxd         localhost/localhost  2.5-beta1  essential  19:42:28Z
.
.
```

It is possible to simply set a support level with the `sla` command:

```bash
juju sla -m default essential
```

The model's budget will then need to be set separately. We'll show how this is
done later on.

## Changing an SLA

An SLA is increased when it moves "up" levels: 'essential' to 'standard' to
'advanced'. An SLA is decreased when it moves "down" levels: 'advanced' to
'standard' to 'essential'.

When an SLA is **increased** the resulting support level becomes effective
immediately. When an SLA is **decreased** the resulting support level becomes
effective in the next monthly billing cycle.

## Budgeting managed models

SLA budgets are organized into *wallets*. A wallet called 'primary' is created
when the `sla` command is run for the first time. It gets hardcoded as the
default wallet. The sum of all budgets in a wallet cannot exceed the wallet
limit.

### Managing wallets

List your wallets with the `wallets` command:

```bash
juju wallets
```

Sample output:

```no-highlight
Wallet          Monthly Budgeted        Available       Spent
primary*           1000      100           999.89        0.11
Total              1000      100           999.89        0.11
                                                             
Credit limit:     10000
```

The default wallet is shown with an asterisk "\*". SLA budgets are allocated
from this wallet if the wallet name is not specified.

The credit limit is the maximum monthly limit approved to spend on SLAs and is
determined between you and the Expert. You can submit a request to have this
limit increased using this link:

[https://jujucharms.com/support/create][jaas-support]

View the budgets allocated from a wallet with the `show-wallet` command:

```bash
juju show-wallet primary
```

Sample output:

```no-highlight
Model                   Spent   Budgeted         By    Usage
lxd:admin/default       0.22         100        bob    0%   
                                                            
Total                   0.22         100               0%   
Wallet                              1000                    
Unallocated                          900
```

You may update the budget limit for a model with the `budget` command:

```bash
juju budget -m lxd:admin/default 200
```

Finally, to view all the budgets associated with a wallet the `show-wallet`
command is used:

```bash
juju show-wallet primary
```

Sample output:

```
Model                   Spent   Budgeted         By    Usage
lxd:admin/default       2.42         200        bob    1%   
lxd:admin/alpha         0.00         150        bob    0%   
                                                            
Total                   2.42         350               1%   
Wallet                              1000                    
Unallocated                          650
```

The budget limit may be lowered for a model, but not below its current spent
value.

### Advanced budgeting

Additional wallets may be created for accounting or organizational purposes
with the `create-wallet` command:

```bash
juju create-wallet demo 50
```

Verify the creation of the new wallet by listing the wallets again:

```bash
juju wallets
```

Sample output:

```no-highlight
Wallet          Monthly Budgeted        Available       Spent
demo                 50        0            50.00        0.00
primary*           1000      350           997.58        2.42
Total              1050      350          1047.58        2.42
                                                             
Credit limit:     10000
```

To allocate a budget (using either the `sla` command or the `budget` command)
from a specific wallet use the form: `<wallet>:<limit>`. Here are two
examples:

```bash
juju sla essential demo:40
juju budget primary:25
```

## Metering

Metering begins once the following have occurred:

 - an SLA has been assigned to a model
 - a budget has been allocated to a model
 - the model takes on a workload
 
When metering is underway the output to the `status` command will include an
extra section:

```no-highlight
.
.
Entity  Meter status  Message
model   green
.
.
```

Determining factors for actual metering costs (e.g. fixed per-hour rate,
per-unit hour, etc.) are negotiated between you and your Expert.

## Creating a support case

When it comes time to request help from your Expert you can file a support case
using the same URL for requesting a credit limit increase:

[https://jujucharms.com/support/create][jaas-support]


<!-- LINKS -->

[juju-experts]: https://jujucharms.com/experts
[ubuntu-advantage-servers]: https://www.ubuntu.com/support/plans-and-pricing#server
[models]: ./models.md
[ubuntu-sso]: https://login.ubuntu.com/+login
[launchpad]: https://launchpad.net/+login
[jaas-support]: https://jujucharms.com/support/create
