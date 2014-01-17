require "key_struct"

module Mutiny
  class Mutant < KeyStruct.reader(:id, :code, :line, :change, :operator, alive: true)

    alias_method :executable, :code
    alias_method :readable, :code
    
    alias_method :alive?, :alive
    
    def killed?
      !alive?
    end
    
    def kill
      @alive = false
    end
    
    def inspect
      "{Mutant id=#{id.inspect}, line=#{line.inspect}, change=#{change.inspect}, operator=#{operator.inspect}}"
    end
  end
end