$boxConf = {}

Dir.foreach('./boxconfig') do |filename|
    next if filename == '.' or filename == '..' or filename.include?('DS_Store')
    $boxNames << filename
    require "./boxconfig/#{filename}"
end