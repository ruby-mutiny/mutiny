require_relative "match"

module Mutiny
  module Mutator
    module Ast
      class Pattern
        attr_reader :matcher

        def initialize(&matcher)
          @matcher = matcher
        end

        def match(ast, location = [])
          @root ||= ast
          matches = []
          matches << Match.new(@root, location) if matcher.call(ast)
          matches << match_children(ast, location)
          matches.flatten
        end

        private

        def match_children(ast, location)
          ast.children
            .each_with_index
            .map do |child, index|
              match(child, location.dup << index) if child.is_a? Parser::AST::Node
            end
            .compact
        end
      end
    end
  end
end
