class Twitter < Ellington::Line

  stations << VerifyTwitterToken.new
  stations << CanTweet.new
  stations << ShouldTweet.new
  stations << Tweet.new

  goal stations.last.passed

end
