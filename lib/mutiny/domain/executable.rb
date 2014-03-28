require "attributable"
require "parser/current"
require "mutiny/mutator/ast/match"

module Mutiny
  module Executable
    extend Attributable

    attributes :code

    def class_name
      Mutiny::Mutator::Ast::Match.new(ast, [0, 1]).matched.to_s
    end

    private

    def ast
      @ast ||= Parser::CurrentRuby.parse(code)
    end
  end
end
