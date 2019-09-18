**Usage:** `juju budget [options] [<wallet>:]<limit>`

**Summary:**

Update a budget.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--model-uuid (= "")`

Model uuid to set budget for.

**Details:**

Updates an existing budget for a model.

**Examples:**

Sets the budget for the current model to 10.

   `juju budget 10`

Moves the budget for the current model to wallet 'personal' and sets the limit to 10.

   `juju budget personal:10`
