require_relative "test_helper"

class ConductorTest < MicroTest::Test

  before do
    class Station < Ellington::Station
      def initialize
        super "Station 1", [:one, :two, :three]
      end
      def engage(passenger, options={})
      end
    end

    route = Ellington::Route.new("Example Route")
    route.add Ellington::Line.new("A Line")
    route["A Line"] << Station.new

    @conductor = Ellington::Conductor.new(route, 5)
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
