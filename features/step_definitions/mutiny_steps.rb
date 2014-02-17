require_relative "../../lib/mutiny/command_line"

When(/^I configure mutiny with the option "(.*?)" set to the path "(.*?)"$/) do |option, relative_path|
  options[option.to_sym] = path(relative_path)
end

When(/^I run mutiny on "(.*?)"$/) do |relative_path_to_spec|
  RSpec.world.reset
  @results = Mutiny::CommandLine.new(path(relative_path_to_spec), options).run
end

Then(/^I should receive the following results:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.map_headers! { |header| header.downcase.to_sym }
  expected_results.map_column!("Path") { |v| path(v) }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Change") { |v| v.to_sym }
  expected_results.map_column!("Result") { |v| v.to_sym }

  expected_results.hashes.each do |row|
    mutant = @results.find {|m| m.path == row[:path] && m.line == row[:line] && m.change == row[:change]}
    actual = mutant.killed? ? :killed : :alive
    expected = row[:result]
    message = "expected the mutant on line #{row[:line]} with change #{row[:change]} to be #{expected}, but it was #{actual}"
    
    expect(actual).to eq(expected), message
  end
end

Then(/^I should receive (\d+) results for the file "(.*?)"$/) do |expected_number_of_results, path|
  mutants = @results.select {|m| m.path == path(path) }
  expect(mutants.size).to eq(expected_number_of_results.to_i)
end

def options
  @options ||= { noisy: false }
end
