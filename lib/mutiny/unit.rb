require "key_struct"
require "parser/current"
require_relative "ast/match"

module Mutiny
  class Unit < KeyStruct.reader(:code, :path)
    attr_accessor :id
    attr_accessor :results

    alias_method :executable, :code
    alias_method :readable, :code
    
    def class_name
      Mutiny::Ast::Match.new(ast, [0, 1]).matched.to_s
    end
    
    def inspect
      "{Unit id=#{id.inspect}, path=#{path.inspect}"
    end
  
  private
    def ast
      @ast ||= Parser::CurrentRuby.parse(code)
    end
  end
end