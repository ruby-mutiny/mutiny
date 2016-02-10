require "fileutils"
require_relative "path"
require_relative "mutant_file_name"
require_relative "mutant_file_contents"

module Mutiny
  module Mutants
    class Storage
      class MutantFile
        attr_reader :mutant_directory

        def initialize(mutant_directory)
          @mutant_directory = mutant_directory
        end

        def load(absolute_path)
          path = Path.from_absolute(path: absolute_path, root: mutant_directory)
          deserialise
            .merge(deserialised_contents(path)) { |_, left, right| left.merge(right) }
            .merge(deserialised_filename(path)) { |_, left, right| left.merge(right) }
        end

        def store(mutant)
          path = Path.from_relative(root: mutant_directory, path: filename.serialise(mutant))
          FileUtils.mkdir_p(File.dirname(path.absolute))
          File.open(path.absolute, 'w') { |f| f.write(contents.serialise(mutant)) }
        end

        private

        def deserialise
          {
            subject: { root: mutant_directory }
          }
        end

        def deserialised_filename(path)
          filename.deserialise(path.relative)
        end

        def deserialised_contents(path)
          contents.deserialise(File.read(path.absolute))
        end

        def filename
          @filename ||= MutantFileName.new
        end

        def contents
          @contents ||= MutantFileContents.new
        end
      end
    end
  end
end
