# Set configs common for all boxes
def commonConf(boxName, box)
    # Edit disk and memory
    box.disksize.size = $boxConf[boxName][:disksize]
    box.vm.network "private_network", ip: $boxConf[boxName][:ip]
    box.vm.hostname = $boxConf[boxName][:hostname]
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