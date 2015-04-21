describe "Using Mutiny to check tests can be run" do
  it "should run tests" do
    cd 'calculator'
    run 'bundle exec mutiny -p Calculator check'

    expect(all_output).to end_with("3 examples, 0 failures\n")
  end
end
