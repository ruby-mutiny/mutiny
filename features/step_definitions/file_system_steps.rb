Given(/^I have the following program at "(.*?)":$/) do |path, program|
  write(path, program)
end

Given(/^I have the following spec at "(.*?)":$/) do |path, spec|
  write(path, spec)
end

Then(/^the file at "(.*?)" should contain the following mutants:$/) do |path, expected_results|
  deserialised = Psych.load(read(path))
  
  deserialised[:mutants].length.should eq(expected_results.hashes.length)

  expected_results.map_headers!{ |header| header.downcase.gsub(" ", "_").to_sym }
  expected_results.map_column!("ID") { |v| v.to_i }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Change") { |v| v.to_sym }
  expected_results.map_column!("Alive") { |v| v == "true" }

  expect(deserialised[:mutants].values).to eq(expected_results.hashes)
end

Then(/^the file at "(.*?)" should contain the following examples:$/) do |path, expected_results|
  deserialised = Psych.load(read(path))
  
  deserialised[:examples].length.should eq(expected_results.hashes.length)

  expected_results.map_headers!{ |header| header.downcase.gsub(" ", "_").to_sym }
  expected_results.map_column!("ID") { |v| v.to_i }
  expected_results.map_column!("Line") { |v| v.to_i }
  expected_results.map_column!("Spec Path") { |v| path(v) }

  expect(deserialised[:examples].values).to eq(expected_results.hashes)
end

Then(/^the file at "(.*?)" should contain the following results:$/) do |path, expected_results|
  deserialised = Psych.load(read(path))
  
  deserialised[:results].length.should eq(expected_results.hashes.length)

  expected_results.map_headers!{ |header| header.downcase.gsub(" ", "_").to_sym }
  expected_results.map_column!("ID") { |v| v.to_i }
  expected_results.map_column!("Mutant ID") { |v| v.to_i }
  expected_results.map_column!("Example ID") { |v| v.to_i }

  expect(deserialised[:results].values).to eq(expected_results.hashes)
end