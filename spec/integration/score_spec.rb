describe "Using Mutiny to generate mutants" do
  it "should report a mutation score" do
    cd "calculator"
    run "bundle exec mutiny mutate"
    run "bundle exec mutiny score"

    expected_output = "Scoring...\n" \
                      "14 mutants, 14 killed\n"

    expect(all_output).to end_with(expected_output)
  end
end
