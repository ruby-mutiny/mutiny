require_relative "../integration/rspec"

module Mutiny
  class CLI
    class Check
      def self.run(environment)
        tests = environment.subjects.flat_map do |subject|
          integration.tests_for(subject)
        end

        puts integration.call(tests)[:output]
      end

      def self.integration
        @integration ||= Integration::RSpec.new.setup
      end
    end
  end
end
