require_relative "../valuable/valuable"
require "parser/current"
require_relative "../ast/match"

module Mutiny
  module Executable
    extend Valuable
    
    attributes :code
    
    def class_name
      Mutiny::Ast::Match.new(ast, [0, 1]).matched.to_s
    end
  
  private
    def ast
      @ast ||= Parser::CurrentRuby.parse(code)
    end
  end
end