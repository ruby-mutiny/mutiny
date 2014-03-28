require "attributable"
require "mutiny/domain/unit"

module Mutiny
  module Mutator
    class CommandLine
      extend Attributable
      attributes :path, :operator

      def run
        harness.generate_mutants(units)
      end

      private

      def harness
        @harness ||= Mutiny::Mutator::MutationHarness.new(operator_name: operator)
      end

      def units
        paths.map do |path|
          Mutiny::Unit.new(path: path, code: File.read(path))
        end
      end

      def paths
        if File.directory?(path)
          Dir["#{path}/*.rb"]
        else
          [path]
        end
      end
    end
  end
end
