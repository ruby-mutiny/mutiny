require "attributable"
require "mutiny/domain/unit"
require_relative "result"
require_relative "differencer/git"

module Mutiny
  module ChangeDetector
    class CommandLine
      extend Attributable
      attributes :path, :start_label, :finish_label

      def run
        Result.new(
          impacted_units: impacted_units,
          impacted_specs: impacted_specs.map(&:path)
        )
      end

      private

      def impacted_units
        @impacted_units ||= differencer.changed_units
      end

      def impacted_specs
        suite_inspector.specs.select do |spec|
          impacted_units.map(&:path).include?(spec.path) ||
          impacted_units.map(&:path).include?(spec.path_of_described_class)
        end
      end

      def differencer
        @differencer ||= Mutiny::ChangeDetector::Differencer::Git.new(
          repository_path: path,
          start_label: start_label,
          finish_label: finish_label
        )
      end

      def suite_inspector
        @suite_inspector ||= Mutiny::RSpec::SuiteInspector.new(path)
      end
    end
  end
end
