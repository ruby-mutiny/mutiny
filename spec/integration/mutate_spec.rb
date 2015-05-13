describe "Using Mutiny to generate mutants" do
  it "should report statistics of generated mutants" do
    cd "calculator"
    run "bundle exec mutiny mutate"

    expected_output = "Mutating...\n" \
                      "Generated 10 mutants:\n" \
                      "  * calculator/min.rb - 5 mutants\n" \
                      "  * calculator/max.rb - 5 mutants\n" \
                      "Check the '.mutants' directory to browse the generated mutants.\n"

    expect(all_output).to eq(expected_output)
  end
end
