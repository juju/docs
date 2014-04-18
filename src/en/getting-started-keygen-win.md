# Creating SSH Keypairs on Windows

This walkthrough will show you how to create SSH keys for use with Juju on the
Windows OS.

## Create the .ssh folder

First you need to create a folder called .ssh in your Home directory, which is
where ssh keys will be kept.

One way to do this is to open the Start Menu and type "cmd" (without quotes) in
the search box at the bottom of the Start Menu. Click on cmd.exe when it comes
up in the search results. This will open up a Windows command prompt.

Type the following in the command prompt:

    mkdir .ssh

This will create a folder called .ssh in your home directory.

## Download puttygen.exe

Download puttygen.exe from the [PuTTY download
page](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)

The file you download is not an installer, but a simple executable you can run
directly.

Once downloaded, run puttygen.exe, you should see a dialog that looks like this:

![](media/puttygen.png)

## Generating your keys

The defaults for the parameters at the bottom of the window are correct (SSH-2
RSA and 2048 bits). Click generate, and move your mouse back and forth over the
window to generate your key.

It is recommended that you specify a passphrase (password) for your key, so
that if it is lost, it can't be used without the password. Choose a password you
can remember, because it cannot be recovered if forgotten.

## Save your keys

Click Conversions->Export OpenSSH Key on the main menu. Find the .ssh folder
you created earlier and save the key in that folder with the name id_rsa (no
extension). This is where Juju and some other programs will look for it by
default.

Next, you need to save your public key. To do this, right click in the box under
"Public key for pasting into OpenSSH authorized_keys file", and click "Select All".
Copy the text using Ctrl-C or right-click Copy.

Open Notepad and paste the contents of the clipboard. Save the file with the
name id_rsa.pub in the same directory where you saved the private key (note,
the extension should be .pub, not .txt).

That's it! You now have ssh keys that can be used with Juju and other
applications that require ssh keys.
