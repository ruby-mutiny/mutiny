require "attributable"
require_relative "differencer/git"

module Mutiny
  module ChangeDetector
    class CommandLine
      extend Attributable
      attributes :path, :start_label, :finish_label
  
      def run
        changed_paths = differencer.changed_paths
        
        impacted_paths = Set.new(suite_inspector.paths_of_specs & changed_paths) + (suite_inspector.paths_of_specs_dependent_on(changed_paths))
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