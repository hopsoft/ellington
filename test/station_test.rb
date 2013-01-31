require_relative "test_helper"

class StationTest < MicroTest::Test

  before do
    class LastNameStation < Ellington::Station
     def initialize(name)
       states = [
         :last_name_passed, 
         :last_name_failed, 
         :last_name_error
       ]
       super(name, *states)
     end

     # Business logic that verifies the passenger's last name.
     def engage(passenger, options={})
       if passenger.last_name != "hopkins"
         passenger.transition_to(:last_name_passed)
       else
         passenger.transition_to(:last_name_failed)
       end
     rescue Exception => ex
       passenger.transition_to(:last_name_error)
     end
    end

    @station = LastNameStation.new("Last Name Station")

    states = StateJacket::Catalog.new
    states.add :first_name_passed => [
      :last_name_passed,
      :last_name_failed,
      :last_name_error
    ]
    states.add :last_name_passed
    states.add :last_name_failed
    states.add :last_name_error
    states.lock
    @passenger = Ellington::Passenger.new({}, states)
  end

  test "construction fails when no states passed" do
    error = nil
    begin
      Ellington::Station.new("Missing States")
    rescue Ellington::InvalidStates => e
      error = e
    end
    assert !error.nil?
  end

  test "construction fails when fewer than 3 states passed" do
    error = nil
    begin
      Ellington::Station.new("Missing States", :one, :two)
    rescue Ellington::InvalidStates => e
      error = e
    end
    assert !error.nil?
  end

  test "construction fails when more than 3 states passed" do
    error = nil
    begin
      Ellington::Station.new("Missing States", :one, :two, :three, :four)
    rescue Ellington::InvalidStates => e
      error = e
    end
    assert !error.nil?
  end

  test "engage is abstract" do
    error = nil
    begin
      station = Ellington::Station.new("Missing States", :one, :two, :three)
      station.engage nil
    rescue Ellington::NotImplementedError => e
      error = e
    end
    assert !error.nil?
  end

  test "name" do
    assert @station.name == "Last Name Station"
  end

  test "line is unassigned" do
    assert @station.line.nil?
  end

  test "cannot engage a passenger in the wrong state" do
    @passenger.current_state = :start
    assert !@station.can_engage?(@passenger)
  end

end
