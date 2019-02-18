Title: Multi-user external setup - tutorial

# Multi-user external setup - tutorial

*This is a tutorial in connection with the multi-user framework of Juju. See
both [Working with multiple users][multiuser] and
[External users][users-external-users] for background information.*

This short tutorial will show how to configure a controller to accept user
connections based on authentication performed by a remote online service.

The following topics will be covered:

 - Controller creation
 - Login controller access
 - External user login

## Controller creation

We'll begin by adding credentials and then creating an AWS-based controller: 

```bash
juju add-credential aws -f credentials.yaml
juju bootstrap --config identity-url=https://api.jujucharms.com/identity --config allow-model-access=true aws aws-sso
```

In the above the credentials file contains a single credential for the 'aws'
cloud, allowing it to become the default credential in the subsequent
`bootstrap` command.

The key 'identity-url' gives the remote authentication service and the key
'allow-model-access' bypasses a local user check when a model connection is
attempted by a user.

## Login controller access

An external user is **not** granted controller access of 'login' out of the
box. It needs to be done manually.

Assuming a username of 'javierlarin72', the syntax to use is the following:

```bash
juju grant javierlarin72@external login
```

Note the special use of the qualifier '@external'.

## External user login

To have the external user log in to controller 'aws-sso', the following is
done, presumably on a separate client system:

```bash
juju login -u javierlarin72@external -c aws-sso 
```

You should be provided with a URL that will lead you to the identity service.
This will allow you to authenticate the user.

Sample output:

```no-highlight
Opening an authorization web page in your browser.
If it does not open, please open this URL:
https://api.jujucharms.com/identity/v1/login?waitid=d5ef4c371a6f517984dc5f2d2f7507a2
Couldn't find a suitable web browser!
Set the BROWSER environment variable to your desired browser.
welcome, javierlarin72@external. You are now logged into "aws-sso".
```

All done!


<!-- LINKS -->

[multiuser]: ./multiuser.md
[users-external-users]: ./users.md#external-users
