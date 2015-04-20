require "attributable"
require "mutiny/domain/unit"
require "mutiny/domain/region"

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
        path_specs.map do |path_spec|
          path, region_spec = path_spec.split(":")
          region = RegionParser.new(region_spec).parse
          Mutiny::Unit.new(path: path, code: File.read(path), region: region)
        end
      end

      def path_specs
        if File.directory?(path)
          Dir["#{path}/**/*.rb"]
        else
          [path]
        end
      end

      RegionParser = Struct.new(:specification) do
        def parse
          if specification.nil?
            Region::Everything.new
          else
            Region.new(start_line: lines.first, end_line: lines.last)
          end
        end

        private

        def lines
          if specification.include? ".."
            specified_lines
          else
            specified_line
          end
        end

        def specified_lines
          specification.split("..").map(&:to_i)
        end

        def specified_line
          [specification.to_i, specification.to_i]
        end
      end
    end
  end
end
