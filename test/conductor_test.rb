require_relative "test_helper"

class ConductorTest < MicroTest::Test

  class Station < Ellington::Station
    transitions_passenger_to :one, :two, :three

    def engage(passenger, options={})
    end
  end

  before do
    route = Ellington::Route.new("Example Route", StateJacket::Catalog.new)
    route.add Ellington::Line.new("A Line")
    route["A Line"] << ConductorTest::Station.new
    @conductor = Ellington::Conductor.new(route)
  end

  test "verify is abstract" do
    error = nil
    begin
      @conductor.verify nil
    rescue Ellington::NotImplementedError => e
      error = e
    end
    assert !error.nil?
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

  # TODO: add more tests

end
