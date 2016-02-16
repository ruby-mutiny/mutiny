require_relative "mutant_file"

module Mutiny
  module Mutants
    class Storage
      class FileStore
        attr_reader :mutant_directory, :strategy

        def initialize(mutant_directory: ".mutants")
          @mutant_directory = mutant_directory
          @strategy = MutantFile.new(mutant_directory)
        end

        def save_all(mutants)
          mutants.ordered.each do |mutant|
            strategy.store(mutant)
          end
        end

        def load_all
          absolute_paths = Dir.glob(File.join(mutant_directory, "**", "*.rb"))
          absolute_paths.sort.map { |path| strategy.load(path) }
        end
      end
    end
  end
end
