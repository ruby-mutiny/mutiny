require "parser/current"
require "unparser"

require_relative "mutant"
require_relative "ast_pattern"
require_relative "ast_replacer"

class Mutator
  attr_reader :mo
  
  def initialize(mo = BinaryOperatorMutation.new)
    @mo = mo
  end
  
  def mutate(program)
    ast = Parser::CurrentRuby.parse(program)
    mo.mutate(ast)
  end
end

class BinaryOperatorMutation
  def mutate(ast)
    pattern.match(ast).map do |match|
      operators_without(match.matched.children[1]).map do |alternative_operator|
        mutated_ast = replacer(alternative_operator).replace(ast, match.location)
        mutated_code = Unparser.unparse(mutated_ast)
        line_number = match.matched.loc.line
        change = alternative_operator
        
        Mutant.new(mutated_code, line_number, change)
      end
    end.flatten
  end
  
private
  def pattern
    AstPattern.new do |ast|
      ast.type == :send && operators.include?(ast.children[1])
    end
  end
  
  def replacer(alternative_operator)
    AstReplacer.new do |old_ast|
      new_children = old_ast.children.dup
      new_children[1] = alternative_operator
      Parser::AST::Node.new(old_ast.type, new_children)
    end
  end
  
  def operators_without(operator)
    operators.select { |o| o != operator }
  end
  
  def operators
    [:<, :<=, :==, :!=, :>, :>=]
  end
end

# (send
# - (send nil :a) :<
# - (send nil :b))

# (send
# - A :<
# - B