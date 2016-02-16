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

      def load_for(subjects)
        mutants = store.load_all.map do |mutant_spec|
          mutant_spec[:subject] = resolve_subject(subjects, **mutant_spec[:subject])
          Mutant.new(**mutant_spec)
        end

        MutantSet.new(*mutants)
      end

      private

      def resolve_subject(subjects, name:, path:)
        subjects.find { |subject| subject.name == name && subject.relative_path == path }
      end
    end
  end
end
