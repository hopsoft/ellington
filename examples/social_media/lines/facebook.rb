class Facebook < Ellington::Line

  stations << VerifyFacebookToken.new
  stations << CanPost.new
  stations << ShouldPost.new
  stations << Post.new

  goal stations.last.passed

end
