require_relative "../../lib/mutiny/command_line"

When(/^I run mutiny on "(.*?)"$/) do |path_to_spec|
  RSpec.world.reset
  @results = Mutiny::CommandLine.new(File.expand_path("../../../.tmp/#{path_to_spec}", __FILE__)).run
end

Then(/^I should receive the following results:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.hashes.each do |row|
    line = row['Line'].to_i
    change = row['Change'].to_sym
    
    actual = @results.for(line, change)
    expected = row['Result'].to_sym
    message = "expected the mutant on line #{line} with change #{change} to be #{expected}, but it was #{actual}"
    
    expect(actual).to eq(expected), message
  end
end