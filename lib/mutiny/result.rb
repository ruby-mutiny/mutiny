require "key_struct"

module Mutiny
  class Result < KeyStruct.reader(:mutant, :example, :status)
  end
end