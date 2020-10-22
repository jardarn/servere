require 'fileutils'

def requireServerDataFolder(relative_directory)
    dirname = File.dirname($localNFSpath + '../server_data/'+ relative_directory +'/')
    unless File.directory?(dirname)
       FileUtils.mkdir_p(dirname)
    end
    return true
end

# Share folder between vm and host
def share(box, localpath, serverpath)   
    requireServerDataFolder(localpath)
    box.vm.synced_folder $localNFSpath + "../server_data/" + localpath, serverpath, type: "nfs", create: true
end