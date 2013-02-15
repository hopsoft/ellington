require_relative "test_helper"
require "logger"

class LoggerTest < MicroTest::Test

  before do
    @orig_logger = Ellington.logger
    @logger = Logger.new(STDOUT)
    Ellington.logger = @logger
  end

  after do
    Ellington.logger = @orig_logger
  end

  test "logger attr" do
    assert Ellington.logger == @logger
  end

end
