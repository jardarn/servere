$boxConf = {}

Dir.foreach('./boxconfig') do |filename|
    next if filename == '.' or filename == '..'
    $boxNames << filename
    require "./boxconfig/#{filename}"
end
