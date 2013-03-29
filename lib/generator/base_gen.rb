module BaseGen
  BASEDIRS = %w(
    station
    line
    route
  )

  def description(path=nil)
    <<-EOS
    Generating base directory structure for Ellington #{Ellington::VERSION} in #{path}.
    EOS
  end

  def create_base(path) 
    description path
    FileUtils.cd(path)
    BASEDIRS.map {|d|  FileUtils.mkdir "#{d}"}
  end

end

#create_basejARGV.first
