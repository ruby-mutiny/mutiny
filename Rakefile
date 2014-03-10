require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

require 'rspec/core/rake_task'

task default: ["test:acceptance", "test:unit"]

namespace :test do
  Cucumber::Rake::Task.new(:acceptance) do |t|
    t.cucumber_opts = "features --format pretty --tags ~@wip"
  end

  Cucumber::Rake::Task.new(:focus) do |t|
    t.cucumber_opts = "features --format pretty --tags @focus"
  end
  
  RSpec::Core::RakeTask.new(:unit)
end