require 'fileutils'

module Mutiny
  module Mutator
    class Mutant
      attr_reader :subject, :code

      def initialize(subject:, code:)
        @subject = subject
        @code = code
      end

      def store(directory, index)
        filename = subject.relative_path.sub(/\.rb$/, ".#{index}.rb")
        path = File.join(directory, filename)

        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w') { |f| f.write(code) }
      end
    end
  end
end
