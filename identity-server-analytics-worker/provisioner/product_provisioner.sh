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

# set variables
WSO2_SERVER=wso2is-analytics
WSO2_SERVER_VERSION=5.7.0
WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}*.zip
MYSQL_CONNECTOR=mysql-connector-java-5.1.*-bin.jar
JDK_ARCHIVE=jdk-8u*-linux-x64.tar.gz
WORKING_DIRECTORY=/home/vagrant
JAVA_HOME=/opt/java/
CONFIGURATIONS=${WORKING_DIRECTORY}/identity-server-analytics-worker/confs

# operate in anti-fronted mode with no user interaction
export DEBIAN_FRONTEND=noninteractive

# install utility software
echo "Installing software utilities."
apt-get install unzip
echo "Successfully installed software utilities."

#setting up Java
echo "Setting up Java."
if test ! -d ${JAVA_HOME}; then
  mkdir ${JAVA_HOME};
  tar -xf ${WORKING_DIRECTORY}/${JDK_ARCHIVE} -C ${JAVA_HOME} --strip-components=1
  echo "Successfully set up Java"
fi

#setting up the server
if test ! -d ${WSO2_SERVER}-${WSO2_SERVER_VERSION}; then
  unzip -q ${WORKING_DIRECTORY}/${WSO2_SERVER_PACK} -d ${WORKING_DIRECTORY}
  echo "Successfully set up ${WSO2_SERVER}-${WSO2_SERVER_VERSION} server"
fi

#moving MySQL driver
echo "Copying the MySQL driver to the server pack..."
cp ${WORKING_DIRECTORY}/${MYSQL_CONNECTOR} ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/lib/${MYSQL_CONNECTOR}
echo "Successfully copied the MySQL driver to the server pack."

# copy files with configuration changes
echo "Copying the files with configuration changes to the server pack..."
cp -Trv ${CONFIGURATIONS}/conf/ ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/conf/
echo "Successfully copied the files."

export JAVA_HOME

echo "Removing configurations directories."
rm -rf ${CONFIGURATIONS}

# start the WSO2 product pack as a background service
echo "Starting ${WSO2_SERVER}-${WSO2_SERVER_VERSION}..."
nohup ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/wso2/worker/bin/carbon.sh &

sleep 10

# tail the WSO2 product server startup logs until the server startup confirmation is logged
tail -f ${WORKING_DIRECTORY}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}/wso2/worker/logs/carbon.log | while read LOG_LINE
do
  # echo each log line
  echo "${LOG_LINE}"
  # once the log line with WSO2 Carbon server start confirmation was logged, kill the started tail process
  [[ "${LOG_LINE}" == *"WSO2 Analytics Identity Server started"* ]] && pkill tail
done
