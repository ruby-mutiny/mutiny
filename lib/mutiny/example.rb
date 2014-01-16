require "key_struct"

module Mutiny
  class Example < KeyStruct.reader(:id, :spec_path, :name, :line)
    def inspect
      "{Example id=#{id.inspect}, spec_path=#{spec_path.inspect}, name=#{name.inspect}, line=#{line.inspect}}"
    end
  end
end