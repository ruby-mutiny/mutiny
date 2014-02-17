require "key_struct"

module Mutiny
  class Example < KeyStruct.reader(:spec_path, :name, :line)
    attr_accessor :id
    
    def inspect
      "{Example id=#{id.inspect}, spec_path=#{spec_path.inspect}, name=#{name.inspect}, line=#{line.inspect}}"
    end
  end
end