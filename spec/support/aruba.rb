require 'aruba/api'
require 'aruba/reporting'

RSpec.configure do |config|
  config.include Aruba::Api

  config.before(:each) do
    @dirs = [File.join(Dir.pwd, "examples")]
    restore_env
    set_env "GLI_DEBUG", "true"
  end
end
