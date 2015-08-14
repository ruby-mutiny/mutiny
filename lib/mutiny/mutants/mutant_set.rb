require_relative "mutant"

module Mutiny
  module Mutants
    class MutantSet
      extend Forwardable
      def_delegators :mutants, :size, :<<, :concat

      def mutants
        @mutants ||= []
      end

      def group_by_subject
        mutants.group_by(&:subject).dup
      end

      def ordered
        group_by_subject.flat_map do |_, mutants|
          mutants.map.with_index do |mutant, index|
            OrderedMutant.new(mutant, index)
          end
        end
      end

      def store(mutant_directory = ".mutants")
        ordered.each { |m| m.store(mutant_directory) }
      end

      class OrderedMutant < SimpleDelegator
        def initialize(mutant, number)
          super(mutant)
          @number = number
        end

        def identifier
          subject.relative_path.sub(/\.rb$/, ".#{@number}.rb")
        end

        def store(directory)
          path = File.join(directory, identifier)
          FileUtils.mkdir_p(File.dirname(path))
          File.open(path, 'w') { |f| f.write(code) }
        end
      end
    end
  end
end
