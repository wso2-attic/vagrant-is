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

DB_USER=root
DB_PASSWORD=wso2carbon
WORKING_DIRECTORY=/home/vagrant

# run product db script
echo "Execute the database scripts..."
mysql -u${DB_USER} -p${DB_PASSWORD} -e "source ${WORKING_DIRECTORY}/mysql/scripts/mysql5.7.sql"
mysql -u${DB_USER} -p${DB_PASSWORD} -e "source ${WORKING_DIRECTORY}/mysql/scripts/um_mysql5.7.sql"
mysql -u${DB_USER} -p${DB_PASSWORD} -e "source ${WORKING_DIRECTORY}/mysql/scripts/analytics5.7.sql"
echo "Successfully executed the database scripts."

# grants root access to MySQL server from any host
echo "Create user..."
mysql -u${DB_USER} -p${DB_PASSWORD} -e "create user 'root'@'%' identified by 'wso2carbon';"
echo "Successfully created the user."

echo "Grant access to the user..."
mysql -u${DB_USER} -p${DB_PASSWORD} -e "grant all privileges on *.* to 'root'@'%' with grant option;"
mysql -u${DB_USER} -p${DB_PASSWORD} -e "flush privileges;"
echo "Successfully granted access to the user."

echo "Removing configurations directories."
rm -rf ${WORKING_DIRECTORY}/mysql
