# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Require colors..
require './vagrant/color'

# Lets get this party started
if !ARGV.include?("halt") && !ARGV.include?("destroy")
    puts "Welcome, developer! 😎".green
    puts "Human contact possible @ https://github.com/orgs/UKMNorge/teams/developers".green
end

# Global vars
$localNFSpath = "#{Dir.pwd}/"
$boxNames = []

# Files we kinda need
require './vagrant/dependencies'    # Vagrant plugin dependencies
require './vagrant/boxconfig'       # Different vagrant-box configs
require './vagrant/filesystem'      # File system functions
require './vagrant/utils'           # VM conf utilities

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

        # Share before provision, in case host has existing files
        share(lite, 'lite', '/var/www/')        
        share(lite, 'ukmlib', '/etc/php-includes/UKM/')

        # Provision (salt-stack)
        doProvision('lite',lite)
    end
    

end
  