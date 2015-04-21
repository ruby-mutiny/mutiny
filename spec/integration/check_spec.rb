describe "Using Mutiny to check tests can be run" do
  it "should run tests" do
    output = `cd examples/calculator; ../../bin/mutiny check lib calculator Calculator`

    expect(output).to end_with("3 examples, 0 failures\n")
  end
end
