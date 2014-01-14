require 'coveralls'
Coveralls.wear!

require_relative 'helpers/file_system'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # Disable old "should" syntax for expressions
    c.syntax = :expect
  end
  
  config.treat_symbols_as_metadata_keys_with_true_values = true # Prepare for RSpec 3
  config.include Helpers::FileSystem, :include_file_system_helpers
end