describe "Using Mutiny to score mutants" do
  before(:each) do
    cd "calculator"
    run "bundle exec mutiny mutate"
    run "bundle exec mutiny score"
  end

  it "should report a mutation score" do
    expected_output = "Scoring...\n" \
                      "14 mutants, 12 killed\n"

    expect(all_output).to include(expected_output)
  end

  it "should report status of mutants" do
    expect(all_output).to include("calculator/min.0.rb | killed")
    expect(all_output).to include("calculator/min.1.rb | killed")
    expect(all_output).to include("calculator/min.2.rb | survived")
    expect(all_output).to include("calculator/min.3.rb | killed")
    expect(all_output).to include("calculator/min.4.rb | killed")
    expect(all_output).to include("calculator/min.5.rb | killed")
    expect(all_output).to include("calculator/min.6.rb | killed")
    expect(all_output).to include("calculator/max.0.rb | killed")
    expect(all_output).to include("calculator/max.1.rb | killed")
    expect(all_output).to include("calculator/max.2.rb | killed")
    expect(all_output).to include("calculator/max.3.rb | killed")
    expect(all_output).to include("calculator/max.4.rb | killed")
    expect(all_output).to include("calculator/max.5.rb | killed")
    expect(all_output).to include("calculator/max.6.rb | survived")
  end

  it "should fail fast (not execute all tests for some killed mutants)" do
    expect(all_output).to include("2 (of 3)")
  end
end
