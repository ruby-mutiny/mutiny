require "mutiny/mutator/command_line"

When(/^I run the mutator on "(.*?)"$/) do |relative_path_to_unit|
  @results = Mutiny::Mutator::CommandLine.new(path: path(relative_path_to_unit)).run
end

Then(/^I should receive the following mutants:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.map_headers! { |header| header.downcase.to_sym }
  expected_results.map_column!("Path") { |v| path(v) }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Change") { |v| v.to_sym }

  expected_results.hashes.each do |row|
    found = @results.mutants.any? {|m| m.path == row[:path] && m.line == row[:line] && m.change == row[:change]}
    message = "expected to find a mutant of #{row[:path]} on line #{row[:line]} with change #{row[:change]}, but there was none"
    
    expect(found).to be_true, message
  end
end