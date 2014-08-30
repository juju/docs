# Charm Review Process

Reviewing a Juju Charm is a process that can easily be broken down into 
the following parts:

1. Setting up a branch of the charm
2. Charm Information Review
3. Charm Deployment, Configuration and Testing
4. Gathering / Submitting Your Results

## Setting up a branch of the charm
Lets get started with setting up a branch of the charm. The process below 
highlights how you would branch a charm that is for Ubuntu 12.04 (precise), 
but branching process is essentially the same for other "series" such as 
Ubuntu 14.04 "trusty".

    mkdir /tmp/precise
    cd /tmp/precise

Above we created a temporary precise directory. If you are reviewing a 
charm for Ubuntu 14.04 trusty, you'd replace "precise" with "trusty".

If the charm is already available in the Juju Charm Store, do the following 
command to get the charm:

    charm get charm-name

If the charm is not already available in the Juju Charm Store, do the 
following command to get the charm:

    bzr branch lp:~the-username/charms/precise/charm-name/trunk charm-name

Like when creating the temporary directory, the "precise" part can be 
placed with the series relating to the charm that is being reviewed.

    cd charm-name

For existing charms don't forget to branch in the merge proposal after 
changing directory.

    bzr merge lp:~the-username/charms/precise/charm-name/trunk

## Charm Information Review

### Charm Proofing

Now that we have set up / branched the charm and are in the charm's directory, 
we need to run the following command:

    charm proof

Essentially, this command is meant to validate if it conforms to what the 
Charm Store thinks a charm structure and layout should be and will output 
particular information with a level of severity. You can learn more about
the proof tool by clicking [here](tools-charms-tools.html#proof).

In essense, you should make note of output for the end of the charm review 
process. If you come across errors (output starting with ```E```), these 
are typically major issues and will result in a broken charm. Ideally, you 
should determine whether this charm is likely to be deployable. If so, 
continue on with the review.

### Reading The README

Understanding the purpose of the charm is crucial for both those that are 
reviewing as well as those that may want to deploy the charm. We recommend 
the charm's README have the following information:

1. What is the service?
2. What configuration options does it provide
3. What files does it retrieve from the Internet
4. Instructions on how to deploy the service.
5. How the charm should be used in relation to configuration options 
and relations.
6. Caveats
7. Support

Make note of sections of the README that need improvement or are missing.

### A Charming Configuration

Take a look at the charm's config.yaml file, using the [Charm Configuration](authors-charm-config.html) 
document for reference. We also recommend you cross-reference it with the 
README to make sure the options in the README are defined in the config.yaml 
and vise-versa.

### A look into metadata

Take a look at the charm's metadata.yaml file and use the [Charm metadata](authors-charm-metadata.html) 
document as reference.

## Charm Deployment, Configuration, and Testing

If a charm has tests (you can determine if it does by checking for a "tests" 
folder), run the command below and verify the charm that way:

    juju test -v --set-e

If a charm does not have tests, you will need to manually deploy it.

### Deployment

We are going to cover some basics to deploying the charm you are reviewing. 
For a more in-depth look at deploying charms, go to the [Charms Deploying](charms-deploying.html) page.

While using the README as a reference, deploy the charm using the command 
below on your local environment.

    juju deploy --repository=../../ local:precise/charm-name

Alternatively, you can set JUJU_REPOSITORY and deploy like the following:

    export JUJU_REPOSITORY=/tmp
    juju deploy local:precise/charm-name

!!! Note: Remember to swap out precise for the series the charm is being
tested for, like "trusty".

If the local deployment is successful, continue on to the configuration 
section.

!!! Note: If you have access to other cloud environments (like EC2), we 
appreciate testing the deployment on those environments as well.

### Configuration and Relations

Reference the config.yaml as well as the README to determine what configuration 
options are available for the charm. Test out changing the charm configuration 
by doing something like the following:

    juju set charm-name key=value

If the configuration of the charm successfully changes and the charm's README 
makes note of possible relations with other charms, test adding and removing 
the relations, making sure the departed and broken hooks are fired correctly.

    juju add-relation charm-name other-charm-name
    juju remove-relation charm-name other-charm-name

### Verifying

Lets quickly verify that the charm is correctly running by using SSH to 
jump into the machine the charm is running on.

    juju ssh charm-name/0

Use ```top``` or ```ps``` to show if the charm's process is running. Some 
services status would also be available with ```sudo service name status``` 
(example: ```sudo service apache2 status```).

!!! Note: If the charm itself is not a process, but relies on something like 
nginx or apache2, be sure to check those services are running. A good example 
of this would be Wordpress needing apache2 or nginx).

If the charm's configuration options are written to the service's configuration 
files, check that file for the values you set earlier. Check the hooks to see 
which ones are written to configuration files (if applicable at all).

## Gathering / Submitting Your Results

Gather the information that you have obtained from the charm review, such as 
whether the charm proof passes or has issues, if the README is understandable 
and thorough, if it successfully deploys, configuration and relations work, etc.

Post that information to the bug report or merge request, starting off with a "Thanks" 
no matter the outcome of the review. If you are a community member and/or contributor, 
you can leave your general approval or disapproval based on your findings. Normally 
people use "+1 LGTM" to indicate approval. Of course, in moments of disapproval, we 
suggest posting information as to why you disapprove.

### Part of the ~charmers group, hold up!

If you are part of the ~charmers team, follow up the review process with information 
found [here](reference-reviewers.html).

### Not part of the ~charmers group?

First off, thank you for your review of the charm. Your review helps improve the Juju 
community as a whole and we appreciate your time and effort. If you've found that you 
are ready to be part of the ~charmers group and want the responsibilities of a member 
of the ~charmers team, we recommend you seek out how to apply for membership to the 
team via #juju on IRC (Freenode) and on the Juju [mailing list](https://lists.ubuntu.com/mailman/listinfo/juju).
