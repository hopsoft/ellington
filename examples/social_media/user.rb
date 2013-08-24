# A basic user object for demo purposes.
# An actual user might be an ActiveRecord or some other complex object.

require "securerandom"

class User

  def id
    @id ||= SecureRandom.uuid
  end

  def current_message
    @current_message ||= "My favorite number is #{rand(9999)}!"
  end

end
