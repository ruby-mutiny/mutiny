Given(/^I have the following program at "(.*?)":$/) do |path, program|
  write(path, program)
end

Given(/^I have the following spec at "(.*?)":$/) do |path, spec|
  write(path, spec)
end