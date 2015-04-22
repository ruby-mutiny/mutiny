require 'aruba/api'
require 'aruba/reporting'

RSpec.configure do |config|
  config.include Aruba::Api

  config.before(:all) do
    @dirs = [File.join(Dir.pwd, "examples")]
  end

  config.before(:each) do
    restore_env
    set_env "GLI_DEBUG", "true"
  end
end
