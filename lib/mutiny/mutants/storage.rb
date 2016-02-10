require_relative "storage/file_store"

module Mutiny
  module Mutants
    class Storage
      attr_accessor :store

      def initialize(mutant_directory: ".mutants", store: nil)
        @store = store || FileStore.new(mutant_directory: mutant_directory)
      end

      def save(mutants)
        store.save_all(mutants)
      end

      def load
        mutants = store.load_all.map do |mutant_specification|
          subject = Subjects::Subject.new(**mutant_specification[:subject])
          mutant_specification[:subject] = subject
          Mutant.new(**mutant_specification)
        end

        MutantSet.new(*mutants)
      end
    end
  end
end
