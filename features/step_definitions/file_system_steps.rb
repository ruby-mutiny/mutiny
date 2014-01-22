Given(/^I have the following program at "(.*?)":$/) do |path, program|
  write(path, program)
end

Given(/^I have the following spec at "(.*?)":$/) do |path, spec|
  write(path, spec)
end

Then(/^the file at "(.*?)" should contain the following mutants:$/) do |path, expected_results|
  deserialised = Psych.load(read(path))
  
  deserialised[:mutants].length.should eq(expected_results.hashes.length)

  expected_results.map_headers! { |header| header.downcase.to_sym }
  expected_results.map_column!("ID") { |v| v.to_i }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Change") { |v| v.to_sym }
  expected_results.map_column!("Alive") { |v| v == "true" }

  expect(expected_results.hashes).to eq(deserialised[:mutants].values)
end