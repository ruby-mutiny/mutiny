require_relative "../../lib/mutiny"

Given(/^I have the following program:$/) do |program|
  @program = program
end

Given(/^I have the following test:$/) do |test|
  @tests ||= []
  @tests << Test.new(@tests.length, test)
end

When(/^I run mutiny$/) do
  @results = Mutiny.new(@program, @tests).run
end

Then(/^I should receive the following results:$/) do |expected_results|
  @results.length.should eq(expected_results.hashes.length)

  expected_results.hashes.each do |row|
    @results.for(row['Line'].to_i, row['Change'].to_sym).should eq(row['Result'].to_sym)
  end
end