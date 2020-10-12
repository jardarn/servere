require 'fileutils'

def requireServerDataFolder(relative_directory)
    dirname = File.dirname($localNFSpath + 'server_data/'+ relative_directory +'/')
    unless File.directory?(dirname)
       FileUtils.mkdir_p(dirname)
    end
    return true
end