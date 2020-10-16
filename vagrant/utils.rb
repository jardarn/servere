# Set configs common for all boxes
def commonConf(boxName, box)
    # Edit disk and memory
    box.disksize.size = $boxConf[boxName][:disksize]
    box.vm.hostname = $boxConf[boxName][:hostname]
    
    if ARGV.include?("shellNetwork")
        print('Bruker shellNetwork'.yellow)
        box.vm.network "private_network", ip: $boxConf[boxName][:ip], auto_config: false
        box.vm.provision 'shell', inline: "ifconfig eth1 "+ $boxConf[boxName][:ip]
    else    
        box.vm.network "private_network", ip: $boxConf[boxName][:ip]
    end
end

# Actually run salt-provisioning
def doProvision(boxName, box)
    box.vm.provision :salt do |salt|
        salt.pillar({
            "networking" => {
                "host" => $boxConf[boxName][:hostname],
                "ip" => $boxConf[boxName][:ip]
            }
        })
        salt.minion_config = "salt/vagrant-minion-"+ boxName
        salt.run_highstate = true
        salt.verbose = true
    end
end