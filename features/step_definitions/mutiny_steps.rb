require_relative "../../lib/mutiny"

Given(/^I have the following program:$/) do |program|
  @program = program
end

Given(/^I have the following test suite:$/) do |tests|
  @tests = tests.lines.each_with_index.map { |test, index| Test.new(index, test) }
end

When(/^I run mutiny$/) do
  @results = Mutiny.new(@program, @tests).run
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