require "key_struct"

module Mutiny
  class Mutant < KeyStruct.reader(:id, :code, :line, :change, :operator)

    alias_method :executable, :code
    alias_method :readable, :code
  end
end