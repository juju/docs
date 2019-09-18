<!--
Todo:
- Investigate: shouldn't `model-config` have a default-credential setting?
- Add to mycreds.yaml: cloudsigma, rackspace, and oracle. also openstack using access-key
- Investigate: can private keys always be replaced by a file path?
- Add remote LXD certs/key (server cert, client cert, client key)
-->

In order to access your cloud, Juju needs to know how to authenticate itself. We use the term *credential* to collectively describe the material necessary to do this (e.g. username & password, or just a secret key). During the addition of a credential the user assigns to it an arbitrary name.

When credentials are added for a given cloud they become available for use on that cloud's controller and models. There are therefore two categories of credentials: those that are available to the Juju client (local) and those that are active and have been uploaded to a controller (remote).

A credential becomes active when it is related to a model for the first time. The two commands that can do this are `bootstrap` and `add-model` as both commands involve the creation of at least one model.

An active credential is always associated with one cloud, one Juju user, and one, or more, models. A model, however, is always related to a single credential.

<h2 id="heading--adding-credentials">Adding credentials</h2>

Juju supports three methods for adding credentials:

- accepting credentials provided interactively by the user on the command line
- scanning for existing credentials via environment variables and/or "rc" files (only supported by certain providers)
- reading a user-provided [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) file

[note]
A local LXD cloud is a special case. When accessed from a Juju admin user a credential does not need to be added; a 10-yr certificate is set up for you. However, when accessed from a non-admin user this is not the case. See [Additional LXD resources](/t/additional-lxd-resources/1092#heading--non-admin-user-credentials) for details.
[/note]

Added credentials get saved to file `~/.local/share/juju/credentials.yaml`.

<h3 id="heading--adding-credentials-interactively">Adding credentials interactively</h3>

To add credentials interactively use the `add-credential` command. To do so with the AWS cloud:

``` text
juju add-credential aws
```

You will be asked for information based on the chosen cloud. For the AWS cloud the resulting interactive session looks like:

``` text
Enter credential name: carol

Using auth-type "access-key".

Enter access-key: AKBAICUYUPFXID2GHC5S

Enter secret-key: *********************** (does not echo back)

Credential "carol" added locally for cloud "aws".
```

If you end up adding multiple credentials for the same cloud you will need to set one as the default. See below section [Setting default credentials](#heading--setting-default-credentials).

<h3 id="heading--adding-credentials-from-environment-variables">Adding credentials from environment variables</h3>

Certain cloud providers offer command line tools that rely on environment variables to store credentials. Juju supports the scanning of such variables as a way to add them to itself. Scanning is done with the `autoload-credentials` command:

``` text
juju autoload-credentials
```

Any variables detected will cause a prompt to appear. You will be asked to confirm the addition of their respective values as well as to provide a name to call the credential set.

[note]
You will need to rescan the variables if their values ever change. A scan only picks up *current* values.
[/note]

There are three providers that use tools that support this method: [Amazon AWS](/t/using-amazon-aws-with-juju/1084#heading--using-environment-variables), [Google GCE](/t/using-google-gce-with-juju/1088#heading--using-environment-variables), and [OpenStack](/t/using-openstack-with-juju/1097#heading--using-environment-variables).

The `autoload-credentials` command is also used to generate a certificate credential for localhost clouds. This is needed for providing access to non-admin Juju users. See [Additional LXD resources](/t/additional-lxd-resources/1092#heading--non-admin-user-credentials).

<h3 id="heading--adding-credentials-from-a-file">Adding credentials from a file</h3>

You can use a YAML-formatted file to store credentials for any cloud. Below we provide a sample file, which we will call `mycreds.yaml`. It includes many of the clouds supported by Juju. Note the MAAS cloud and the two OpenStack clouds, called 'homemaas', 'myopenstack' and 'homestack' respectively.

``` yaml
credentials:
  aws:
    peter:
      auth-type: access-key
      access-key: AKIAIH7SUFMBP455BSQ
      secret-key: HEg5Y1DuGabiLt72LyCLkKnOw+NZkgszh3qIZbWv
    jlaurin:
      auth-type: access-key
      access-key: AKIAIFII8EH5BOCYSJMA
      secret-key: WXg6S5Y1DvwuGt72LwzLKnItt+GRwlkn668sXHqq
  homemaas:
    peter:
      auth-type: oauth1
      maas-oauth: 5weWAsjhe9lnaLKHERNSlke320ah9naldIHnrelks
  myopenstack:
    john:
      auth-type: access-key
      access-key: bae7651caeab41ed876cfdb342bae23e
      secret-key: 7172bc91a21c3df1787423ac12093bcc
      tenant-name: admin
      username: admin   
  homestack:
    peter:
      auth-type: userpass
      password: UberPassK3yz
      tenant-name: appserver
      username: peter
  google:
    peter:
      auth-type: jsonfile
      file: ~/.config/gcloud/application_default_credentials.json
    juju-gce-1-sa:
      auth-type: oauth2
      project-id: juju-gce-1
      private-key: |
        -----BEGIN PRIVATE KEY-----
        MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCzTFMj0/GvhrcZ
        3B2584ZdDdsnVuHb7OYo8eqXVLYzXEkby0TMu2gM81LdGp6AeeB3nu5zwAf71YyP
        erF4s0falNPIyRjDGYV1wWR+mRTbVjYUd/Vuy+KyP0u8UwkktwkP4OFR270/HFOl
        Kc0rzflag8zdKzRhi7U1dlgkchbkrio148vdaoZZo67nxFVF2IY52I2qGW8VFdid
        z+B9pTu2ZQKVeEpTVe5XEs3y2Y4zt2DCNu3rJi95AY4VDgVJ5f1rnWf7BwZPeuvp
        0mXLKzcvD31wEcdE6oAaGu0x0UzKvEB1mR1pPwP6qMHdiJXzkiM9DYylrMzuGL/h
        VAYjhFQnAgMBAAECggEADTkKkJ10bEt1FjuJ5BYCyYelRLUMALO4RzpZrXUArHz/
        CN7oYTWykL68VIE+dNJU+Yo6ot99anC8GWclAdyTs5nYnJNbRItafYd+3JwRhU0W
        vYYZqMtXs2mNMYOC+YNkibIKxYZJ4joGksTboRvJne4TN7Et/1uirr+GtLPn+W/e
        umXfkpbOTDDAED8ceKKApAn6kLIW98DwHyK0rUzorOgp4DFDX9CjuWC+RG3CFGsk
        oVOcDuTevJlb9Rowj1S2qYhGjuQVpVD7bcRg5zaSJKS88YbK63DCHZFpXn9JR0Fg
        Vou9dnc99FdMo5vtHg7Adxh91gdqEvoaF1lHx8Var0q32QDse+spvv7K6/+7G35k
        3+1gDgF74/uMr/AVrjpoUjmGAuWweXY/vn1MVN2Uld4KPYafkOF8oTuDK5f1fu0d
        cMEoKRSXQh1NCD3PZWfQt4ypYPzn9R+VBGwnBcPorytlhM9qdLxKKlaHjBlprS6Y
        Be1z6FO+MqWhFlwPrKH/2uwd4QKBgQDCGESJur9OdEeroBQyYyJF7DnJ/+wHSiOr
        qzvb9YW1Ddtg1iiKHHZO5FS59/D62kPaGsysCMKxI9FW53TzSxUiTaEG636C5v8J
        eRdzxX04BNYNzqXbm1agBEjAa7tK8xJAjk0to4zqadUaYZog0uQs2X7Aexj2c9T/
        HQVLILHjBwKBgD/yuoLNbST+cGbuZl1s2EnTP796xPkkUm3qcUzofzmn6uivz7Qp
        FMThZhHZ/Der98tra91a4e8fHaUTL5d4eCMeCL1mWXoNMnm02D/ugpEC8yDefi3T
        xlM/Ed0IEVogcd49tvTvQfrhfbW/6Que/rkLKCoUlAldfIOYkS4YyyTBAoGACCpH
        L9gYVi+UGEc6skfzWCew4quOfVwEFiO09/LjNhOoJ/G6cNzzqSv32H7yt0rZUeKQ
        u6f+sL8F/nbsN5PwBqpnXMgpYU5gakCa2Pb05pdlfd00owFs6nxjpxyhG20QVoDm
        BEZ+FhpvqZVzi2/zw2M+7s/+49dJnZXV9Cwi758CgYAquNdD4RXU96Y2OjTlOSvM
        THR/zY6IPeO+kCwmBLiQC3cv59gaeOp1a93Mnapet7a2/WZPL2Al7zwnvZYsHc4z
        nu1acd6D7H/9bb1YPHMNWITfCSNXerJ2idI689ShYjR2sTcDgiOQCzx+dwL9agaC
        WKjypRHpiAMFbFqPT6W2uA==
        -----END PRIVATE KEY-----
      client-id: "206517233375074786882"
      client-email: juju-gce-sa@juju-gce-123.iam.gserviceaccount.com
  azure:
    peter:
      auth-type: service-principal-secret
      application-id: c07fd75f-dc07-47a1-87ed-123456731897
      subscription-id: bef58c0a-6fca-489d-8297-12345677f276
      application-password: 76ab0f15-4d2e-4dd8-abca-1234567325d5
  oracle:
    jlarin:
      auth-type: httpsig
      fingerprint: a3:57:81:9c:d2:d5:af:31:3b:73:1e:2b:a4:ae:96:ee
      key: |
        -----BEGIN RSA PRIVATE KEY-----
        Proc-Type: 4,ENCRYPTED
        DEK-Info: AES-128-CBC,AAAC919B21A2694027DBEB182593FBEC

        MIIEogIBAAKCAQEAoc9jtcvo49FWe3sOhS6c1ExkllNZ61vChsLmMhBCI1vMc8wu
        cMpNmYK1ZA+d2Mm5YWDwn4UrSTzyaFdAIesmRljfbYMGTLznI/nfQMa1hkmplF5Q
        xNPCdzs0afqfnubIyrvCKYfAsRzjCcs7C30n6PzG5WrKxzr1QNvAuvYgjd2oQuSY
        nAhDgdJDkA9UwJFgI1jE8EuoxjkvmyeL76ohe78IEjMzoBBvll/Vd3d8X/hCHt4b
        wkmn3B5+QzXIvYXGhaUoZrmG6V+tsk2H5voJj6TswDB8rqIa1SHbY81wIkMUxbD4
        ScAq8eq2/6ETXcoBULKCjmvyqekJHjT7NngbpwIDAQABAoIBAEEggheIDSK0/UQS
        EZQVYNYqMUo4HjcW5cL/PRvlY1lr92ycQAzxwC4LaArwJi49czn4lKEALp35w++v
        PoboaK1j0/n2BLEaT0YxqmQeFq4INBMdqxCt0tW+pKgLUffZF/RRgiLJGwuufstQ
        W2GSbF/gbgWk6B0sY85JJNebfRrb+qjp5Jz+5t5gNVzOwWWkPYoAKXPd9JHYPFAk
        JCUTloYdf16lBml+nZI7EGojXtHUpdF7KyYRVfXMfxBnaWpVHvoZBk5Vk5qL/boz
        N8W+YahFq9BELavYQ30CZQeWYoD2MaSCWv+WzfkER8YK5Onr+5CSU0lW9dqN6wuv
        LFozUgECgYEAy9vZb+hjn3otkEFvyCGg9wmGIs9Qro3UKJI/mGKQeL7K8sd5WsA6
        mbOkIDbK71ZG+iIfxDXLzRO1ZzPjAX3cReFZ9NFRHngX9xM92UP+icIJkM6m4ImN
        UcaGCZiF0LoKUTAkEw+5rpeudGcgNgaI41RKMUBLyQn5MFo3IAPaO4ECgYEAyzJN
        CqB4e+qJgmc29zKsSfvuofasDTmIMnOZW2ci+tiD/qiH/eJoKHK2F5yGV6/tB2iY
        kFSuzWEwu/Crl7seW6xPY+HYlGLD60ix1aRDEfR48bZqFqlIu7uowI9dp43aOmPU
        1YSgMj8UA+rVqHqrS6IX4iqGbEOuzq0a377qiycCgYA99oUQzsH5J1nSDxG68v3K
        GMr8qacMZ2+lJU7PMqZXDScCxD7Opr8pGME6SW1FciQAw36EVRWtL+BjjhBcw7TA
        SM7e6wCNElO4ddLGxzQHC0N9EFMIzMZ3pK/5arMRznp0Uv2kDZOSzefo2a+gvDu/
        XU9vyOtAIBft6n327TTYAQKBgEE3/OhbRzCmv8oeLNM87XW1qgtMLD72Z1OiLOfc
        e6q90efr2fJQOBQ7dVywvaHpco+9L7Krq4vWlXjdL4ZCCJVuAfFSLPy7kpyzMXkc
        Bvb9W9BiNz3cyd6PxdDTQFhNwbXdE2QQ9IYMHvV+62LvNInLFhVehtS7CKGHiCem
        lItJAoGAdnj8nJRFQCAyIGcYk6bloohXI8ko0KLYbHfQpN9oiZa+5crEMzcFiJnR
        X8rWVPCLZK5gJ56CnP8Iyoqah/hpxTUZoSaJnBb/xa7PCiMq1gBfSF8OYlCsRI0V
        semYTOymUHkZyWGMIhmdn6t1S9sOy2tYjiH6HqumwirxnD5CLDk=
        -----END RSA PRIVATE KEY-----
      pass-phrase: "ChimayBlue"
      tenancy: ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia
      user: ocid1.user.oc1..aaaaaaaaizcm5ljvk624qa4ue1i8vx043brrs27656sztwqy5twrplckzghq
  joyent:
    peter:
      auth-type: userpass
      sdc-user: admingal
      sdc-key-id: 2048 00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff
      private-key: key (or private-key-path, like `~/.ssh/id_rsa.pub`)
      algorithm: "rsa-sha256"
  vsphere:
    ashley:
      auth-type: userpass
      password: passw0rd
      user: administrator@xyz.com
  lxd-node2:
    interactive:
      auth-type: interactive
      trust-password: ubuntu
```

Credentials are added to Juju on a per-cloud basis. To add credentials for the defined 'azure' cloud, for instance, we would do this:

``` text
juju add-credential azure -f mycreds.yaml
```

[note]
All available authentication types are outlined in section [Adding clouds manually](/t/clouds/1100#heading--adding-clouds-manually) on the Clouds page.
[/note]

<h2 id="heading--managing-credentials">Managing credentials</h2>

The following credential management tasks are covered:

-   [Setting default credentials](#heading--setting-default-credentials)
-   [Listing local credentials](#listing-local-credentials%5D)
-   [Listing remote credentials](#heading--listing-remote-credentials)
-   [Updating local credentials](#heading--updating-local-credentials)
-   [Updating remote credentials](#heading--updating-remote-credentials)
-   [Removing local credentials](#heading--removing-local-credentials)
-   [Relating a remote credential to a model](#heading--relating-a-remote-credential-to-a-model)

<h3 id="heading--setting-default-credentials">Setting default credentials</h3>

To set the default credential for a cloud:

``` text
juju set-default-credential aws carol
```

If only one credential exists for a cloud, it becomes the effective default credential for that cloud.

Setting a default affects operations that require a new credential to be used by Juju. These are the creation of a controller (`bootstrap`) and the addition of a model (`add-model`). It does not change what is currently in use (on a controller).

A default must be defined if multiple credentials exist for a given cloud. With both the above commands a credential can be specified with the `--credential` option. Failure to do so will cause an error to be emitted:

``` text
ERROR more than one credential is available
specify a credential using the --credential argument
```

<h3 id="heading--listing-local-credentials">Listing local credentials</h3>

You can display what credentials are available by running the `credentials` command:

``` text
juju credentials
```

Sample output:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju credentials -->
``` text
Cloud   Credentials
aws     bob*, carol
google  wayne
```

An asterisk denotes a default credential. In the above output, credential 'bob' is the default for cloud 'aws' and no default has been specified for cloud 'google'. Default credentials are covered in more depth later on.

To reveal actual authentication material (e.g. passwords, keys):

``` text
juju credentials --format yaml --show-secrets
```

Sample output:

``` text
local-credentials:
  aws:
    bob:
      auth-type: access-key
      access-key: AKIAXZUYGB6UED2GNC5A
      secret-key: StB2bmL1+tX+VX7neVgy/3JosJAwOcBIO53nyCVp
```

Notice how the output says 'local-credentials', meaning they are stored on the local Juju client.

<h3 id="heading--listing-remote-credentials">Listing remote credentials</h3>

To see what credential is in use by a model (here the 'default' model) the `show-model` command can be used:

``` text
juju show-model default
```

Partial output:

``` text
default:
  name: admin/default
  ...
  ...
  credential:
    name: bob
    owner: admin
    cloud: aws
```

The `models --format yaml` command also shows this information, albeit for all models.

The above commands do not display authentication material. Use the `show-credentials` command to view the active credentials, including the cloud name, credential names, and model names:

``` text
juju show-credentials --show-secrets
```

Sample output:

``` text
controller-credentials:
  aws:
    bob:
      content:
        auth-type: access-key
        access-key: AKIAXZUYGB6UED2GNC5A
        secret-key: StB2bmL1+tX+VX7neVgy/3JosJAwOcBIO53nyCVp
      models:
        controller: admin
        default: admin
```

Notice how the output says 'controller-credentials', meaning they are stored on the controller.

The `show-credentials` command queries the controller to get its information.

<h3 id="heading--updating-local-credentials">Updating local credentials</h3>

To update an existing credential locally use the `add-credential` command with the `--replace` option.

Here we decided to use the file 'mycreds.yaml' from a previous example:

``` text
juju add-credential --replace aws -f mycreds.yaml
```

Any existing credential will be overwritten by an identically named credential in the file. As a safeguard to inadvertently overwriting credentials, an error will be emitted if the `--replace` option is not used:

``` text
ERROR local credentials for cloud "aws" already exist; use --replace to overwrite / merge
```

Updating credentials in this way does not update credentials currently in use (on an existing controller/cloud). See the next section for that.

<h3 id="heading--updating-remote-credentials">Updating remote credentials</h3>

To update credentials currently in use (i.e. stored on a controller) the `update-credential` command is used. It does this by uploading an identically named local credential.

Before an update occurs, Juju ensures that the new credential contents can authenticate with the backing cloud and that any machines that may reside within a model currently related to the credential remain accessible.

The requirements for using this command, as compared to the initial `bootstrap` (or `juju add-model`) command, are:

-   same cloud name
-   same Juju username (logged in)
-   same credential name

The update is a two-step process. First change the credentials locally as shown previously and then upload those credentials to the controller.

Below, we explicitly log in with the correct Juju username ('admin'), change the contents of the credential called 'joe' (included in file `mycreds.yaml`), and then update that credential for cloud 'google':

``` text
juju login -u admin
juju add-credential --replace google -f mycreds.yaml
juju update-credential google joe
```

The `update-credential` command is the only command that can alter a credential cached on a controller.

<h4 id="heading--updating-remote-credentials-using-a-different-juju-user">Updating remote credentials using a different Juju user</h4>

If you are unable to ascertain the original Juju username then you will need to use a different one. This implies adding a new credential name, copying over any authentication material into the old credential name, and finally updating the credentials. Below we demonstrate this for the Azure cloud:

Add a new temporary credential name (like 'new-credential-name') and gather all credential sets (new and old):

``` text
juju add-credential azure
juju credentials azure --format yaml --show-secrets > azure-creds.yaml
```

Copy the values of `application-id` and `application-password` from the new set to the old set.

Then replace the local credentials and upload them to the controller:

``` text
juju add-credential azure -f azure-creds.yaml --replace
juju update-credential azure old-credential-name
```

To be clear, the file `azure-creds.yaml` (used with `add-credential`) should look similar to:

``` text
Credentials:
  azure:
    new-credential-name:
      auth-type: service-principal-secret
      application-id: foo1
      application-password: foo2
      subscription-id: bar
    old-credential-name:
      auth-type: service-principal-secret
      application-id: foo1
      application-password: foo2
      subscription-id: bar
```

<h3 id="heading--removing-local-credentials">Removing local credentials</h3>

The `remove-credential` command is used to remove a local credential (i.e. not cached on a controller):

``` text
juju remove-credential aws bob
```

<h3 id="heading--relating-a-remote-credential-to-a-model">Relating a remote credential to a model</h3>

To relate a remote credential to a model the `set-credential` command (`v.2.5.0`) is available to the controller admin or the model owner. For instance, to have remote credential 'bob' be used for model 'trinity' (for cloud 'aws'):

``` text
juju set-credential -m trinity aws bob
```

This command does not affect how the credential may relate to another model. If the credential is already related to a single model this operation will result in that credential being related to two models.

[note]
If the stated credential does not exist remotely but it does locally then the local credential will be uploaded to the controller. The command will error out if the credential is neither remote nor local.
[/note]

<h2 id="heading--next-steps">Next steps</h2>

Consider tutorial [Managing credentials](/t/tutorial-managing-credentials/1289). It offers hints and reinforcements to certain credential concepts. It also goes over some practical scenarios.
