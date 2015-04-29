require_relative 'pattern'
require_relative 'reporter/stdout'
require_relative 'integration/rspec'

module Mutiny
  class Configuration
    attr_reader :loads, :requires, :patterns, :reporter, :integration

    def initialize(loads: [], requires: [], patterns: [])
      @loads, @requires, @patterns = loads, requires, patterns
      @patterns.map!(&Pattern.method(:new))

      @reporter = Reporter::Stdout.new
      @integration = Integration::RSpec.new
    end
  end
end
