# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Require colors..
require './vagrant/color'

# Lets get this party started
puts "Welcome, developer! 😎".green
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
end

def doProvision(boxName, box)
    box.vm.provision :salt do |salt|
        #salt.pillar({
        #    "networking" => {
        #        "host" => $boxConf['lite'][:hostname],
        #       "ip" => $boxConf['lite'][:ip]
        #    }
        #})
        salt.minion_config = "salt/vagrant-minion-lite"
        salt.run_highstate = true
        salt.verbose = true
    end
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
        requireServerDataFolder('plugins') # localNFSpath + server_data/plugins/
        #web.vm.synced_folder $localNFSpath + "server_data/plugins", "/var/www/wordpress/wp-content/plugins/", type: "nfs", create: true #,mount_options: ["uid=501", "gid=501"]
        #web.vm.synced_folder localNFSpath + "server_data/themes", "/var/www/wordpress/wp-content/themes/", type: "nfs", create: true #,mount_options: ["uid=501", "gid=501"]
        #web.vm.synced_folder localNFSpath + "server_data/ukmapi", "/etc/php-includes/UKM/", type: "nfs", create: true #,mount_options: ["uid=501", "gid=501"]
        #web.vm.synced_folder localNFSpath + "server_data/subdomains/datakultur", "/var/www/datakultur/", type: "nfs", create: true #,mount_options: ["uid=501", "gid=501"]

        
        # Hostname conf
        web.vm.hostname = "ukm.dev"
        hostname_aliases = Array.new
        
        # Provision (salt-stack)
        doProvision('web',web)
    end

    ## LITE WEB SERVER (for project fun)
    config.vm.define "lite" do |lite|
        commonConf('lite', lite)

        requireServerDataFolder('lite')
        #lite.vm.synced_folder $localNFSpath + "server_data/lite/www", "/var/www/", type: "nfs", create: true
        
        doProvision('lite',lite)
    end
    

end
  