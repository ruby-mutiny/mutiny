module Ast
  class Match < Struct.new(:ast, :location)  
    def matched
      location.inject(ast) do |current_node, child_index|
        current_node.children.fetch(child_index)
      end
    end

    def replace(&replacer)
      if location.empty?
        self.ast = replacer.call
      else
        self.ast = replace_child(ast, location.first, child.replace(&replacer))
      end
    end
    
    def child
      unless location.empty?
        first, *rest = *location
        Match.new(ast.children[first], rest)
      end
    end
  
  private
    def replace_child(node, index, child)
      new_children = node.children.dup
      new_children[index] = child
      Parser::AST::Node.new(node.type, new_children)
    end
  end
end
