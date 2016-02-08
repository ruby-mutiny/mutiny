require_relative "mutant"
require "delegate"

module Mutiny
  module Mutants
    class MutantSet
      extend Forwardable
      def_delegators :mutants, :size, :<<, :concat

      attr_reader :mutants

      def initialize(*mutants)
        @mutants = mutants
      end

      def group_by_subject
        mutants.group_by(&:subject).dup
      end

      def ordered
        group_by_subject.flat_map do |_, mutants|
          mutants.map.with_index do |mutant, index|
            OrderedMutant.new(mutant, mutant.identifier || index)
          end
        end
      end

      def store(mutant_directory = ".mutants")
        ordered.each { |m| m.store(mutant_directory) }
      end

      def eql?(other)
        other.mutants == mutants
      end

      alias_method "==", "eql?"

      def hash
        mutants.hash
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
          File.open(path, 'w') { |f| f.write(serialised) }
        end

        def serialised
          "# " + subject.name + "\n" \
          "# " + mutation_name + "\n" +
            code
        end
      end
    end
  end
end
