## REQUIRE VAGRANT PLUGINS
doAbort = false
['vagrant-hostmanager','vagrant-disksize'].each do |plugin|
    unless Vagrant.has_plugin?("#{plugin}")
        puts "Missing required vagrant plugin: `#{plugin}`. To install, run:".red
        puts "$ vagrant plugin install #{plugin}".yellow
        doAbort = true
    end
end

if doAbort 
    abort
end