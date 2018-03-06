# Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
# limitations under the License.

# -*- mode: ruby -*-

require 'yaml'
require 'fileutils'
require 'uri'
require 'erb'

$stdout.print "login: "
USERNAME = $stdin.gets.chomp
$stdout.print "password: "
PASSWORD = $stdin.noecho(&:gets).chomp
TOKEN = [ERB::Util.url_encode(USERNAME), PASSWORD].join(':')

# load server configurations from YAML file
CONFIGURATIONS = YAML.load_file('config.yaml')

Vagrant.configure(2) do |config|
  # loop through each server configuration specification
  CONFIGURATIONS['servers'].each do |server|
    # define the virtual machine configurations
    config.vm.define server['hostname'] do |server_config|
      # define the base Vagrant box to be used
      server_config.vm.box = server['box']
      # define the virtual machine host name
      server_config.vm.host_name = server['hostname']

      #generate the url
      url = "https://"+TOKEN+"@vagrant.wso2.com/boxes/"+server['box']+".box"

      server_config.vm.box_url = url
      # setup network configurations for the virtual machine
      # use private networking (recommended for multi-machine scenarios)
      server_config.vm.network :private_network, ip: server['ip']

      #forwarding ports to access the server via localhost
      if server['ports']
        server['ports'].each do |port|
          server_config.vm.network "forwarded_port", guest: port, host: port, guest_ip: server['ip']
        end
      end

      memory = server['ram'] ? server['ram'] : 2048
      cpu = server['cpu'] ? server['cpu'] : 1
      # setup VirtualBox specific provider configurations
      server_config.vm.provider :virtualbox do |vb|
        vb.name = server['hostname']
        vb.check_guest_additions = false
        vb.functional_vboxsf = false
        vb.gui = false
        vb.customize ['modifyvm', :id, '--memory', memory]
        vb.customize ['modifyvm', :id, '--cpus', cpu]
      end

      # configure shell provisioner
      if !server['provisioner_script']
        # if not defined, move to next server specification
        next
      end

      if server['provisioner_script_args']
        # if argument(s) have been defined to be passed to the shell script
        server_config.vm.provision "shell", path: server['provisioner_script'], args: server['provisioner_script_args']
      else
        # if no argument(s) have been defined to be passed to the shell script
        server_config.vm.provision "shell", path: server['provisioner_script']
      end
    end
  end
end
