require_relative "match"
require "mutiny/domain/region"

module Mutiny
  module Mutator
    module Ast
      class Pattern
        attr_reader :matcher

        def initialize(&matcher)
          @matcher = matcher
        end

        def match(ast, scope = DefaultScope.new, location = [])
          @root ||= ast
          matches = []
          matches << Match.new(@root, location) if scope.include?(ast) && matcher.call(ast)
          matches << match_children(ast, scope, location)
          matches.flatten
        end

        def match_children(ast, scope, location)
          ast.children
            .each_with_index
            .map do |child, index|
              match(child, scope, location.dup << index) if child.is_a? Parser::AST::Node
            end
            .compact
        end
      end

      class DefaultScope
        def include?(_ast)
          true
        end
      end
    end
  end
end
