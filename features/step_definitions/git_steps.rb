require "rugged"

Given(/^I have a new Git repository$/) do
  @repository = Rugged::Repository.init_at(path)
end

Given(/^I stage my changes to "(.*?)"$/) do |relative_path|
  @repository.index.add(relative_path)
end

Given(/^I commit my changes$/) do
  Rugged::Commit.create(@repository, commit_options)
end

def commit_options
  {
    author:  { email: "john@doe.com", name: "John Doe", time: Time.now },
    committer: { email: "john@doe.com", name: "John Doe", time: Time.now },
    message: "No message",
    tree: @repository.index.write_tree(@repository),
    parents: @repository.empty? ? [] : [@repository.head.target].compact,
    update_ref: "HEAD"
  }
end
