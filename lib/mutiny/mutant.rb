require "key_struct"

module Mutiny
  class Mutant < KeyStruct.reader(:code, :path, :line, :change, :operator, alive: true)
    attr_accessor :id
    attr_accessor :results

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
      "{Mutant id=#{id.inspect}, path=#{path.inspect}, line=#{line.inspect}, change=#{change.inspect}, operator=#{operator.inspect}}"
    end
  end
end