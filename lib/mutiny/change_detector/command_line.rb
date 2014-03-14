require "attributable"
require_relative "differencer/git"

module Mutiny
  module ChangeDetector
    class CommandLine
      extend Attributable
      attributes :path, :start_label, :finish_label
  
      def run
        changed_paths = differencer.changed_paths
        
        impacted_specs = suite_inspector.specs.select do |spec|
          changed_paths.include?(spec.path) ||
          changed_paths.include?(spec.path_of_described_class)
        end
        
        impacted_paths = impacted_specs.map(&:path)
      end
    
    private
      def differencer
        @differencer ||= Mutiny::ChangeDetector::Differencer::Git.new(path: path, start_label: start_label, finish_label: finish_label)
      end
    
      def suite_inspector
        @suite_inspector ||= Mutiny::RSpec::SuiteInspector.new(path)
      end
    end
  end
end