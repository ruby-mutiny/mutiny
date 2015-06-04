require "metamorpher"

module Mutiny
  module Mutants
    class Mutation
      include Metamorpher::Mutator
      include Metamorpher::Builders::AST
    end
  end
end
