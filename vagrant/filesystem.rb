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
    puts '    mounting point: '+ localpath +' => '+ serverpath
end