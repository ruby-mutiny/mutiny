require "git"

Given(/^I have a new Git repository$/) do
  @repository = Git.init(path)
end

Given(/^I stage my changes to "(.*?)"$/) do |relative_path|
  @repository.add(path(relative_path))
end

Given(/^I commit my changes$/) do
  @repository.commit('No message')
end