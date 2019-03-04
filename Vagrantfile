# Copyright 2018 WSO2, Inc. (http://wso2.com)
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

# -*- mode: ruby -*-

require 'yaml'
require 'fileutils'
require 'uri'
require 'erb'

# check whether the command is 'vagrant up'
if ARGV[0] == '--updates'
  print "Please insert your WSO2 credentials\n"
  print "Username: "
  USERNAME = STDIN.gets.chomp
  print "Password: "
  PASSWORD = STDIN.noecho(&:gets).chomp
  print "\n"
  # generate TOKEN
  TOKEN = [ERB::Util.url_encode(USERNAME), ERB::Util.url_encode(PASSWORD)].join(':')
else
  # initializing USERNAME and PASSWORD
  print "Using the Vagrant boxes with no updates...\n"
  USERNAME = ""
  PASSWORD = ""
end

FILES_PATH = "./"
DEFAULT_MOUNT = "/home/vagrant/"
# load server configurations from YAML file
CONFIGURATIONS = YAML.load_file('config.yaml')
Vagrant.configure(2) do |config|

  # changing default timeout from 300 to 1000 seconds
  config.vm.boot_timeout = 1000

  # loop through each server configuration specification
  CONFIGURATIONS['servers'].each do |server|
    # define the virtual machine configurations
    config.vm.define server['hostname'] do |server_config|
      # define the base Vagrant box to be used
      if ARGV[0] == '--updates'
        server_config.vm.box = server['box']
      else
        server_config.vm.box = "wso2/" + server['box']
      end

      # define the virtual machine host name
      server_config.vm.host_name = server['hostname']
      # Diasbling the synched folder
      server_config.vm.synced_folder ".", "/vagrant", disabled: true

      if ARGV[0] == '--updates'
        #generate the url
        url = "https://"+TOKEN+"@vagrant.wso2.com/boxes/" + server['box'] + ".box"
      else
        url = "https://vagrantcloud.com/wso2/" + server['box']
      end

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
        vb.check_guest_additions = true
        vb.functional_vboxsf = false
        vb.gui = false
        vb.customize ['modifyvm', :id, '--memory', memory]
        vb.customize ['modifyvm', :id, '--cpus', cpu]
	vb.customize ['modifyvm', :id, '--uartmode1', 'disconnected']
      end
      if server['conf_dir']
        server_config.vm.provision "file", source: FILES_PATH + server['conf_dir'], destination: DEFAULT_MOUNT + server['conf_dir']
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
