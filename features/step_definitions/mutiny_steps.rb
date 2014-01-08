require_relative "../../lib/mutiny"
require_relative "../../lib/test_suite"

Given(/^I have the following program:$/) do |program|
  @program = program
end

Given(/^I have the following test suite:$/) do |tests|
  @test_suite = TestSuite.new(tests)
end

When(/^I run mutiny$/) do
  @results = Mutiny.new(@program, @test_suite).run
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