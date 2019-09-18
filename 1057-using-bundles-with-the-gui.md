<!--
Todo:
- Critical: review required
-->
<h2 id="heading--adding-bundles-with-the-gui">Adding bundles with the GUI</h2>

Bundles are easy to use and deploy within the Juju GUI, and the process of adding them from the Charm Store is almost identical to the way you add charms.

From the GUI, open the Store and select the bundle you're interested in. A new pane will display a preview of what the GUI's visual overview will look like with the bundle installed, showing applications and connections. Further details, such as how a bundle supports scaling, can be found below the preview.

Click 'Add to model-name', where *model-name* is your currently selected model. This will simply add the bundle to your currently selected model.

Before clicking on 'Commit changes' to activate your new bundle, review the configuration of each application by selecting them and making any necessary changes. Click on 'Commit changes' to review the deployment summary followed by 'Deploy' to set those changes in motion. Alternatively, select each application and click 'Destroy' to remove them from bundle prior to activation.

<h3 id="heading--exporting-and-importing-bundles-with-the-gui">Exporting and Importing bundles with the GUI</h3>

From the GUI, you can easily export and re-import the current model as a local bundle, encapsulating your applications and connections into a single file. To do this, click on the 'Export' button alongside your username and model name, or use the keyboard shortcut “shift-d”. This results in the creation of a file called `<model-name>-<year>-<month>-<date>.yaml` that your browser will Typically prompt you to save or open.

![Export button in the Juju GU](https://assets.ubuntu.com/v1/9c633b2b-juju2_gui_bundles_export.png)

You can import a saved bundle by either dragging the exported YAML file onto your browser canvas, or using the 'Import' button. After clicking 'Import' your browser will prompt you to select a bundle file.

After a file has been added, the GUI will briefly report `ChangeSet process started` followed by `ChangeSet import complete`. As with adding bundles from the store, you may want to review the applications, connections and various configuration options before clicking on 'Commit changes' and 'Deploy' to activate your bundle.

<h3 id="heading--local-deploy-via-command-line">Local deploy via command line</h3>

After exporting a bundle from the GUI, you can also deploy the saved bundle from the command line:

``` text
juju deploy bundle.yaml
```

Unlike when you import and deploy a bundle with the Juju GUI, running `juju deploy` on the command line will not attempt to rename a new application if an application with the same name already exists.

From the command line, you can also check for errors in a bundle before deploying it. Bundles downloaded from the Juju store need to be unzipped into their own directory, and your own YAML files will need to be accompanied by a `README.md` text file (although this file can be empty for testing purposes). You can then check for possible errors with the following command:

``` text
charm proof directory-of-bundle/
```

Note that if no directory is given, the command defaults to the current directory.

If no errors are detected, there will be no output from `charm proof` and you can safely deploy your bundle.
