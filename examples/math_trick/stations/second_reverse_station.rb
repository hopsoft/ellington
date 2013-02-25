class SecondReverseStation < Ellington::Station

  def engage(number, options={})
    begin
      options[:second_reverse] = options[:first_subtract].to_s.reverse.to_i
      pass_passenger number
    rescue Exception
      error_passenger number
    end
  end

end
