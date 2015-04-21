require "unparser"

require_relative "../../domain/mutant"
require_relative "../ast/pattern"

module Mutiny
  module Mutator
    module MutationOperators
      class MutationOperator
        def mutate(unit)
          mutation_points_for(unit).flat_map do |mutation_point|
            replacements = replacer(mutation_point)

            replacements.map do |replacement|
              create_mutant_from(unit.path, replacement, mutation_point)
            end
          end
        end

        private

        def mutation_points_for(unit)
          pattern.match(unit.ast, unit.region)
        end

        def create_mutant_from(path, replacement, mutation_point)
          Mutiny::Mutant.new(
            path: path,
            code: Unparser.unparse(replacement.first.ast),
            change: replacement.last,
            line: mutation_point.line,
            column: mutation_point.column,
            operator: self.class.name.split("::").last
          )
        end
      end
    end
  end
end
