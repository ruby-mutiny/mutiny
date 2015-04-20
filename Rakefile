require "rubygems"
require "cucumber"
require "cucumber/rake/task"

require "rspec/core/rake_task"

require "coveralls/rake/task"
Coveralls::RakeTask.new

task default: ["test:acceptance", "test:unit", "coveralls:push", "style:check"]

namespace :test do
  Cucumber::Rake::Task.new(:acceptance) do |t|
    t.cucumber_opts = "features --format pretty --tags ~@wip"
  end

  Cucumber::Rake::Task.new(:focus) do |t|
    t.cucumber_opts = "features --format pretty --tags @focus"
  end

  RSpec::Core::RakeTask.new(:unit)
end

namespace :style do
  require "rubocop/rake_task"

  desc "Run RuboCop on the lib directory"
  RuboCop::RakeTask.new(:check) do |task|
    task.options = ["--auto-correct"]
  end
end
