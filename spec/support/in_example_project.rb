require 'aruba/api'
require 'aruba/reporting'

module InExampleProject
  def in_example_project(example_name, should_require = false)
    in_sub_process do
      $LOAD_PATH << File.join(Dir.pwd, "examples", example_name, "lib")
      Dir.chdir(File.join("examples", example_name))
      require example_name if should_require
      yield
    end
  end
end

RSpec.configure do |config|
  config.include InExampleProject
end
