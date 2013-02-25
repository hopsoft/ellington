class FirstReverseStation < Ellington::Station

  def engage(number, options={})
    begin
      options[:first_reverse] = number.to_s.reverse.to_i
      pass_passenger number
    rescue Exception => e
      error_passenger number
    end
  end

end
