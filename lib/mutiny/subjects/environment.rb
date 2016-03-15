require_relative "environment/type"

module Mutiny
  module Subjects
    class Environment
      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
        configuration.loads.each { |l| $LOAD_PATH << l }
        configuration.requires.each { |r| require r }
      end

      def subjects
        SubjectSet.new(modules.select(&:relevant?).map(&:to_subject)).per_file
      end

      private

      def modules
        ObjectSpace.each_object(Module).map { |mod| Type.new(mod, configuration) }
      end
    end
  end
end
