require_relative "test_helper"

class UniqueTypeArrayTest < MicroTest::Test

  before do
    @list = Ellington::UniqueTypeArray.new
  end

  test "accepts values of different types" do
    @list.push 1
    @list.push 1.0
    @list.push true
    @list.push "hi"
    @list.push :foo
  end

  test "can only push 1 entry with the same type" do
    @list.push 1
    begin
      @list.push 2
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "contains_a?" do
    @list.push :foo
    assert @list.contains_a?(Symbol)
  end

end

