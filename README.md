# Vagrantfile for WSO2 Identity Server

This section defines the procedure to execute Vagrant resources for a setup of WSO2 Identity Server single
node with Analytics support.<br>

![Deployment architecture](deployment-architecture.png)

Please note that in order to run these Vagrant resources use, you need to install
[Oracle VM VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html)
since, Vagrant uses Oracle VM VirtualBox as the default provider. In addition, you need to download the official JDBC driver
for MySQL, [Connector/J](https://dev.mysql.com/downloads/connector/j/5.1.html).

## How to run the Vagrantfile

1. Checkout this repository into your local machine using the following Git command.

```
    git clone https://github.com/wso2/vagrant-is.git
```

2. Move to `vagrant-is` folder.

```
    cd vagrant-is
```

3. Spawn up the Vagrant setup.

```
    vagrant up
```
4. Access the Identity Server via the URL given below.

```
    https://172.28.128.4:9443/carbon
```
