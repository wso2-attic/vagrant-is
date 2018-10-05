# Vagrantfile for WSO2 Identity Server

In order to use Vagrant boxes, you will need an active subscription from WSO2 since the Vagrant boxes hosted at vagrant.wso2.com contains the latest updates and fixes to WSO2 Identity Server. You can sign up for a Free Trial Subscription [here](https://wso2.com/free-trial-subscription).

If you wish to use the Vagrant boxes without updates, please build them from [here](https://github.com/wso2/vagrant-boxes).

This section defines the procedure to execute Vagrant resources for a setup of WSO2 Identity Server single
node with Analytics support.<br>

Please note that in order to run these Vagrant resources use, you need to install
[Oracle VM VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html)
since, Vagrant uses Oracle VM VirtualBox as the default provider. In addition, you need to download the official JDBC driver
for MySQL, [Connector/J](https://dev.mysql.com/downloads/connector/j/5.1.html).

## How to run the Vagrantfile

1. Checkout this repository into your local machine using the following Git command.

```
git clone https://github.com/wso2/vagrant-is.git
```
>If you are to try out an already released zip of this repo, please ignore this 1st step.

2. Move to `vagrant-is` folder.

```
cd vagrant-is
```
>If you are to try out an already released zip of this repo, please ignore this 2nd step also. Instead, extract the zip file and directly browse to `vagrant-is-<released-version>` folder.

>If you are to try out an already released tag, after executing 2nd step, checkout the relevant tag, i.e. for example: <br> git checkout tags/v5.7.0.1 and continue below steps.

3. Spawn up the Vagrant setup.

```
vagrant up
```
4. Access the Identity Server and Identity Server Analytics via the URLs given below.

```
For Identity Server - https://localhost:9443/carbon
For Identity Server Analytics Dashboard - https://localhost:9634/portal
```
