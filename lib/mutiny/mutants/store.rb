module Mutiny
  module Mutants
    class Store
      attr_reader :mutant_directory

      def initialize(mutant_directory: ".mutants")
        @mutant_directory = mutant_directory
      end

      def load_for(subjects)
        MutantSet.new.tap do |mutants|
          files.each do |file|
            mutants << file_to_mutant(file, subjects)
          end
        end
      end

      private

      def file_to_mutant(file, subjects)
        subject = subjects.detect { |s| s.name == file.subject_name }
        code = file.code
        mutation_name = file.mutation_name
        identifier = file.identifier

        Mutant.new(
          subject: subject,
          code: code,
          mutation_name: mutation_name,
          identifier: identifier
        )
      end

      def files
        absolute_paths.map { |absolute_path| MutantFile.new(absolute_path) }
      end

      def absolute_paths
        Dir.glob(File.join(mutant_directory, "**", "*.rb"))
      end

      class MutantFile
        attr_reader :absolute_path

        def initialize(absolute_path)
          @absolute_path = absolute_path
        end

        def subject_name
          extract_contents_of_comment(contents.lines[0])
        end

        def mutation_name
          extract_contents_of_comment(contents.lines[1])
        end

        def code
          contents.lines.drop(2).join
        end

        def identifier
          absolute_path.match(/.*.(\d+).rb/)[1]
        end

        private

        def extract_contents_of_comment(line)
          line[2..-1].strip
        end

        def contents
          @contents ||= File.read(absolute_path)
        end
      end
    end
  end
end
