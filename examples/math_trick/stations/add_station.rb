class AddStation < Ellington::Station

  def engage(number, options={})
    begin
      result = options[:first_subtract] + options[:second_reverse]
      if result == 1089
        pass_passenger number
      else
        fail_passenger number
      end
    rescue Exception
      error_passenger number
    end
  end

end
