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

## REQUIRE DATA PACKAGE FILES IF BRINGING UP OR PROVISIONING VM
if ARGV.include?("up") || (ARGV.include?("reload") && ARGV.include?("--provision"))
    dataPackageMissing = []

    ['ukmdev_dev_ss3.sql','ukmdev_dev_wp.sql','uploads.tar.gz'].each do |file|
        if( !File.exist?("salt/ukmlib/datapackage/#{file}" )) 
            dataPackageMissing << file
        end
    end
    if( dataPackageMissing.length() > 0 )
        puts "Missing required data package file(s):".red
        dataPackageMissing.each do |file|
            puts "  ./salt/ukmlib/datapackage/#{file}"
        end
        puts "See README.md for how to request development data package from UKM Norge."
        puts "$ open README.md".yellow

        abort
    end
end

if ARGV.include?("up") || (ARGV.include?("reload") && ARGV.include?("--provision"))
    puts "In case you've forgotten, remember to approve the UKM Norge (UKM.dev) certificate authority (CA):".blue
    puts " $ open #{Dir.pwd()}/salt/ukmlib/datapackage/UKMNorgeCA.pem"
end