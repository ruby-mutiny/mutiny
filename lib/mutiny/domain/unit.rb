require "attributable"
require_relative "executable"

module Mutiny
  class Unit
    include Executable
    
    extend Attributable
    attributes :path
    
    attr_accessor :results
  end
end