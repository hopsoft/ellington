require "securerandom"

# A basic user object for demo purposes.
class User

  def id
    @id ||= SecureRandom.uuid
  end

  def current_message
    @current_message ||= "My favorite number is #{rand(9999)}!"
  end

end
