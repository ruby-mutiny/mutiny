require "key_struct"
require "mutiny/mutant"
require "mutiny/example"

module Mutiny
  class Result < KeyStruct.reader(:mutant, :example, :status)
    attr_accessor :id
    
    def inspect
      "{Result mutant=#{mutant.inspect}, example=#{example.inspect}, status=#{status.inspect}}"
    end
  end
end