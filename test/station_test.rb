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
       if !passenger.last_name.nil? && passenger.last_name != "hopkins"
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
    person = MicroMock.make.new
    person.attr(:last_name)
    ticket = Ellington::Ticket.new(:ok => true)
    @passenger = Ellington::Passenger.new(person, ticket, states)
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

  test "line assignment" do
    line = Ellington::Line.new("Example Line")
    @station.line = line
    assert @station.line == line
  end

  test "line can only be assigned once" do
    line1 = Ellington::Line.new("Example Line 1")
    line2 = Ellington::Line.new("Example Line 2")
    error = nil
    begin
      @station.line = line1
      @station.line = line2
    rescue Ellington::StationAlreadyBelongsToLine => e
      error = e
    end
    assert !error.nil?
  end

  test "cannot engage an unlocked passenger" do
    @passenger.current_state = :first_name_passed
    assert !@station.can_engage?(@passenger)
  end

  test "cannot engage a passenger in the wrong state" do
    @passenger.lock
    @passenger.current_state = :start
    assert !@station.can_engage?(@passenger)
  end

  test "call should not engage a locked passenger in the wrong state" do
    observer = MicroMock.make.new
    observer.attr(:engagements, [])
    observer.def(:update) do |station, passenger, transitions|
      self.engagements << [station, passenger, transitions]
    end
    @passenger.lock
    @passenger.current_state = :start
    @station.call(@passenger)
    assert observer.engagements.empty?
  end

  test "call should engage a locked passenger in the right state" do
    observer = MicroMock.make.new
    observer.attr(:engagements, [])
    observer.def(:update) do |station, passenger, transitions|
      self.engagements << [station, passenger, transitions]
    end
    @passenger.lock
    @passenger.current_state = :first_name_passed
    @passenger.last_name = "doe"
    @station.add_observer observer
    @station.call(@passenger)
    assert observer.engagements.length == 1
    assert @passenger.current_state == :last_name_passed
  end

end
