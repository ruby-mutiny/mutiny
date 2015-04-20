require "mutiny/mutator/command_line"
require "mutiny/mutator/unknown_mutation_operator_error"

Given(/^I have the following program:$/) do |content|
  step("I have the following unit at \"#{filename}\":", content)
end

When(/^I apply the mutation operator "([^"]*?)"$/) do |operator|
  step("I apply the mutation operator \"#{operator}\" to \"#{filename}\"")
end

When(/^I apply the mutation operator "([^"]*?)" to "([^"]*?)"$/) do |operator, relative_path|
  run_mutator(path: path(relative_path), operator: operator)
end

Then(/^I should receive the following mutants:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.map_headers! { |header| header.downcase.to_sym }
  expected_results.map_column!("Path") { |v| path(v) }
  expected_results.map_column!("Line") { |v| v.to_i } if expected_results.raw.first.include? "Line"
  expected_results.map_column!("Change") { |v| v.empty? ? nil : v.to_sym }

  expected_results.hashes.each do |row|
    if row.key?(:position)
      precise_match(row)
    else
      imprecise_match(row)
    end
  end
end

def precise_match(row)
  found = @results.any? do |m|
    [m.path, m.position, m.change, m.operator] ==
    row.values_at(*%i(path position change operator))
  end

  expect(found).to be_true, precise_match_message(row)
end

def precise_match_message(row)
  "expected to find a mutant of #{row[:path]} " \
  "at position #{row[:position]} " \
  "with change #{row[:operator]}(#{row[:change]}), " \
  "but there was none in: \n" + @results.map(&:inspect).join("\n")
end

def imprecise_match(row)
  found = @results.any? do |m|
    [m.path, m.line, m.change] == row.values_at(*%i(path line change))
  end

  expect(found).to be_true, imprecise_match_message(row)
end

def imprecise_match_message(row)
  "expected to find a mutant of #{row[:path]} " \
  "on line #{row[:line]} " \
  "with change #{row[:change]}, " \
  "but there was none in: \n" + @results.map(&:inspect).join("\n")
end

Then(/^I should receive the following mutated code:$/) do |expected_code|
  actual_code = @results.map(&:code)
  expect(actual_code.join("\n").gsub(/\(|\)/, "")).to eq(expected_code)
end

Then(/^I should receive an? "(.*?)" error message\.$/) do |expected_message|
  expect(@exception.message).to eq(expected_message)
end

def filename
  "original.rb"
end

def run_mutator(options)
  @results = Mutiny::Mutator::CommandLine.new(options).run
rescue UnknownMutationOperatorError => exception
  @exception = exception
end
