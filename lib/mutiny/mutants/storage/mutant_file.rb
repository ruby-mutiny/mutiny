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
          deep_merge(deserialised_contents(path), deserialised_filename(path))
        end

        def store(mutant)
          path = Path.from_relative(root: mutant_directory, path: filename.serialise(mutant))
          FileUtils.mkdir_p(File.dirname(path.absolute))
          File.open(path.absolute, 'w') { |f| f.write(contents.serialise(mutant)) }
        end

        private

        def deep_merge(hash1, hash2)
          hash1.merge(hash2) { |_, h1_member, h2_member| h1_member.merge(h2_member) }
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
