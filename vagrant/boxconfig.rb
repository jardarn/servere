$boxConf = {}

Dir.foreach('./vagrant/boxconfig') do |filename|
    next if filename == '.' or filename == '..'
    $boxNames << filename
    require "./vagrant/boxconfig/#{filename}"
end
