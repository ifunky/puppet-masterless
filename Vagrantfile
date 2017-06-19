VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


  config.vm.define "centos" do |centos|
    centos.vm.hostname  = "basecentos"
    centos.vm.box 		  = "dangibbons/centos7.3"
    centos.vm.box_url   = "dangibbons/centos7.3"

    if Vagrant.has_plugin?("vagrant-cachier")
    	centos.cache.scope       = :machine
    	centos.cache.auto_detect = false
    end

    centos.vm.network "private_network", ip: "192.168.33.5"
    centos.vm.synced_folder ".", "/puppet-dev", id: "vagrant-puppet-root"

    centos.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
    end
    centos.vm.provision "shell",
      inline: "echo 'environment=local'  >> /etc/puppetlabs/puppet/puppet.conf"
    centos.vm.provision "shell",
      inline: 'echo -e $"#!/bin/bash\necho stage=local"  > /opt/puppetlabs/facter/facts.d/stage.sh'
    centos.vm.provision "shell",
      inline: "chmod +x /opt/puppetlabs/facter/facts.d/stage.sh"
  end

  config.vm.define "win2012" do |win2012|

    win2012.vm.communicator = "winrm"
    win2012.winrm.username = "vagrant"
    win2012.winrm.password = "vagrant"

    win2012.vm.guest = :windows
    win2012.windows.halt_timeout = 15

    config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true

    win2012.vm.synced_folder ".", "/puppet-dev", id: "vagrant-puppet-root"

    win2012.vm.hostname = "windows2012"
    win2012.vm.box = "windows2012"
    win2012.vm.box_url = "c:/Projects/iFunky/bakery/windows_2012_r2_virtualbox.box"
    win2012.vm.network "private_network", ip: "192.168.33.12"

    win2012.vm.provider :virtualbox do |v, override|
      v.gui = true
      v.customize ["modifyvm", :id, "--memory", 2024]
      v.customize ["modifyvm", :id, "--cpus", 2]
      v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      v.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
    end

  end

end
