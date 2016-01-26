require "metamorpher"

module Mutiny
  module Mutants
    class Mutation
      include Metamorpher::Mutator
      include Metamorpher::Builders::AST

      def name
        self.class.name
      end

      def short_name
        name.split("::").last
      end
    end
  end
end
