require_relative "mutant/location"

module Mutiny
  module Mutants
    class Mutant
      attr_reader :subject, :code, :mutation_name, :stillborn, :location
      attr_accessor :index
      alias_method :stillborn?, :stillborn

      def initialize(subject: nil, code:, mutation_name: nil, index: nil, position: nil)
        @subject = subject
        @code = code
        @mutation_name = mutation_name
        @index = index
        @stillborn = false
        @location = Location.new(position: position, content: code)
      end

      def identifier
        subject.relative_path.sub(/\.rb$/, ".#{index}.rb")
      end

      def apply
        # Evaluate the mutated code, overidding any existing version.
        # We evaluate in the context of TOPLEVEL_BINDING as we want
        # the unit to be evaluated in its usual namespace.
        # rubocop:disable Eval
        eval(code, TOPLEVEL_BINDING)
        # rubocop:enable Eval
      rescue
        @stillborn = true
      end

      def eql?(other)
        other.subject == subject && other.code == code
      end

      alias_method "==", "eql?"

      def hash
        [subject, code].hash
      end
    end
  end
end
