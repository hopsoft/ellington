require_relative "test_helper"

class ConductorTest < MicroTest::Test

  before do
    @route = BasicMath.new
    @conductor = Ellington::Conductor.new(@route)
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
    @passenger.current_state = @route.initial_state
    @passenger.lock
  end

  test "not conducting" do
    assert !@conductor.conducting?
  end

  test "verify" do
    assert @conductor.verify(@passenger)
  end

  test "gather_passengers is abstract" do
    error = nil
    begin
      @conductor.gather_passengers
    rescue Ellington::NotImplementedError => e
      error = e
    end
    assert !error.nil?
  end

  test "escort" do
    @conductor.escort(@passenger)
    assert @passenger.current_state != @route.initial_state
  end

  test "escort prevented when passenger doesn't verify" do
    def @conductor.verify(passenger)
      false
    end
    @conductor.escort(@passenger)
    assert @passenger.current_state == @route.initial_state
  end

  test "escort prevented when passenger is not locked" do
    @passenger.unlock
    assert @passenger.current_state == @route.initial_state
  end

  test "start/stop with conducting? checks" do
    def @conductor.gather_passengers
      sleep 0.1
      []
    end
    @conductor.start
    assert @conductor.conducting?
    @conductor.stop
    sleep 0.2
    puts !@conductor.conducting?
  end

end
