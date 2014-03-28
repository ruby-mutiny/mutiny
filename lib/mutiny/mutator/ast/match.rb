module Mutiny
  module Mutator
    module Ast
      class Match < Struct.new(:ast, :location)
        def matched
          location.reduce(ast) do |current_node, child_index|
            current_node.children.fetch(child_index)
          end
        end

        def line
          matched.loc.line
        end

        def column
          matched.loc.column
        end

        def replace(&replacer)
          if location.empty?
            replaced = replacer.call(replacement_helper)
          else
            index = location.first
            replacement = child.replace(&replacer).ast
            replaced = replacement_helper.replace_child(index, replacement)
          end
          Match.new(replaced, location)
        end

        def child
          unless location.empty?
            first, *rest = *location
            Match.new(ast.children[first], rest)
          end
        end

        private

        def replacement_helper
          ReplacementHelper.new(ast)
        end
      end

      class ReplacementHelper < Struct.new(:ast)
        def replace(replacement, children = [])
          Parser::AST::Node.new(replacement, children)
        end

        def replace_child(index, child)
          new_children = ast.children.dup
          new_children[index] = child
          Parser::AST::Node.new(ast.type, new_children)
        end
      end
    end
  end
end
