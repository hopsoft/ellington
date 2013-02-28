class GeneratorNameError < StandardError; end
class Generate
  include FileUtils

  #Instead of using ActiveSupport::Inflector#camelize
   def self.ellington_camelize term
     if term !~ /[a-z A-Z]+.*/
       raise GeneratorNameError.new "Not a valid name!"
     elsif term !~ /_/
       term.split(/\s/).map {|c| c.capitalize}.join('')
     else
       term.split('_').map {|c| c.capitalize}.join
     end
   end

end
