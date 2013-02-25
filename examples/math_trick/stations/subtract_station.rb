class SubtractStation < Ellington::Station

  def engage(number, options={})
    begin
      options[:first_subtract] = number - options[:first_reverse]
      pass_passenger number
    rescue Exception
      error_passenger number
    end
  end

end
