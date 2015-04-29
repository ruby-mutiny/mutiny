module Mutiny
  module Subjects
    class Environment
      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
        setup
      end

      def subjects
        SubjectSet.new(
          self.class.modules
            .reject { |m| m.name.nil? }
            .select { |m| configuration.patterns.any? { |pattern| pattern.match?(m.name) } }
        )
      end

      def self.modules
        ObjectSpace.each_object(Module)
      end

      private

      def setup
        configuration.loads.each { |l| $LOAD_PATH << l }
        configuration.requires.each { |r| require r }
      end
    end
  end
end
