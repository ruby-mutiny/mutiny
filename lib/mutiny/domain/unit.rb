require_relative "executable"
require_relative "../valuable/valuable"

module Mutiny
  class Unit
    include Executable
    
    extend Valuable
    attributes :path
    
    attr_accessor :id, :results
  end
end