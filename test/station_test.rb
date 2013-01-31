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
  end

  test "name" do
    assert @station.name == "Last Name Station"
  end

  test "line is unassigned" do
    assert @station.line.nil?
  end

  test "cannot engage a passenger in the wrong state" do
    passenger = Ellington::Passenger.new({}, StateJacket::Catalog.new)
    passenger.current_state = :start
    assert !@station.can_engage?(passenger)
  end

end
