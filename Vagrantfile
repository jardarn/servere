# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Require colors..
require './vagrant/color'

# Lets get this party started
puts "Welcome, developer! 😎".green
puts "Human contact possible @ https://github.com/orgs/UKMNorge/teams/developers".green
# Global vars
$localNFSpath = "#{Dir.pwd}/"
$boxNames = []
# Files we kinda need
require './vagrant/dependencies'    # Vagrant plugin dependencies
require './vagrant/boxconfig'       # Different vagrant-box configs
require './vagrant/filesystem'      # Utility functions

def commonConf(boxName, box)
    # Edit disk and memory
    box.disksize.size = $boxConf[boxName][:disksize]
    box.vm.network "private_network", ip: $boxConf[boxName][:ip]
    box.vm.hostname = $boxConf[boxName][:hostname]
end

def doProvision(boxName, box)
    box.vm.provision :salt do |salt|
        salt.pillar({
            "networking" => {
                "host" => $boxConf[boxName][:hostname],
                "ip" => $boxConf[boxName][:ip]
            }
        })
        salt.minion_config = "salt/vagrant-minion-lite"
        salt.run_highstate = true
        salt.verbose = true
    end
end

def share(box, localpath, serverpath)   
    requireServerDataFolder(localpath)
    box.vm.synced_folder $localNFSpath + "server_data/" + localpath, serverpath, type: "nfs", create: true
end

# Configure vagrant!
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "ubuntu/bionic64"
  
    # Share the salt config with the guest
    config.vm.synced_folder "salt", "/srv/salt/"
    config.vm.synced_folder "pillar", "/srv/pillar"

    # Setup host manager
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.include_offline = true

    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", $boxConf['web'][:memory]]
    end

    ## WEB MAIN SERVER (UKM.no)
    config.vm.define "web", primary: true do |web|
        commonConf('web', web)

        # Share wordpress folders
        share(web, 'plugins', '/var/www/wordpress/wp-content/plugins/')
        share(web, 'themes', '/var/www/wordpress/wp-content/themes/')
        share(web, 'ukmlib', '/etc/php-includes/UKM/')
        share(web, 'subdomains/datakultur', '/var/www/datakultur/')
        
        # Hostname conf
        web.vm.hostname = "ukm.dev"
        hostname_aliases = Array.new
        
        # Provision (salt-stack)
        doProvision('web',web)
    end

    ## LITE WEB SERVER (for project fun)
    config.vm.define "lite" do |lite|
        commonConf('lite', lite)
        share(lite, 'lite', '/var/www/')        
        doProvision('lite',lite)
    end
    

end
  