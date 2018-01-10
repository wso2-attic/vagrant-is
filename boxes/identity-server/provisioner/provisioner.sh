#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

# This script acts as the machine provisioner during the Vagrant box build process for WSO2 Identity Server.

# set variables
WSO2_SERVER=wso2is
WSO2_SERVER_VERSION=5.4.0
WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip
JDK_ARCHIVE=jdk-8u*-linux-x64.tar.gz
MYSQL_CONNECTOR=mysql-connector-java-*-bin.jar

DEFAULT_MOUNT=/vagrant
SOFTWARE_DISTRIBUTIONS=${DEFAULT_MOUNT}/files
CONFIGURATIONS=${DEFAULT_MOUNT}/identity-server/confs
WORKING_DIRECTORY=/home/vagrant
JAVA_HOME=/opt/java
DEFAULT_USER=vagrant

# operate in anti-fronted mode with no user interaction
export DEBIAN_FRONTEND=noninteractive

# check if the required software distributions have been added
if [ ! -f ${SOFTWARE_DISTRIBUTIONS}/${WSO2_SERVER_PACK} ]; then
    echo "WSO2 server pack not found. Please copy the ${WSO2_SERVER_PACK} to ${SOFTWARE_DISTRIBUTIONS} folder and retry."
    exit 1
fi

if [ ! -f ${SOFTWARE_DISTRIBUTIONS}/${JDK_ARCHIVE} ]; then
    echo "JDK archive file not found. Please copy the JDK archive file to ${SOFTWARE_DISTRIBUTIONS} folder and retry."
    exit 1
fi

if [ ! -f ${SOFTWARE_DISTRIBUTIONS}/${MYSQL_CONNECTOR} ]; then
    echo "MySQL Connector JAR file not found. Please copy the MySQL Connector JAR file to ${SOFTWARE_DISTRIBUTIONS} folder and retry."
    exit 1
fi

echo "Starting the ${WSO2_SERVER}-${WSO2_SERVER_VERSION} Vagrant box build process..."

# install utility software
echo "Installing software utilities..."
apt-get install unzip
echo "Successfully installed software utilities"

# set up Java
echo "Setting up Java..."
if test ! -d ${JAVA_HOME}; then mkdir ${JAVA_HOME}; fi
if test -d ${JAVA_HOME}; then
  tar -xf ${SOFTWARE_DISTRIBUTIONS}/${JDK_ARCHIVE} -C ${JAVA_HOME} --strip-components=1
fi
echo "Successfully set up Java"

# unpack the WSO2 product pack to the working directory
echo "Setting up the ${WSO2_SERVER}-${WSO2_SERVER_VERSION} server..."
if test ! -d ${WSO2_SERVER}-${WSO2_SERVER_VERSION}; then
  unzip -q ${DEFAULT_MOUNT}/files/${WSO2_SERVER_PACK} -d ${WORKING_DIRECTORY}
fi
echo "Successfully set up ${WSO2_SERVER}-${WSO2_SERVER_VERSION} server"

# set ownership of the working directory to the default ssh user and group
chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${WORKING_DIRECTORY}

# capture the exact file name of the MySQL connector
pushd ${SOFTWARE_DISTRIBUTIONS}
MYSQL_CONNECTOR=$(ls ${MYSQL_CONNECTOR})
popd

# copy files with configuration changes
echo "Copying the files with configuration changes to the server pack..."
cp ${SOFTWARE_DISTRIBUTIONS}/${MYSQL_CONNECTOR} ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/components/lib/${MYSQL_CONNECTOR}
cp ${CONFIGURATIONS}/repository/conf/user-mgt.xml ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/conf/user-mgt.xml
cp ${CONFIGURATIONS}/repository/conf/datasources/master-datasources.xml ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/conf/datasources/master-datasources.xml
cp ${CONFIGURATIONS}/repository/conf/identity/embedded-ldap.xml ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/conf/identity/embedded-ldap.xml
cp ${CONFIGURATIONS}/repository/conf/identity/identity.xml ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/conf/identity/identity.xml
cp ${CONFIGURATIONS}/repository/deployment/server/eventpublishers/IsAnalytics-Publisher-wso2event-AuthenticationData.xml ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/deployment/server/eventpublishers/IsAnalytics-Publisher-wso2event-AuthenticationData.xml
cp ${CONFIGURATIONS}/repository/deployment/server/eventpublishers/IsAnalytics-Publisher-wso2event-SessionData.xml ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/repository/deployment/server/eventpublishers/IsAnalytics-Publisher-wso2event-SessionData.xml
echo "Successfully copied files with configuration changes to the server pack."

# remove the APT cache
apt-get clean

# zero out the drive
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# clear the bash history and exit
cat /dev/null > ${WORKING_DIRECTORY}/.bash_history && history -c
