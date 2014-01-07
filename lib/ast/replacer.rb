module Ast
  class Replacer
    def initialize(&replacer)
      @replacer = replacer
    end
  
    def replace(replacee, location)
      location = location.dup # defensive copy to prevent modifying caller's array
    
      if location == []
        @replacer.call(replacee)

      elsif replacee.is_a? Parser::AST::Node
        child_location = location.shift
        new_children = replacee.children.dup
        new_children[child_location] = replace(new_children[child_location], location)
        Parser::AST::Node.new(replacee.type, new_children)
      end
    end
  end
end