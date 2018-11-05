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

An SLA is set on a per-model basis, and specifies two key parameters:

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
.
```

## Changing an SLA

An SLA is increased when it moves "up" levels: 'essential' to 'standard' to
'advanced'. An SLA is decreased when it moves "down" levels: 'advanced' to
'standard' to 'essential'.

When an SLA is **increased** the resulting support level becomes effective
immediately. When an SLA is **decreased** the resulting support level becomes
effective in the next monthly billing cycle.

## Budgeting managed models

SLA budgets are organized into wallets. The sum of all budgets in a wallet
cannot exceed the wallet limit.

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

The credit limit is the maximum monthly limit approved to spend on SLAs. You
can submit a request to have this limit increased using this link:

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

You may increase the budget limit for a model:

```bash
juju budget -m demo-izae7oj5:admin/doctest-03 250
```

```
budget limit updated to 250
```

```bash
juju show-wallet personal
```

```
Model                           Spent   Budgeted                      By        Usage
jaas:bob/marketing-campaign     0.00         250                     bob        0%   
                                                                        
Total                           0.00         250                                0%   
Wallet                                      1000                        
Unallocated                                  750                        
```

The budget limit may be lowered, but not below the current spend.

## Advanced budgeting

You may create additional wallets for accounting or organizational purposes.

```bash
juju create-wallet demo-poc 200
wallet created
```

```bash
juju wallets
Wallet          Monthly Budgeted        Available       Spent
demo-poc            200        0           200.00        0.00
personal*          1000      100          1000.00        0.00
Total              1200      100          1200.00        0.00
                                                             
Credit limit:     10000                                      
```

To allocate a budget from a specific wallet, use _wallet_:_limit_ when setting
the budget on an SLA.

```bash
juju sla essential demo-poc:50
```


<!-- LINKS -->

[juju-experts]: https://jujucharms.com/experts
[ubuntu-advantage-servers]: https://www.ubuntu.com/support/plans-and-pricing#server
[models]: ./models.md
[ubuntu-sso]: https://login.ubuntu.com/+login
[launchpad]: https://launchpad.net/+login
[jaas-support]: https://jujucharms.com/support/create
