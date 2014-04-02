require "mutiny/change_detector/command_line"

When(/^I run the change detector between "(.*?)" and "(.*?)"$/) do |start_label, finish_label|
  options = { path: path, start_label: start_label, finish_label: finish_label }
  @result = Mutiny::ChangeDetector::CommandLine.new(options).run
end

Then(/^(\d+) spec is impacted$/) do |expected_number|
  expect(@result.impacted_specs.size).to eq(expected_number.to_i)
end

Then(/^(\d+) units? (is|are) impacted$/) do |expected_number, _|
  expect(@result.impacted_units.size).to eq(expected_number.to_i)
end

Then(/^the spec at "(.*?)" is impacted$/) do |expected_spec|
  expect(@result.impacted_specs).to include(path(expected_spec))
end

Then(/^the unit at "(.*?)" is impacted at lines (\d+)..(\d+)$/) do |rel_path, start_line, end_line|
  units = @result.impacted_units.select { |u| u.path == path(rel_path) }

  start_lines = units.map(&:region).map(&:start_line)
  end_lines = units.map(&:region).map(&:end_line)

  expect(start_lines).to include(start_line.to_i)
  expect(end_lines).to include(end_line.to_i)
end
