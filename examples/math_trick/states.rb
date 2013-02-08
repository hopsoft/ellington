module MathTrick

  States = begin
    states = StateJacket::Catalog.new
    states.add :new_number => [:first_reverse_pass, :first_reverse_fail, :first_reverse_error]
    states.add :first_reverse_fail
    states.add :first_reverse_error
    states.add :first_reverse_pass => [:subtract_pass, :subtract_fail, :subtract_error]
    states.add :subtract_fail
    states.add :subtract_error
    states.add :subtract_pass => [:second_reverse_pass, :second_reverse_fail, :second_reverse_error]
    states.add :second_reverse_fail
    states.add :second_reverse_error
    states.add :second_reverse_pass => [:add_pass, :add_fail, :add_error]
    states.add :add_fail
    states.add :add_error
    states.add :add_pass
    states.lock
    states
  end

end
