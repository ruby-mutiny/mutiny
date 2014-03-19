require "unparser"

require "mutiny/domain/mutant"
require_relative "../ast/pattern"

module Mutiny
  module Mutator
    module MutationOperators
      class MutationOperator < Struct.new(:pattern, :replacer, :operator)
        def mutate(ast, original_path)
          pattern.match(ast).flat_map do |mutation_point|
            replacements = replacer.call(mutation_point)
            
            replacements.map do |replacement|
              create_mutant_from(original_path, replacement.first.ast, replacement.last, mutation_point.line)
            end
          end
        end
        
      private
        def create_mutant_from(path, ast, change, line)
          Mutiny::Mutant.new(
            path: path,
            code: Unparser.unparse(ast),
            line: line,
            change: change,
            operator: operator
          )
        end
      end
    end
  end
end