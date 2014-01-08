require "unparser"

require_relative "../mutant"
require_relative "../ast/pattern"

module MutationOperators
  class BinaryOperator
    def mutate(ast)
      pattern.match(ast).flat_map do |match|
        line = match.matched.loc.line
        matched_operator = match.matched.children[1] 
      
        operators_without(matched_operator).map do |alternative_operator|
          match.replace do
            new_children = match.matched.children.dup
            new_children[1] = alternative_operator
            Parser::AST::Node.new(match.matched.type, new_children)
          end
        
          Mutant.new(Unparser.unparse(match.ast), line, alternative_operator)
        end
      end
    end
  
  private
    def pattern
      Ast::Pattern.new do |ast|
        ast.type == :send && operators.include?(ast.children[1])
      end
    end
  
    def operators_without(operator)
      operators.reject { |o| o == operator }
    end
  
    def operators
      [:<, :<=, :==, :'!=', :>, :>=]
    end
  end
end