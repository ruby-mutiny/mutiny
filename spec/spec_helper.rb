require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # Disable old "should" syntax for expressions
    c.syntax = :expect
  end
end