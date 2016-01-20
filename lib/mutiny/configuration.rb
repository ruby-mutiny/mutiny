require_relative 'pattern'
require_relative 'reporter/stdout'
require_relative 'integration/rspec'
require_relative 'mutants/ruby'

module Mutiny
  class Configuration
    attr_reader :loads, :requires, :patterns, :reporter, :integration, :mutator

    def initialize(loads: [], requires: [], patterns: [])
      @loads = loads
      @requires = requires
      @patterns = patterns
      @patterns.map!(&Pattern.method(:new))

      @reporter = Reporter::Stdout.new
      @integration = Integration::RSpec.new
      @mutator = Mutants::Ruby.new
    end

    def load_paths
      loads.map(&File.method(:expand_path))
    end

    def can_load?(source_path)
      load_paths.any? { |load_path| source_path.start_with?(load_path) }
    end
  end
end
