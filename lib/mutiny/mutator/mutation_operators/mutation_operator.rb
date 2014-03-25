require "unparser"

require "mutiny/domain/mutant"
require_relative "../ast/pattern"

module Mutiny
  module Mutator
    module MutationOperators
      class MutationOperator
        def mutate(ast, original_path)
          pattern.match(ast).flat_map do |mutation_point|
            replacements = replacer(mutation_point)
            
            replacements.map do |replacement|
              create_mutant_from(original_path, replacement, mutation_point)
            end
          end
        end
        
      private
        def create_mutant_from(path, replacement, mutation_point)
          Mutiny::Mutant.new(
            path: path,
            code: Unparser.unparse(replacement.first.ast),
            change: replacement.last,
            line: mutation_point.line,
            column: mutation_point.column,
            operator: self.class.name
          )
        end
      end
    end
  end
end