require 'fileutils'

def requireServerDataFolder(relative_directory)
    dirname = File.expand_path($localNFSpath + '../shared/'+ relative_directory +'/')
    unless File.directory?(dirname)
       FileUtils.mkdir_p(dirname)
    end
    return dirname
end

# Share folder between vm and host
def share(box, localpath, serverpath)   
    localpath = requireServerDataFolder(localpath)
    box.vm.synced_folder localpath, serverpath, type: "nfs", create: true
    puts '    mount point: '+ localpath +' => '+ serverpath
end

# Require and copy datapackage files
def requireDataPackageFiles(source, target, files)
    files.each do |file|
        targetfile = File.expand_path("#{target}#{file}")
        sourcefile = File.expand_path("#{source}#{file}")
        if( !File.exist?(targetfile)) 
            if( File.exist?(sourcefile))
                FileUtils.cp(sourcefile, targetfile)
            else
                $dataPackageMissing << file
            end
        end
    end
end