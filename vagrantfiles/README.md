# Vagrantfile for WSO2 Identity Server

This section defines the procedure to execute Vagrant resources for a setup of WSO2 Identity Server single
node with Analytics support.<br>

![Deployment architecture](deployment-architecture.png)

Please note that in order to run these Vagrant resources use, you need to install
[Oracle VM VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html)
since, Vagrant uses Oracle VM VirtualBox as the default provider. In addition, you need to download the official JDBC driver
for MySQL, [Connector/J](https://dev.mysql.com/downloads/connector/j/5.1.html).

## How to run the Vagrantfile

##### 1. Checkout this repository into your local machine using the following Git command.
```
git clone https://github.com/wso2-incubator/vagrant-is.git
```

##### 2. Build and add the Vagrant boxes for external MySQL database, WSO2 Identity Server and WSO2 Identity Server Analytics using the Vagrant box generation resources.

##### 3. Move to `machines` folder.

    cd machines
    
##### 4. Add the MySQL connector (mysql-connector-java-5.1.*-bin.jar) to the identity-server/confs/repository/components/lib folder.

##### 5. Add the MySQL connector (mysql-connector-java-5.1.*-bin.jar) to the identity-server-analytics/confs/repository/components/lib folder.

##### 6. Spawn up the Vagrant setup.

    vagrant up
