Title: Managed solutions under SLA

# Managed solutions under SLA

[Juju experts](https://jujucharms.com/experts) may designate a Juju
model as a managed, supported solution by setting an SLA.

There are three support levels that may be set on a model:

- Essential
- Standard
- Advanced

Our Juju expert partners support the managed solution itself, including its
workloads and operation. Support for Juju and Ubuntu is provided by
Canonical. See [Ubuntu Advantage for Servers](https://www.ubuntu.com/support/plans-and-pricing#server)
for more information on Canonical support levels.

Juju experts will provide details on the solution-specific support provided
under each SLA, with budget estimates.

## Setting an SLA on a model

An SLA is set on a model with a monthly budget limit. Support costs will not be
billed for more than this amount. If metered costs exceed this amount, the
budget limit will need to be increased in order to continue to access support.

Set an Essential SLA on the current model _marketdata_, with a monthly budget
limit of $100 USD:

```bash
juju sla essential --budget 100
```

```
Model                           SLA                                                        Message
jaas:bob/marketdata             essential       the new sla will become effective on 2018-10-31   
                                                16:24:53.80664498 +0000 UTC                       
```

An SLA may be increased (from _essential_ to _standard_, or _standard_ to
_advanced_) effective immediately. Lowering the SLA becomes effective in the
next monthly billing cycle.

The SLA for a model is shown at the top of Juju status.

```bash
juju status
```

```
Model       Controller     Cloud/Region         Version      SLA        Timestamp
marketdata  jaas           azure/westeurope     2.4.3        essential  11:21:41-05:00
...
```

# Budgeting managed models

SLA budgets are organized into wallets. The sum of all budgets in a wallet
cannot exceed the wallet limit.

## Managing wallets

List your wallets with:

```bash
juju wallets
```

```
Wallet          Monthly Budgeted        Available       Spent
primary*           1000      100          1000.00        0.00
Total              1000      100          1000.00        0.00
                                                             
Credit limit:     10000                                      
```

The default wallet is shown with an asterisk "\*". SLA budgets are allocated
from this wallet if the wallet name is not specified.

The credit limit is the maximum monthly limit approved to spend on SLAs. If you
need to increase this limit, you may [contact JAAS support](https://jujucharms.com/support/create)
to raise it.

View the budgets allocated from a wallet:

```bash
juju show-wallet primary
```

```
Model                           Spent   Budgeted                      By        Usage
jaas:bob/marketing-campaign     0.00         100                     bob        0%   
                                                                        
Total                           0.00         100                                0%   
Wallet                                      1000                        
Unallocated                                  900                        
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
