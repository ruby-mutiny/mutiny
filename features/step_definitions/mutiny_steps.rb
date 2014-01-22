require_relative "../../lib/mutiny/command_line"

When(/^I configure mutiny with the option "(.*?)" set to the path "(.*?)"$/) do |option, path|
  options[option.to_sym] = expand_path_relative_to_tmp(path)
end

When(/^I run mutiny on "(.*?)"$/) do |path_to_spec|
  RSpec.world.reset
  @results = Mutiny::CommandLine.new(expand_path_relative_to_tmp(path_to_spec), options).run
end

Then(/^I should receive the following results:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.map_headers! { |header| header.downcase.to_sym }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Change") { |v| v.to_sym }
  expected_results.map_column!("Result") { |v| v.to_sym }

  expected_results.hashes.each do |row|
    actual = @results.for(row[:line], row[:change]).killed? ? :killed : :alive
    expected = row[:result]
    message = "expected the mutant on line #{row[:line]} with change #{row[:change]} to be #{expected}, but it was #{actual}"
    
    expect(actual).to eq(expected), message
  end
end

def options
  @options ||= { noisy: false }
end

def expand_path_relative_to_tmp(path)
  File.expand_path("../../../.tmp/#{path}", __FILE__)
end