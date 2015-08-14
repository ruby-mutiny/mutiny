require 'fileutils'

module Mutiny
  module Mutants
    class Mutant
      attr_reader :subject, :code

      def initialize(subject: nil, code:)
        @subject = subject
        @code = code
      end

      def apply
        # Evaluate the mutanted code, overidding any existing version.
        # We evaluate in the context of TOPLEVEL_BINDING as we want
        # the unit to be evaluated in its usual namespace.
        # rubocop:disable Eval
        eval(code, TOPLEVEL_BINDING)
        # rubocop:enable Eval
      end

      def store(directory, index)
        filename = subject.relative_path.sub(/\.rb$/, ".#{index}.rb")
        path = File.join(directory, filename)

        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w') { |f| f.write(code) }
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
