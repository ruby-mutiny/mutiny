describe "Using Mutiny to score existing mutants" do
  before(:each) do
    cd "calculator"
    run "bundle exec mutiny mutate"

    run "rm -rf .mutants/calculator/max.0.rb"
    run "rm -rf .mutants/calculator/max.1.rb"
    run "rm -rf .mutants/calculator/max.2.rb"
    run "rm -rf .mutants/calculator/max.3.rb"
    run "rm -rf .mutants/calculator/max.4.rb"
    run "rm -rf .mutants/calculator/max.5.rb"
    run "rm -rf .mutants/calculator/max.6.rb"

    run "rm -rf .mutants/calculator/min.0.rb"
    run "rm -rf .mutants/calculator/min.1.rb"

    run "bundle exec mutiny score --cached"
  end

  it "should report a mutation score" do
    expected_output = "Scoring...\n" \
                      "5 mutants, 4 killed\n"

    expect(all_output).to include(expected_output)
  end

  it "should report status of mutants" do
    expect(all_output).to include("calculator/min.2.rb | survived")
    expect(all_output).to include("calculator/min.3.rb | killed")
    expect(all_output).to include("calculator/min.4.rb | killed")
    expect(all_output).to include("calculator/min.5.rb | killed")
    expect(all_output).to include("calculator/min.6.rb | killed")
  end
end
