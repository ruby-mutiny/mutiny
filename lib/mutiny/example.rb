require "key_struct"

module Mutiny
  class Example < KeyStruct.reader(:id, :spec_path, :name)
  end
end