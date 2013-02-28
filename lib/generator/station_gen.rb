module StationGen
  def description station_name
    <<-EOS
    Generating station #{station_name}
    EOS
  end

  def station_standard station_name
    station_name = Generate.ellington_camelize(station_name)
    "class #{station_name}; end"
  end

  def create_station station_name,path=nil
    path ||= 'lib/station/'
    FileUtils.cd path
    File.open("#{station_name}.rb", 'w') do |f|
      f.write station_standard station_name
    end
  end

end

#create_station ARGV.first
