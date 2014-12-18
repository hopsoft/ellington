class ShouldTweet < Ellington::Station

  def engage(user)
    # Add some fakery so it feels like its working.
    i = rand(100)
    raise "Number is 0" if i == 0
    i > 5
  end

end
