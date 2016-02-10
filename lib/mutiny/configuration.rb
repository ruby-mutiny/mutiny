require_relative 'pattern'
require_relative 'reporter/stdout'
require_relative 'tests/selection/default'
require_relative 'integration/rspec'
require_relative 'mutants/ruby'
require_relative 'mutants/storage'

module Mutiny
  class Configuration
    attr_reader :loads, :requires, :patterns, :reporter, :mutants, :tests

    def initialize(loads: [], requires: [], patterns: [])
      @loads = loads
      @requires = requires
      @patterns = patterns
      @patterns.map!(&Pattern.method(:new))

      @reporter = Reporter::Stdout.new
      @mutants = Mutants.new
      @tests = Tests.new
    end

    def load_paths
      loads.map(&File.method(:expand_path))
    end

    def can_load?(source_path)
      load_paths.any? { |load_path| source_path.start_with?(load_path) }
    end

    class Mutants
      attr_reader :mutator, :storage

      def initialize
        @mutator = Mutiny::Mutants::Ruby.new
        @storage = Mutiny::Mutants::Storage.new
      end
    end

    class Tests
      attr_reader :selection, :integration

      def initialize
        @selection = Mutiny::Tests::Selection::Default.new
        @integration = Mutiny::Integration::RSpec.new(@selection)
      end
    end
  end
end
