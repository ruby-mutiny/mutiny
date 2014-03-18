require "mutiny/mutator/command_line"

When(/^I configure the mutator with the option "(.*?)" set to "(.*?)"$/) do |option, value|
  options[option.to_sym] = value
end

When(/^I run the mutator on "(.*?)"$/) do |relative_path_to_unit|
  options[:path] = path(relative_path_to_unit)
  @results = Mutiny::Mutator::CommandLine.new(options).run
end

Then(/^I should receive the following mutants:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.map_headers! { |header| header.downcase.to_sym }
  expected_results.map_column!("Path") { |v| path(v) }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Change") { |v| if v.empty? then nil else v.to_sym end }

  expected_results.hashes.each do |row|
    found = @results.any? {|m| m.path == row[:path] && m.line == row[:line] && m.change == row[:change]}
    message = "expected to find a mutant of #{row[:path]} on line #{row[:line]} with change #{row[:change]}, but there was none"
    
    expect(found).to be_true, message
  end
end

Then(/^I should receive the following mutated code:$/) do |expected_code|
  expect(@results.map(&:code).join("\n")).to eq(expected_code)
end


def options
  @options ||= { noisy: false }
end